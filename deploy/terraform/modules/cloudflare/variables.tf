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

variable ansible_vars_file {
  description = "Path to the Ansible vars_file to be generated"
  type        = string
  default     = ""
}

# Declared using environment variable
# variable "cloudflare_token" {
#   description = "Cloudflare API token created at https://dash.cloudflare.com/profile/api-tokens"
#   type        = string
# }