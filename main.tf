data "hcloud_ssh_key" "devops" {
  name = "REBRAIN.SSH.PUB.KEY"
}

resource "hcloud_ssh_key" "a23uk_key" {
  name       = "23uk_key"
  public_key = var.a23uk_key
}

data "hcloud_server" "serverinfo" {
  id = hcloud_server.devops_23uk.id
}

resource "hcloud_server" "devops_23uk" {
  image    = "debian-9"
  name     = "devops-23uk"
  server_type = "cx11"
  location   = "fsn1"
  ssh_keys =  [data.hcloud_ssh_key.devops.id,hcloud_ssh_key.a23uk_key.id]
}

data "aws_route53_zone" "dns" {
  name         = "devops.rebrain.srwx.net."
  private_zone = false
}

resource "aws_route53_record" "dns_rebrain" {
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "23uk.devops.rebrain.srwx.net"
  type    = "A"
  ttl     = "30"
  records = [data.hcloud_server.serverinfo.ipv4_address]
}

output "server_ip" {
  value = data.hcloud_server.serverinfo.ipv4_address
}

output "aws_route53_zone" {
  value = data.aws_route53_zone.dns.zone_id
}
