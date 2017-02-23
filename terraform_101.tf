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


resource "aws_security_group" "goappsg" {
  name = "goappsg"

  ingress {
    from_port = 0
    to_port = 10000
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Owner = "ylorenzati"
  }
}

resource "aws_key_pair" "aws_instance_rsakey" {
  key_name = "deployer-key"
  public_key = "${file("ssh/aws_instance_rsakey.pub")}"
}


resource "aws_instance" "example" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.aws_instance_rsakey.key_name}"
  security_groups = [
    "${aws_security_group.goappsg.name}"]
  count = 2


  tags = {
    Owner = "ylorenzati"
    Name = "yli_terraform_instance"
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

resource "aws_elb" "goapplb" {

  name = "goapplb"
  availability_zones = [
    "${element(aws_instance.example.*.availability_zone, count.index)}"]

  listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  instances = [
    "${aws_instance.example.*.id}"]

  tags = {
    Owner = "ylorenzati"
  }
}

resource "aws_route53_record" "www" {
  zone_id = "Z28O5PDK1WPCSR"
  name = "mygoapp"
  type = "A"

  alias {
    name = "${aws_elb.goapplb.dns_name}"
    zone_id = "${aws_elb.goapplb.zone_id}"
    evaluate_target_health = true
  }
}