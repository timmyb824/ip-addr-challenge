provider "aws" {
  region = "us-east-1"
}

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
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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

  # make sure instance is ready for ansbile to be run; could also use depends_on = [aws_instance.ec2]
  provisioner "remote-exec" {
    inline = ["echo 'Ready to accept connections'"]

    connection {
      type        = "ssh"
      host        = self.public_ip
      user        = var.ec2_user
      timeout     = "2m"
      private_key = file(var.private_key)
    }
  }

  # runs ansible playbook on instance
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u '${var.ec2_user}' -i '${aws_instance.ec2.public_dns},' --private-key '${var.private_key}' ../ansible/server.yaml"
  }
}

# Generate inventory file
resource "local_file" "inventory" {
  filename = "../ansible/inventory.ini"
  content  = <<EOF
[webserver]
${aws_instance.ec2.public_ip}
EOF
}

variable "key_name" {
  type = string
  default = "awsCommon"
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

variable "private_key" {
  type = string
  default = "~/.ssh/awsCommon.pem"
}
