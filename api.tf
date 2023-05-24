#api.tf

#alb-sg

resource "aws_security_group" "api-alb" {
  name        = "api-alb"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description = "http from VPC"
    from_port   = 80
    to_port     = 80
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
    Name = "${var.envname}-api-albsg"
  }
}

resource "aws_lb" "api-alb" {
  name               = "api-alb"
  internal           = true
  load_balancer_type = "application"
  security_groups    = [aws_security_group.api-alb.id]
  subnets            = ["${aws_subnet.pubsubnets[1].id}", "${aws_subnet.pubsubnets[2].id}"]

  enable_deletion_protection = true


  tags = {
    Environment = "dev-api-alb"
  }
}


# instance target group

resource "aws_lb_target_group" "api-tg" {
  name     = "api-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id
}



resource "aws_lb_target_group_attachment" "api-attach-tg" {
  target_group_arn = aws_lb_target_group.api-tg.arn
  target_id        = aws_instance.api.id
  port             = 8080
}

# listner


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.api-alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.api-tg.arn
  }
}

#route53


resource "aws_route53_record" "app" {
  zone_id = aws_route53_zone.kkmn-hostedzone.zone_id
  name    = "dev-api.kkmn.info"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.nateip.public_ip]
}




resource "aws_security_group" "api-sg" {
  name        = "api-sg"
  description = "Allow http and ssh inbound traffic"
  vpc_id      = aws_vpc.dev.id

  ingress {
    description     = "ssh from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.bastion.id}"]

  }
  ingress {
    description     = "http from VPC"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = ["${aws_security_group.app-alb.id}"]

  }
  ingress {
    description     = "http from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins-sg.id}"]

  }


  ingress {
    description     = "http from VPC"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = ["${aws_security_group.jenkins-slave-sg.id}"]

  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "${var.envname}-api-sg"
  }
}


resource "aws_instance" "api" {
  ami                    = var.ami
  instance_type          = var.type
  key_name               = aws_key_pair.krishna1.id
  vpc_security_group_ids = ["${aws_security_group.api-sg.id}"]
  subnet_id              = aws_subnet.privsubnets[0].id


  tags = {
    Name = "${var.envname}-api"
  }
}
