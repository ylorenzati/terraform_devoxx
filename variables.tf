variable "ami" {
  type = "string"
  default = "ami-7effd318"
}

variable "owner" {
  type = "string"
  default = "ylorenzati"
}

variable "zone_id_xebia" {
  type = "string"
}

variable "node_count" {
  type = "string"
  default = "1"
}

variable "users" {
  type = "list"
}