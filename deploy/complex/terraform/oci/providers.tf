terraform {
  required_providers {
    oci = {
      source  = "oracle/oci"
      version = "5.0.0"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
    }
  }
}

# values set via oci cli config file in ~/.oci/config
provider "oci" {
  tenancy_ocid     = var.tenancy_ocid
  user_ocid        = var.user_ocid
  fingerprint      = var.fingerprint
  private_key_path = var.private_key_path
  region           = "us-ashburn-1"
}

terraform {
  cloud {
    organization = "Bryant-homelab"

    workspaces {
      name = "ip-addr-app"
    }
  }
}
