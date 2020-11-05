data "hcloud_ssh_key" "devops" {
  name = "REBRAIN.SSH.PUB.KEY"
}

#resource "hcloud_ssh_key" "ab23uk_key" {
#  name       = "23uk_key"
#  public_key = var.a23uk_key
#}

#data "hcloud_server" "serverinfo" {
#  id = hcloud_server.devops_23uk.id
#  name = ["${element(hcloud_server.devops_23uk.*.id, count.index)}"]
#}

variable "domains" {
  type = list(string)
  default = ["1", "2"]
}

resource "hcloud_server" "devops_23uk" {
  count    = length(var.domains)
  image    = "debian-9"
  name     = element(var.domains, count.index)
  server_type = "cx11"
  location   = "fsn1"
  ssh_keys =  [data.hcloud_ssh_key.devops.id]
}

data "aws_route53_zone" "dns" {
  name         = "devops.rebrain.srwx.net."
  private_zone = false
}

resource "aws_route53_record" "dns_rebrain" {
  count   = length(var.domains)
  zone_id = data.aws_route53_zone.dns.zone_id
  name    = "23uk-${element(var.domains, count.index)}.devops.rebrain.srwx.net"
  type    = "A"
  ttl     = "30"
#  records = [data.hcloud_server.serverinfo.ipv4_address]
  records = [element(hcloud_server.devops_23uk[*].ipv4_address, count.index)]
}

#output "server_ip" {
#  value = hcloud_server.devops_23uk.name
#}

output "aws_route53_zone" {
  value = data.aws_route53_zone.dns.zone_id
}
