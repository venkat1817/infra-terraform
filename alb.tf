#alb-sg

resource "aws_security_group" "alb" {
  name        = "alb"
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
    Name = "${var.envname}-albsg"
  }
}

resource "aws_lb" "jenkins-alb" {
  name               = "apache-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb.id]
  subnets            = ["${aws_subnet.pubsubnets[1].id}", "${aws_subnet.pubsubnets[2].id}"]

  enable_deletion_protection = true


  tags = {
    Name = "${var.envname}-jenkins-alb"
  }
}

# instance target group

resource "aws_lb_target_group" "jenkins-tg" {
  name     = "jenkins-tg"
  port     = 8080
  protocol = "HTTP"
  vpc_id   = aws_vpc.dev.id
}



resource "aws_lb_target_group_attachment" "testing" {
  target_group_arn = aws_lb_target_group.jenkins-tg.arn
  target_id        = aws_instance.jenkins.id
  port             = 8080
}





# listner


resource "aws_lb_listener" "r_end" {
  load_balancer_arn = aws_lb.jenkins-alb.arn
  port              = "80"
  protocol          = "HTTP"


  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.jenkins-tg.arn
  }
}

