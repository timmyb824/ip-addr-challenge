# Generates a 35-character secret for the tunnel.
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# Creates a new locally-managed tunnel
resource "cloudflare_tunnel" "auto_tunnel" {
  account_id = var.cloudflare_account_id
  name       = "ip-addr-app proxmox tunnel"
  secret     = random_id.tunnel_secret.b64_std
}

# Leave .cfargotunnel.com as-is, it's the domain used by Cloudflare for tunnels.
resource "cloudflare_record" "ip-addr-app" {
  zone_id = var.cloudflare_zone_id
  name    = "ip-addr"
  value   = "${cloudflare_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}

resource "local_file" "cf_ansible_vars_file" {
  filename = var.ansible_vars_file
  content = <<-DOC
    # Ansible vars_file containing variable values from Terraform.
    tunnel_id: ${cloudflare_tunnel.auto_tunnel.id}
    account: ${var.cloudflare_account_id}
    tunnel_name: ${cloudflare_tunnel.auto_tunnel.name}
    secret: ${random_id.tunnel_secret.b64_std}
    zone: ${var.cloudflare_zone}
    DOC
}
