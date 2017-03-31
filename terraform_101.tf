# region: eu-west-1
# ami:    ami-c0cff0a6


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

  owners = ["${var.cannonical_owner_id}"]
}


resource "aws_security_group" "devoxx" {

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "${var.owner}"
    Name = "devoxx_terraform101_slot"
  }
}

resource "aws_key_pair" "devoxx" {
  public_key = "${file("ssh/rsakey.pub")}"
}


resource "aws_instance" "devoxx" {
  ami = "${data.aws_ami.ubuntu.id}"
  instance_type = "m3.medium"
  key_name = "${aws_key_pair.devoxx.key_name}"
  # security group name here
  security_groups = ["${aws_security_group.devoxx.name}"]
  count = "${var.node_count}"


  provisioner "remote-exec" {
    inline = "sleep 1"

    connection {
      user = "ubuntu"
      private_key = "${file("ssh/rsakey")}"
    }
  }

  tags = {
    Owner = "${var.owner}"
    Name = "devoxx_terraform101_slot"
  }
}

resource "aws_elb" "devoxx" {

  # refactor this
  availability_zones = ["${aws_instance.devoxx.*.availability_zone}"]

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

  instances = ["${aws_instance.devoxx.*.id}"]

  tags = {
    Owner = "${var.owner}"
    Name = "devoxx_terraform101_slot"
  }
}

data "aws_route53_zone" "xebia_dns" {
  name = "${var.xebia_dns}"
}

resource "aws_route53_record" "devoxx" {
  zone_id = "${data.aws_route53_zone.xebia_dns.id}"
  name = "devoxx"
  type = "A"

  alias {
    name = "${aws_elb.devoxx.dns_name}"
    zone_id = "${aws_elb.devoxx.zone_id}"
    evaluate_target_health = true
  }
}