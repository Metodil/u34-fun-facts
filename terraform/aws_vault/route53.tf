
resource "aws_route53_record" "vault" {
  zone_id = data.aws_route53_zone.selected.id
  name    = "vault"
  type    = "A"
  ttl     = 300
  records = [aws_instance.vault.public_ip]
}
