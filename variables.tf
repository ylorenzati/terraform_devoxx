# region: eu-west-2
# ami:    ami-ed908589

variable "aws_region" {
  type = "string"
  default = "eu-west-2"
}

variable "ami_ubuntu" {
  type = "string"
  default = "ami-7effd318"
}

variable "ami_search_path" {
  type = "string"
  default = "ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"
}

variable "cannonical_owner_id" {
  type = "string"
  default = "099720109477"
}

variable "owner" {
  type = "string"
  default = "ylorenzati"
}

variable "node_count" {
  type = "string"
  default = "1"
}

variable "xebia_dns" {
  type = "string"
  default = "techx.fr."
}