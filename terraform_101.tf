provider "aws" {
  region = "eu-west-1"
  shared_credentials_file = "/credentials"
}


data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/ebs-ssd/ubuntu-xenial-16.04-amd64-server-*"]
  }

  owners = ["099720109477"]
  # Canonical
}


resource "aws_security_group" "goapp" {
  name = "goappsg"

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = [
      "0.0.0.0/0"]
  }

  tags = {
    Owner = "${var.owner}"
  }
}

resource "aws_key_pair" "goapp" {
  key_name = "goapp-key"
  public_key = "${file("ssh/aws_instance_rsakey.pub")}"
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
    private_key = "${file("ssh/aws_instance_rsakey")}"
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 1"
    ]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "yli_terraform_instance"
  }
}

resource "aws_elb" "goapp" {

  name = "goapplb"

  # refactor this
  availability_zones = [
    "${aws_instance.goapp.*.availability_zone}"]


  listener {
    instance_port = 8080
    instance_protocol = "tcp"
    lb_port = 80
    lb_protocol = "tcp"
  }

  health_check {
    healthy_threshold = 2
    unhealthy_threshold = 5
    target = "TCP:8080"
    interval = 5
    timeout = 4
  }

  instances = [
    "${aws_instance.goapp.*.id}"]

  tags = {
    Owner = "${var.owner}"
  }
}

data "aws_route53_zone" "xebia_dns" {
  name = "${var.xebia_dns}"
}

resource "aws_route53_record" "goapp" {
  zone_id = "${data.aws_route53_zone.xebia_dns.id}"
  name = "goapp"
  type = "A"

  alias {
    name = "${aws_elb.goapp.dns_name}"
    zone_id = "${aws_elb.goapp.zone_id}"
    evaluate_target_health = true
  }
}