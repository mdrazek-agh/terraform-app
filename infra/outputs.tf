output "web_servers_private_ip_address" {
    value = digitalocean_droplet.web.*.ipv4_address_private
}
output "external_loadbalancer_fqdn" {
    value = digitalocean_record.web.fqdn
}

output "bastion_fqdn" {
    value = digitalocean_record.bastion.fqdn
}

output "db_port" {
    value = digitalocean_database_cluster.postgress-cluster.port
}

output "db_private_uri" {
    value = digitalocean_database_cluster.postgress-cluster.private_uri
    sensitive = true
}

output "db_name" {
    value = digitalocean_database_cluster.postgress-cluster.database
}

output "db_user" {
    value = digitalocean_database_cluster.postgress-cluster.user
}

output "db_password" {
    value = digitalocean_database_cluster.postgress-cluster.password
    sensitive = true
}