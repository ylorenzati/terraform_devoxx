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

resource "aws_elb" "goapp" {

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
  name = "tfdevoxx"
  type = "A"

  alias {
    name = "${aws_elb.goapp.dns_name}"
    zone_id = "${aws_elb.goapp.zone_id}"
    evaluate_target_health = true
  }
}