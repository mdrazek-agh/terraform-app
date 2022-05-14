#MANDATORY
# DigitalOcean API token
variable do_token {}

# SSH Key name (from DigitalOcean dashboard)
variable ssh_key {
    type = string
}

variable "subdomain" {
    type = string
}

variable domain_name {
    type = string
}

#OPTIONAL
variable "name" {
    type = string
    default = "webapp"
}

variable "region" {
    type    = string
    default = "fra1"
}

variable "droplet_count" {
    type = number
    default = 1
}

variable "db_count" {
    type = number
    default = 1
}

# For available options see: https://slugs.do-api.dev/
variable "droplet_size" {
    type = string
    default = "s-1vcpu-1gb"
}

variable "database_size" {
    type = string
    default = "db-s-1vcpu-1gb"
}

variable "image" {
    type = string
    default = "debian-11-x64"
}


variable "bastion-image" {
    type = string
    default = "debian-11-x64"
}
