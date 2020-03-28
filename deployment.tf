resource "digitalocean_ssh_key" "client" {
  name       = "Terraform Moonshot Labs PaaS"
  public_key = var.public_key
}

resource "digitalocean_droplet" "moonshotlabs_paas" {
  count              = var.instance_count
  image              = var.do_image
  name               = var.do_name
  region             = var.do_region
  size               = var.do_size
  private_networking = var.do_private_networking
  ssh_keys = [data.digitalocean_ssh_key.client.id]
}

output "instance_ip_addr" {
value = {
  for instance in digitalocean_droplet.moonshotlabs_paas:
  instance.id => instance.ipv4_address
}
description = "The IP addresses of the deployed instances, paired with their IDs."
}
