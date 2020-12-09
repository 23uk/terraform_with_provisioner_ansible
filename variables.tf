variable "hcloud_token" {
type=string
}
variable "a23uk_key" {
type=string
}

variable "aws_access_key" {
type=string
}

variable "aws_secret_key" {
type=string
}

#variable "zone_id" {
#type=string
#}

variable "domains" {
type=list
}

variable "connection" {
  default = {
    user        = "root"
    type        = "ssh"
    private_key = "/root/.ssh/id_rsa"
  }
}

