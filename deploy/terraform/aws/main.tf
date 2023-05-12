# Cloudflare module (if you want to use a cloudflare tunnel):
# comment out if not using cloudflare tunnel
# module "cloudflare_tunnel" {
#   source                = "../modules/cloudflare"
#   cloudflare_account_id = var.cloudflare_account_id
#   cloudflare_zone_id    = var.cloudflare_zone_id
#   cloudflare_zone       = var.cloudflare_zone
#   cloudflare_email      = var.cloudflare_email
# }

data "aws_ami" "latest_ubuntu_22_04" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
      name   = "name"
      values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
    }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
    }

  filter {
      name   = "root-device-type"
      values = ["ebs"]
    }
}

output "ubuntu_22_04_ami_id" {
  value = data.aws_ami.latest_ubuntu_22_04.id
}

resource "aws_security_group" "ip_addr_app" {
  name_prefix = "ip_addr_app_"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# configure the aws instance
resource "aws_instance" "ec2" {
  ami                    = data.aws_ami.latest_ubuntu_22_04.id
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ip_addr_app.id]
  # subnet_id              = "var.subnet_id"
  key_name               = var.key_name
  tags                   = var.tags

  ebs_block_device {
    device_name = "/dev/xvda"
    volume_size = 8
  }
}

# Generate inventory file
resource "local_file" "inventory" {
  filename = "../../ansible/inventory.ini"
  content  = <<EOF
[webserver]
${aws_instance.ec2.public_ip} ansible_connection=ssh  ansible_user=${var.ec2_user}  ansible_ssh_private_key_file=${var.private_key}
EOF
}

