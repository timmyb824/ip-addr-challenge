terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
    proxmox = {
      source  = "Telmate/proxmox"
      version = "2.9.10"
    }
    random = {
      source = "hashicorp/random"
    }
  }
  required_version = ">= 0.13"

  # cloud {
  #   organization = "Bryant-homelab"

  #   workspaces {
  #     name = "ip-addr-challenge"
  #   }
  # }
}


# Providers
provider "cloudflare" {
  api_token    = var.cloudflare_token
}

provider "proxmox" {
  pm_parallel         = 1
  pm_tls_insecure     = true
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
}

provider "random" {
}