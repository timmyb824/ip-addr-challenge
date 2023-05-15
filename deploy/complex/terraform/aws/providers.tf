terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
  required_version = ">= 0.13"
}

provider "aws" {
  region = "us-east-1"
}

terraform {
  cloud {
    organization = "Bryant-homelab"

    workspaces {
      name = "ip-addr-app"
    }
  }
}
