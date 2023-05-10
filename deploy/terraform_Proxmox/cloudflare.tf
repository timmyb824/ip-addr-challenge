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

# Creates the CNAME record that routes ssh_app.${var.cloudflare_zone} to the tunnel.
# Leave .cfargotunnel.com as-is, it's the domain used by Cloudflare for tunnels.
resource "cloudflare_record" "ip-addr-app" {
  zone_id = var.cloudflare_zone_id
  name    = "ip-addr"
  value   = "${cloudflare_tunnel.auto_tunnel.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
}