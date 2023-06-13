resource "cloudflare_record" "ip_addr_app" {
  name    = "ip-addr"
  proxied = false
  ttl     = 1
  type    = "A"
  value   = oci_core_instance.homelab-oci02.public_ip
  zone_id = var.cloudflare_zone_id
}
