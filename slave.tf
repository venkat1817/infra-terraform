#jenkins-slave.tf

resource "aws_security_group" "jenkins-slave-sg" {
  name        = "jenkins-slave-sg"
  description = "Allow ssh inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "ssh from VPC"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }
  ingress {
    description     = "ssh from VPC"
    from_port       = 22
    to_port         = 22
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
    Name = "${var.envname}-jenkins-slave-sg"
  }
}

data "template_file" "slave" {
  template = file("slave.sh")

}

resource "aws_instance" "jenkins-slave" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.krishna1.id
  vpc_security_group_ids = ["${aws_security_group.jenkins-slave-sg.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id
  user_data              = data.template_file.slave.rendered

  tags = {
    Name = "${var.envname}-jenkins-slave"
  }
}