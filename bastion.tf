#bastion.tf

resource "aws_security_group" "bastion" {
  name        = "bastion"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-bastionsg"
  }
}

resource "aws_key_pair" "krishna1" {
  key_name   = "krishna1"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDU0Jj9hTh2nuNah54c+plW24IIccyYh+NFdDU5KkY8NI1MFH2PFJCOO25RsxO4As3sJtv4QQbNmQOGqNpvO7R1+lcdgg8fsR9TcX3ulE2W0zvl77XNJBWvUUjDUx8xfa0W9Bn2wHnszP936IjbtbCU2ZuVL7X59XbeDjVlc0ofmyh/YdGyCbVoUenxYBg5ZATDmLqQbLG74qrINGvWuHxq+JOSBw96h7oDCc/ww/URvxNvEDKg0MBMSSgVSexPpmAUbox81+3LsyFvMAS/TNhXYjtOupk1bBFk4QxinbfaHKJvRB8VLbro8GrKGy+mXI4eD9yqJS9zAMvuDGSCrubbRehChRwoY4u8LbgQqu5rQjurM5lfB2k8QWfQ8YUdGsiwkuD0KWGz5xFUg5AJDTjhRv2j/dowONCXLh+YQkyt9rTH7mGVyFQXxsFsZK2vNPcxB5G5eSBLt1OSn9SUGle9yW89uMUMKziaWOYpUYFrVnoKOP0eZhvGyB41oAT/aU8= ELCOT@Lenovo"
}

resource "aws_instance" "bastion" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.krishna1.id
  vpc_security_group_ids = ["${aws_security_group.bastion.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id

  tags = {
    Name = "${var.envname}-bastion"
  }
}