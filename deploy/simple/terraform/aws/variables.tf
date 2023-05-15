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
