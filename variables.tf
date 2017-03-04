variable "ami_ubuntu" {
  type = "string"
  default = "ami-7effd318"
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
  default = "aws.xebiatechevent.info."
}