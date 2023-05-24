#r53.tf

resource "aws_route53_zone" "kkmn-hostedzone" {
  name = "kkmn.info"

  tags = {
    Environment = "dev"
  }
}



resource "aws_route53_record" "jenkins-record" {
  zone_id = aws_route53_zone.kkmn-hostedzone.zone_id
  name    = "jenkins.kkmn.info"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.nateip.public_ip]
}