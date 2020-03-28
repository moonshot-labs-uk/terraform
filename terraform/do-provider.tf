variable "do_token" {
}

variable "ssh_fingerprint" {
}

variable "instance_count" {
default = "1"
}

variable "do_name" {
  default = "moonshotlabs-paas"
}

variable "d0_image" {
  default = "caprover-18-04"
}

variable "do_region" {
  default = "lon1"
}

variable "do_size" {
  default = "s-2vcpu-4gb"
}

variable "do_private_networking" {
  default = true
}

resource "digitalocean_ssh_key" "default" {
  name       = "Terraform Example"
  public_key = file("/Users/terraform/.ssh/id_rsa.pub")
} 

# Create a new Droplet using the SSH key
resource "digitalocean_droplet" "web" {
  image    = "ubuntu-18-04-x64"
  name     = "web-1"
  region   = "nyc3"
  size     = "s-1vcpu-1gb"
  ssh_keys = [digitalocean_ssh_key.default.fingerprint]
}

provider "digitalocean" {
  token = var.do_token
}
