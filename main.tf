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

resource "aws_route53_zone" "dns" {
  name = "devops.rebrain.srwx.net"
}

resource "aws_route53_record" "dns_rebrain" {
  allow_overwrite = true
  name            = "23uk.devops.rebrain.srwx.net"
  ttl             = 30
  type            = "A"
  zone_id         = data.hcloud_server.serverinfo.ipv4_address
}

output "server_ip" {
  value = data.hcloud_ssh_key.devops.id,hcloud_ssh_key.a23uk_key.id
}