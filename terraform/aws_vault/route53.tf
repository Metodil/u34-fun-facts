
resource "aws_route53_zone" "u34-vault" {
  name = "u34-vault.link"
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.u34-vault.id
  name    = "vault"
  type    = "A"
  ttl     = 300
  records = [aws_instance.vault.public_ip]
}
