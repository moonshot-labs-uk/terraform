resource "digitalocean_ssh_key" "ssh_keys_client" {
  name       = "moonshotlabs_paas_pub"
  public_key = var.public_key
}

resource "digitalocean_floating_ip" "moonshotlabs_floating_ip" {
  region     = var.do_region
}

resource "digitalocean_volume" "moonshotlabs_data" {
  name                    = "moonshotlabs_paas_data"
  region                  = var.do_region
  size                    = var.do_volume_size
  initial_filesystem_type = "ext4"
  description             = "Data volume for PaaS"
}

resource "digitalocean_droplet" "moonshotlabs_paas" {
  image              = var.do_image
  name               = var.do_name
  region             = var.do_region
  size               = var.do_size
  private_networking = var.do_private_networking
  ssh_keys = [digitalocean_ssh_key.ssh_keys_client.id]
}

output "moonshotlabs_paas_ip_addr" {
  value = {
    for instance in digitalocean_droplet.moonshotlabs_paas:
    instance.id => instance.ipv4_address
  }
  description = "The IP addresses of the deployed instances, paired with their IDs."
}

resource "digitalocean_volume_attachment" "moonshotlabs_attached_volume" {
  droplet_id = digitalocean_droplet.moonshotlabs_paas.id
  volume_id  = data.digitalocean_volume.paas_data.id
}

resource "digitalocean_floating_ip_assignment" "moonshotlabs_assigned_ip" {
  ip_address = digitalocean_floating_ip.moonshotlabs_floating_ip.ip_address
  droplet_id = digitalocean_droplet.moonshotlabs_paas.id
}

resource "digitalocean_project" "moonshotlabs_project" {
  name        = "Moonshot Labs"
  description = "A project to represent development resources."
  purpose     = "Web Application"
  environment = "Development"
  resources   = [
    digitalocean_volume.moonshotlabs_data.urn,
    digitalocean_floating_ip.moonshotlabs_floating_ip.urn,
    digitalocean_droplet.moonshotlabs_paas.urn
  ]
}
