data "hcloud_ssh_key" "devops" {
  name = "REBRAIN.SSH.PUB.KEY"
}

resource "hcloud_ssh_key" "a23uk_key" {
  name       = "23uk_key"
  public_key = var.a23uk_key
}

resource "hcloud_server" "devops_23uk" {
  image    = "debian-9"
  name     = "devops-23uk"
  server_type = "cx11"
#  user_data = "REBRAIN.SSH.PUB.KEY"
  location   = "fsn1"
  ssh_keys =  [data.hcloud_ssh_key.devops.id,hcloud_ssh_key.a23uk_key.id]
}
