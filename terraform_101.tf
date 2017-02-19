provider "aws" {
  region     = "eu-west-1"
  shared_credentials_file = "/credentials"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/ebs-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "aws_instance_rsakey" {
  key_name = "deployer-key"
  public_key = "${file("ssh/aws_instance_rsakey.pub")}"
}

resource "aws_instance" "example" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.aws_instance_rsakey.key_name}"
  count = 2

  tags = {
    Owner = "ylorenzati"
  }

  connection {
    user = "ubuntu"
    private_key = "${file("ssh/aws_instance_rsakey")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 1"
    ]
  }
}