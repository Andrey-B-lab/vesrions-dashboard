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
              # Update the package index
              apt-get update -y

              # Install prerequisite packages
              apt-get install -y \
                apt-transport-https \
                ca-certificates \
                curl \
                software-properties-common \
                gnupg \
                lsb-release

              # Add Docker's GPG key
              curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

              # Add Docker repo
              echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
              $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

              # Install Docker
              apt-get update -y
              apt-get install -y docker-ce docker-ce-cli containerd.io

              # Start and enable Docker
              systemctl start docker
              systemctl enable docker

              # Add default user to docker group
              usermod -aG docker ubuntu

              # Pull Docker images
              docker pull jenkins/jenkins:lts
              docker pull grafana/grafana
              docker pull postgres

              # Create volumes
              docker volume create jenkins_data
              docker volume create grafana_data
              docker volume create postgres_data

              # Run Jenkins
              docker run -d --name jenkins \
                -p 8080:8080 -p 50000:50000 \
                -v jenkins_data:/var/jenkins_home \
                jenkins/jenkins:lts

              # Run Grafana
              docker run -d --name grafana \
                -p 3000:3000 \
                -v grafana_data:/var/lib/grafana \
                grafana/grafana

              # Run PostgreSQL
              docker run -d --name postgres \
                -e POSTGRES_PASSWORD=admin \
                -e POSTGRES_USER=admin \
                -e POSTGRES_DB=app_db \
                -p 5432:5432 \
                -v postgres_data:/var/lib/postgresql/data \
                postgres
              EOF
}
