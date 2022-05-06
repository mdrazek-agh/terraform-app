resource "digitalocean_vpc" "web"{
    name = "webapp"
    region = var.region
    ip_range = "192.168.32.0/24"
}