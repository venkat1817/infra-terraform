resource "aws_security_group" "grafana-sg" {
  name        = "grafana-sg"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description     = "ssh from VPC"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
  ingress {
    description     = "http from VPC"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.api-alb.id}"]

  }
  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description     = "http from VPC"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-alb.id}"]

  }
  ingress {
    description = "ssh from VPC"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "http from VPC"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins-sg.id}"]

  }
  ingress {
    description     = "http from VPC"
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins-sg.id}"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "grafana -sg"
  }
}



resource "aws_instance" "grafana" {
  ami                    = var.ami
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.krishna1.id
  vpc_security_group_ids = ["${aws_security_group.grafana-sg.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id



  tags = {
    Name = "grafana"
  }
}
