data "hcloud_ssh_key" "devops" {
  name = "REBRAIN.SSH.PUB.KEY"
}

resource "hcloud_ssh_key" "a23uk_key" {
  name       = "23ukk_key"
  public_key = var.a23uk_key
}

resource "hcloud_server" "devops_23uk" {
  count    = length(var.domains)
  image    = "centos-7"
  name     = element(var.domains, count.index)
  server_type = "cx11"
  labels = {
    module = "devops"
    email  = "23uk_at_tut_by"
  }
  location   = "nbg1"
#  location   = "hel1"
  ssh_keys =  [data.hcloud_ssh_key.devops.id,hcloud_ssh_key.a23uk_key.id]

#  connection {
#    type = "ssh"
#    host = self.ipv4_address
#    user = "root"
#    private_key = file(var.connection.private_key)

#  }

#  provisioner "remote-exec" {
#    inline = ["touch /root/123"]
#}

provisioner "local-exec" {
     command = <<EOF
echo --- > playbook.yml
echo "- name: Install NGINX" >> playbook.yml
echo "  hosts: all" >> playbook.yml
echo "  become: yes" >> playbook.yml
echo "  tasks:" >> playbook.yml
echo "  - name: Install epel-release" >> playbook.yml
echo "    yum: name=epel-release state=latest" >> playbook.yml
echo "  - name: Install Nginx" >> playbook.yml
echo "    yum: name=nginx state=latest" >> playbook.yml
echo "  - name: Autostart webserver" >> playbook.yml
echo "    service: name=nginx state=started enabled=yes" >> playbook.yml
echo "- name: Configuring Nginx 23uk-1" >> playbook.yml
echo "  hosts: 23uk-1.devops.rebrain.srwx.net" >> playbook.yml
echo "  become: yes" >> playbook.yml
echo "  tasks:" >> playbook.yml
echo "  - name: Generate nginx.conf" >> playbook.yml
echo "    template: src=nginx/nginx1.j2 dest=/etc/nginx/nginx.conf mode=0644" >> playbook.yml
echo "    notify: Reload nginx" >> playbook.yml
echo "  - name: Copy hostname1" >> playbook.yml
echo "    template: src=hostname/hostname1 dest=/etc/hostname mode=0644" >> playbook.yml
echo "  handlers:" >> playbook.yml
echo "  - name: Reload nginx" >> playbook.yml
echo "    service: name=nginx state=reloaded" >> playbook.yml
echo "- name: Configuring Nginx 23uk-2" >> playbook.yml
echo "  hosts: 23uk-2.devops.rebrain.srwx.net" >> playbook.yml
echo "  become: yes" >> playbook.yml
echo "  tasks:" >> playbook.yml
echo "  - name: Generate nginx.conf" >> playbook.yml
echo "    template: src=nginx/nginx2.j2 dest=/etc/nginx/nginx.conf mode=0644" >> playbook.yml
echo "    notify: Reload nginx" >> playbook.yml
echo "  - name: Create directory" >> playbook.yml
echo "    file: path=/home/23uk-2.devops.rebrain.srwx.net state=directory" >> playbook.yml
echo "  - name: Copy index.html" >> playbook.yml
echo "    template: src=html/index.html dest=/home/23uk-2.devops.rebrain.srwx.net/index.html mode=0644" >> playbook.yml
echo "    notify: Reload nginx" >> playbook.yml
echo "  - name: Copy hostname2" >> playbook.yml
echo "    template: src=hostname/hostname2 dest=/etc/hostname mode=0644" >> playbook.yml
echo "  handlers:" >> playbook.yml
echo "  - name: Reload nginx" >> playbook.yml
echo "    service: name=nginx state=reloaded" >> playbook.yml

EOF
    }

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
  records = [element(hcloud_server.devops_23uk[*].ipv4_address, count.index)]
}

#output "aws_route53_zone" {
#  value = data.aws_route53_zone.dns.zone_id
#}
