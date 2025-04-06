data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "my_ip_ssh" {
  name        = "sg-my-ip-ssh"
  description = "Allow SSH from my IP"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "sg-my-ip-ssh"
  }
}

resource "aws_vpc_security_group_ingress_rule" "my_ip_ssh_ingress" {
  security_group_id = aws_security_group.my_ip_ssh.id
  description       = "SSH from my IP"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = var.my_ip_address
}

resource "aws_vpc_security_group_egress_rule" "my_ip_ssh_egress" {
  security_group_id = aws_security_group.my_ip_ssh.id
  description       = "Allow all outbound"
  from_port         = 0
  to_port           = 0
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
