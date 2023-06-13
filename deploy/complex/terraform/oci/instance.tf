resource "oci_core_instance" "homelab-oci02" {
  depends_on = [ oci_core_network_security_group.ipaddr-NSG ]
  agent_config {
    are_all_plugins_disabled = "false"
    is_management_disabled   = "false"
    is_monitoring_disabled   = "false"
    plugins_config {
      desired_state = "DISABLED"
      name          = "Vulnerability Scanning"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Management Agent"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Custom Logs Monitoring"
    }
    plugins_config {
      desired_state = "ENABLED"
      name          = "Compute Instance Monitoring"
    }
    plugins_config {
      desired_state = "DISABLED"
      name          = "Bastion"
    }
  }
  #async = <<Optional value not found in discovery>>
  availability_config {
    is_live_migration_preferred = "true"
    recovery_action             = "RESTORE_INSTANCE"
  }
  availability_domain = var.availability_domain--SlVs-US-ASHBURN-AD-3
  #capacity_reservation_id = <<Optional value not found in discovery>>
  compartment_id = var.compartment_ocid
  #compute_cluster_id = <<Optional value not found in discovery>>
  create_vnic_details {
    #assign_private_dns_record = <<Optional value not found in discovery>>
    assign_public_ip = "true"
    display_name     = "homelab-oci02"
    hostname_label   = "homelab-oci02"
    nsg_ids = [
      oci_core_network_security_group.ipaddr-NSG.id,
    ]
    subnet_id = var.subnet_id
  }
  display_name = "homelab-oci02"
  extended_metadata = {
  }
  fault_domain = var.fault_domain--FAULT-DOMAIN-2
  freeform_tags = {
  }
  instance_options {
    are_legacy_imds_endpoints_disabled = "false"
  }
  #ipxe_script = <<Optional value not found in discovery>>
  #is_pv_encryption_in_transit_enabled = <<Optional value not found in discovery>>
  launch_options {
    boot_volume_type                    = "PARAVIRTUALIZED"
    firmware                            = "UEFI_64"
    is_consistent_volume_naming_enabled = "true"
    network_type                        = "PARAVIRTUALIZED"
    remote_data_volume_type             = "PARAVIRTUALIZED"
  }
  metadata = {
    "ssh_authorized_keys" = file("~/.ssh/id_master_key.pub")
  }
  #preserve_boot_volume = <<Optional value not found in discovery>>
  shape = "VM.Standard.E2.1.Micro"
  shape_config {
    baseline_ocpu_utilization = ""
    memory_in_gbs             = "1"
    ocpus                     = "1"
  }
  source_details {
    #boot_volume_size_in_gbs = <<Optional value not found in discovery>>
    boot_volume_vpus_per_gb = "10"
    #kms_key_id = <<Optional value not found in discovery>>
    # oracle: "ocid1.image.oc1.iad.aaaaaaaautmrqednxxohclxwgvawc42o2q6226lrbyte7nbe7hge6evbz7oq"
    source_id   = "ocid1.image.oc1.iad.aaaaaaaacumcsdgytqakloq3rhin53to6a76tavkyojzb54eurydbm4nsbqa"
    source_type = "image"
  }
}

# Generate inventory file
resource "local_file" "inventory" {
  filename = "../../ansible/inventory.ini"
  content  = <<EOF
[webserver]
${oci_core_instance.homelab-oci02.display_name}  ansible_host=${oci_core_instance.homelab-oci02.public_ip}  ansible_connection=ssh  ansible_user=ubuntu  ansible_ssh_private_key_file=~/.ssh/id_master_key

EOF
}
