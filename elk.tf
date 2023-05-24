region      = "ap-southeast-2"
cidr        = "10.1.0.0/16"
envname     = "dev"
pubsubnets  = ["10.1.0.0/24", "10.1.1.0/24", "10.1.2.0/24"]
privsubnets = ["10.1.3.0/24", "10.1.4.0/24", "10.1.5.0/24"]
datasubnets = ["10.1.6.0/24", "10.1.7.0/24", "10.1.8.0/24"]
azs         = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
ami         = "ami-0aab712d6363da7f9"
type        = "t2.micro"

[root@ip-172-31-42-191 appdemo]# cat elk.tf
#elk.tf

resource "aws_security_group" "elk-sg" {
  name        = "elk-sg"
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
    Name = "${var.envname}-elk-sg"
  }
}


resource "aws_instance" "elk" {
  ami                    = "ami-0f39d06d145e9bb63"
  instance_type          = "t2.medium"
  key_name               = aws_key_pair.krishna1.id
  vpc_security_group_ids = ["${aws_security_group.elk-sg.id}"]
  subnet_id              = aws_subnet.pubsubnets[0].id

  tags = {
    Name = "${var.envname}-elk"
  }
}
