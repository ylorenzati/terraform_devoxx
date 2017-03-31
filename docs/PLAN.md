5 minutes max : Explication sur terraform et contexte



# Déroulement démo
## step01

Montrer une vue de la console aws vierge
Parler de la structure de fichier terraform

### Le provider ###

```
provider "aws" {
  region = "eu-west-2"
}
```

### une clef ssh ###

```
resource "aws_key_pair" "devoxx" {
  public_key = "${file("ssh/rsakey.pub")}"
}
```

### une instance AVEC TAG Owner et name ###
    live template : aws_instance_base

```
resource "aws_instance" "devoxx" {
  ami = "ami-ed908589"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.devoxx.key_name}"

  tags = {
    Owner = "ylorenzati"
    Name = "devoxx terraform101 slot"
  }
}
```

### premiere apply ###

terraform plan
terraform apply
parler du tfstate
Montrer une vue de la console
terraform show + grep ip
on se logue en ssh


## Deuxième déploiement ##
### Ajout security group ###

live template : aws_sec_group

```
resource "aws_security_group" "devoxx" {

  ingress {
    from_port = 0
    to_port = 65535
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Owner = "yli"
    Name = "devoxx terraform101 slot"
  }
}
```

### Ajout provisionner + connexion pour sleep timing + 4 instance ###
live template : aws_instance_provisionner
+ count 
+ securitygroup NAME

```
resource "aws_instance" "devoxx" {
  ami = "ami-ed908589"
  instance_type = "t2.medium"
  key_name = "${aws_key_pair.devoxx.key_name}"
  # security group name here
  security_groups = ["${aws_security_group.devoxx.name}"]
  count = "4"

  provisioner "remote-exec" {
    inline = "sleep 1"

    connection {
      user = "ubuntu"
      private_key = "${file("ssh/rsakey")}"
    }
  }

  tags = {
    Owner = "ylorenzati"
    Name = "devoxx terraform101 slot"
  }
}
```

teraform plan
terraform apply
montrer console aws

# TODO A voir si on fais
Pendant apply, mise en place des variables
Bonne pratique : variable dans un fichier séparé
variable aws_region et utilisation avec et sans default
data ami
Montrer dans console aws, ou terraform show la présence de 2 ip différentes


## Now : déployer l'app avec ansible ##
### Montrer / générer l'inventaire terraforum ###
`terraform-inventory`

### Lancer ansible ###
ansible-playbook ansible/playbook.yml
Montrer le playbook ansible rapidement.
Expliquer ce qu'il fait pendant qu'il se déroule

## Last part ##
### Creation de l'elb ###
live template : aws_data_route53_zone

```
data "aws_route53_zone" "xebia_dns" {
  name = "techx.fr."
}
```

### Creation Route53 ###
live template : aws_route53

```
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
```