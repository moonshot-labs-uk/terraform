variable "do_token" {
  value = env.do_token
}

variable "ssh_fingerprint" {
  value = env.ssh_fingerprint
}

variable "instance_count" {
  default = 1
}

variable "do_name" {
  default = "moonshotlabs-paas"
}

variable "do_image" {
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

provider "digitalocean" {
  token = var.do_token
}
