# Cloudflare module (if you want to use a cloudflare tunnel):
module "cloudflare_tunnel" {
  source                = "../modules/cloudflare"
  cloudflare_account_id = var.cloudflare_account_id
  cloudflare_zone_id    = var.cloudflare_zone_id
  cloudflare_zone       = var.cloudflare_zone
  cloudflare_email      = var.cloudflare_email
  ansible_vars_file     = var.ansible_vars_file
}

# data "local_file" "public_key" {
#   filename = "${path.module}/files/id_master_key.pub"
# }

resource "proxmox_vm_qemu" "node" {
  name        = var.vm_name
  vmid        = var.vm_id
  target_node = var.pm_node

  clone = "ubuntu-2204-cloudinit-template"

  os_type  = "cloud-init"
  cores    = 2
  sockets  = "1"
  cpu      = "host"
  memory   = var.vm_memory
  scsihw   = "virtio-scsi-pci"
  bootdisk = "scsi0"

  disk {
    size     = var.vm_disk_size
    type     = "scsi"
    storage  = var.storage_name
    iothread = 0
  }

  network {
    model  = "virtio"
    bridge = "vmbr0"
  }

  # cloud-init settings
  # adjust the ip and gateway addresses as needed
  ipconfig0 = "ip=${var.vm_ip}/24,gw=${var.vm_gw}"
  # sshkeys   = var.public_key
  sshkeys   = file("~/.ssh/id_master_key.pub")
  # sshkeys   = data.local_file.public_key.content
}

# Generate inventory file
resource "local_file" "inventory" {
  filename = "../../ansible/inventory.ini"
  content  = <<EOF
[webserver]
${var.vm_ip}  ansible_connection=ssh  ansible_user=ubuntu  ansible_ssh_private_key_file=${var.private_key}
EOF
}
