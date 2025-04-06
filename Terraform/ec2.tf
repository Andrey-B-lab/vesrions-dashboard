resource "aws_instance" "jenkins_server" {
  ami           = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.my_ip_ssh.id]
  key_name               = var.key_pair_name  # taken from variables.tf

  root_block_device {
    volume_size = 10  # 10GB is a recommended minimum if running Jenkins as a Docker container
    volume_type = "gp2"
  }

  tags = {
    Name = "JenkinsServer"
  }

user_data = <<-EOF
            #!/bin/bash
            # Update the package index
            sudo apt-get update -y

            # Install prerequisite packages
            sudo apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                software-properties-common

            # Add Docker’s official GPG key
            curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

            # Add Docker’s official APT repository
            echo \
              "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

            # Update the package index again to include Docker packages
            sudo apt-get update -y

            # Install Docker
            sudo apt-get install -y docker-ce docker-ce-cli containerd.io

            # Start Docker service
            sudo systemctl start docker

            # Enable Docker to start on boot
            sudo systemctl enable docker

            # Add the ec2-user to the docker group to run Docker without sudo
            sudo usermod -aG docker ubuntu

            # Pull the Jenkins Docker image
            sudo docker pull jenkins/jenkins:lts

            # Create a Jenkins directory for persistent storage
            sudo mkdir -p /var/jenkins_home
            sudo chown -R 1000:1000 /var/jenkins_home

            # Run Jenkins in a Docker container
            sudo docker run -d -p 8080:8080 -p 50000:50000 \
              --name jenkins \
              -v /var/jenkins_home:/var/jenkins_home \
              jenkins/jenkins:lts
            EOF
}
