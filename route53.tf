resource "aws_route53_record" "rancher-server" {
  name            = var.rancher_server_dns
  zone_id         = var.route53_private_hosted_zone_id
  records         = [aws_instance.rancher_server.private_ip]
  ttl             = 60
  type            = "A"
  allow_overwrite = true
}