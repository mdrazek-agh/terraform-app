resource "digitalocean_droplet" "web" {
    count = var.droplet_count
    image = var.image
    name = "web-${var.name}-${var.region}-${count.index +1}"
    region = var.region
    size = var.droplet_size
    ssh_keys = [data.digitalocean_ssh_key.main.id]
    vpc_uuid = digitalocean_vpc.web.id
    tags = ["${var.name}-webserver", "agh-ask-project"]

    user_data = <<EOF
    runcmd:
      - git clone https://github.com/mdrazek-agh/terraform-app.git
      - cd terraform-app
      - docker build -t tomcat-web .
    EOF

    lifecycle {
        create_before_destroy = true
    }
}

# Load balancer SSL certs
resource "digitalocean_certificate" "web" {

    name = "${var.name}-certificate"
    type = "lets_encrypt"
    domains = ["${var.subdomain}.${data.digitalocean_domain.web.name}"]
    lifecycle {
        create_before_destroy = true
    }
}

# Load Balancer w/ SSL termination
resource "digitalocean_loadbalancer" "web" {

    name = "web-${var.region}"
    region = var.region
    droplet_ids = digitalocean_droplet.web.*.id
    vpc_uuid = digitalocean_vpc.web.id
    redirect_http_to_https = true
    
    forwarding_rule {
        entry_port = 443
        entry_protocol = "https"

        target_port = 80
        target_protocol = "http"

        certificate_name = digitalocean_certificate.web.name
    }

    forwarding_rule {
        entry_port = 80
        entry_protocol = "http"

        target_port = 80
        target_protocol = "http"

        certificate_name = digitalocean_certificate.web.name
    }

    lifecycle {
        create_before_destroy = true
    }
}

# Firewall rules
resource "digitalocean_firewall" "web" {
    name = "web-vpc-traffic"
    droplet_ids = digitalocean_droplet.web.*.id

    # Internal
    inbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        source_addresses = [digitalocean_vpc.web.ip_range]
    }

    inbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        source_addresses = [digitalocean_vpc.web.ip_range]
    }

    inbound_rule {
        protocol = "icmp"
        source_addresses = [digitalocean_vpc.web.ip_range]
    }

    outbound_rule {
        protocol = "udp"
        port_range = "1-65535"
        destination_addresses = [digitalocean_vpc.web.ip_range]
    }

    outbound_rule {
        protocol = "tcp"
        port_range = "1-65535"
        destination_addresses = [digitalocean_vpc.web.ip_range]
    }

    outbound_rule {
        protocol = "icmp"
        destination_addresses = [digitalocean_vpc.web.ip_range]
    }

    # External
    # DNS
    outbound_rule {
        protocol = "udp"
        port_range = "53"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # HTTP
    outbound_rule {
        protocol = "tcp"
        port_range = "80"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # HTTPS
    outbound_rule {
        protocol = "tcp"
        port_range = "443"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }

    # ICMP
    outbound_rule {
        protocol              = "icmp"
        destination_addresses = ["0.0.0.0/0", "::/0"]
    }
}

#Set up DNS
resource "digitalocean_record" "web" {
    domain = data.digitalocean_domain.web.name
    type   = "A"
    name   = var.subdomain
    value  = digitalocean_loadbalancer.web.ip
    ttl    = 300
}
