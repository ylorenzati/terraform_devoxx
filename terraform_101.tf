# region: eu-west-1
# ami:    ami-7effd318

provider "aws" {
  region = "${var.aws_region}"
  //shared_credentials_file = "/credentials"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["${var.ami_search_path}"]
  }

  owners = ["${var.ami_owner}"]
  # Canonical
}


resource "aws_security_group" "goapp" {

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "${var.owner}"
  }
}

resource "aws_key_pair" "goapp" {
  public_key = "${file("ssh/rsakey.pub")}"
}


resource "aws_instance" "goapp" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.goapp.key_name}"
  security_groups = [
    "${aws_security_group.goapp.name}"]
  count = "${var.node_count}"

  connection {
    user = "ubuntu"
    private_key = "${file("ssh/rsakey")}"
  }

  provisioner "remote-exec" {
    inline = "sleep 1"
  }

  tags = {
    Owner = "${var.owner}"
  }
}