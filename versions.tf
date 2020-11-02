terraform {
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
  required_version = ">= 0.13"
}
