resource "aws_instance" "jenkins_server" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.small"

  vpc_security_group_ids = [aws_security_group.my_ip_ssh.id]
  key_name               = var.key_pair_name

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }

  tags = {
    Name = "JenkinsServer"
  }

  user_data = <<-EOF
              #!/bin/bash
              apt-get update -y
              apt-get install -y docker.io git

              # Enable Docker
              systemctl start docker
              systemctl enable docker

              # Add ubuntu user to docker group
              usermod -aG docker ubuntu

              # Install Docker Compose
              curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose

              # Create Jenkins directory
              mkdir -p /home/ubuntu/jenkins_compose
              cd /home/ubuntu/jenkins_compose

              # Create Dockerfile
              cat <<EOL > Dockerfile
              FROM jenkins/jenkins:lts

              USER root

              RUN apt-get update && \
                  apt-get install -y docker.io python3 python3-pip curl gnupg jq postgresql-client && \
                  curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
                  apt-get install -y nodejs && \
                  usermod -aG docker jenkins

              USER jenkins
              EOL

              # Create docker-compose.yml
              cat <<EOL > docker-compose.yml
              version: '3'
              services:
                jenkins:
                  build: .
                  image: custom-jenkins:with-tools
                  restart: always
                  privileged: true
                  user: root
                  ports:
                    - 8080:8080
                    - 50000:50000
                  container_name: jenkins
                  environment:
                    - JAVA_OPTS=-Dhudson.security.csrf.GlobalCrumbIssuerConfiguration.DISABLE_CSRF_PROTECTION=true
                  volumes:
                    - /home/ubuntu/jenkins_compose/jenkins_configuration:/var/jenkins_home
                    - /var/run/docker.sock:/var/run/docker.sock
                    - /home/ubuntu/apps:/apps
              EOL

              # Create folders for volumes
              mkdir -p /home/ubuntu/jenkins_compose/jenkins_configuration
              mkdir -p /home/ubuntu/apps

              # Change ownership
              chown -R ubuntu:ubuntu /home/ubuntu/jenkins_compose

              # Switch to ubuntu user and build + run docker-compose
              su - ubuntu -c "cd /home/ubuntu/jenkins_compose && docker-compose up -d"
              EOF
}
