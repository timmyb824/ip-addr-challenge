# AWS Variables
variable "key_name" {
  type = string
  default = "awsCommon"
}

variable "private_key" {
  type = string
  default = "~/.ssh/awsCommon.pem"
}

variable "tags" {
  type = map(string)
  default = {
    app = "ip_addr_app"
  }
}

variable "ec2_user" {
  type = string
  default = "ubuntu"
}

# Cloudflare variables (if you want to use a cloudflare tunnel):
# comment out if not using cloudflare tunnel
# variable "cloudflare_zone" {
#   description = "Domain used to expose the GCP VM instance to the Internet"
#   type        = string
# }

variable "cloudflare_zone_id" {
  description = "Zone ID for your domain"
  type        = string
}

# variable "cloudflare_account_id" {
#   description = "Account ID for your Cloudflare account"
#   type        = string
#   sensitive   = true
# }

# variable "cloudflare_email" {
#   description = "Email address for your Cloudflare account"
#   type        = string
#   sensitive   = true
# }

# variable ansible_vars_file {
#   description = "Path to the Ansible vars_file to be generated"
#   type        = string
#   default     = ""
# }

# variable "service_address" {
#   description = "IP address and port of the service to be exposed"
#   type        = string
#   default     = ""
# }
