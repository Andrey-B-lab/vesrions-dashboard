output "instance_ip" {    # I will see the instance public IP as an output in my console
  value = aws_instance.jenkins_server.public_ip
}
