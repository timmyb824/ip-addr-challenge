# Proxmox variables
variable "pm_node" {
  description = "value of the Proxmox node name"
  type = string
}

variable "vm_name" {
  description = "value of the Proxmox VM name"
  type = string
}

variable "vm_id" {
  description = "value of the Proxmox VM ID"
  type = number
}

variable "vm_ip" {
  description = "value of the Proxmox VM IP"
  type = string
}

variable "vm_gw" {
  description = "value of the Proxmox VM gateway"
  type = string
}

variable public_key {
  description = "value of the Proxmox public key"
  type = string
}

variable "storage_name" {
  description = "value of the Proxmox storage name"
  type = string
}

variable "vm_memory" {
  description = "value of the Proxmox VM memory"
  type = number
}

variable "vm_disk_size" {
  description = "value of the Proxmox VM disk size"
  type = string
}

# Declared using environment variables
# variable "pm_api_token_id" {
#   description = "value of the Proxmox API token ID"
#   type = string
# }

# variable "pm_api_token_secret" {
#   description = "value of the Proxmox API token secret"
#   type = string
# }

# variable "pm_api_url" {
#   description = "value of the Proxmox API URL"
#   type = string
# }

# Cloudflare variables (if you want to use a cloudflare tunnel)
# comment out if not using cloudflare tunnel
variable "cloudflare_zone" {
  description = "Domain used to expose the GCP VM instance to the Internet"
  type        = string
}

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

variable "cloudflare_account_id" {
  description = "Account ID for your Cloudflare account"
  type        = string
  sensitive   = true
}

variable "cloudflare_email" {
  description = "Email address for your Cloudflare account"
  type        = string
  sensitive   = true
}

