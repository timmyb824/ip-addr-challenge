terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"
}

# Providers
# provider "cloudflare" {
#   # api_token    = var.cloudflare_token
# }

# provider "random" {
# }