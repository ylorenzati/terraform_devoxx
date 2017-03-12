5 minutes max : Explication sur terraform et contexte



# Déroulement démo

##
Montrer une vue de la console aws vierge
Le provider
une instance AVEC TAG Owner
une clef ssh
terraform apply
Montrer une vue de la console
terraform show + grep ip
on se logue en ssh
et on ping

Deuxième déploiement :
Ajout security group
Ajout provisionner + connexion pour sleep timing
Ajout 4 instance
teraform plan
terraform apply
montrer console aws

Pendant apply, mise en place des variables
Bonne pratique : variable dans un fichier séparé
variable aws_region et utilisation avec et sans default
Montrer dans console aws, ou terraform show la présence de 2 ip différentes

data ami
#TODO recreation d'instance bizarre, a creuser

Now : déployer l'app avec ansible
Montrer / générer l'inventaire teraforum
Montrer le playbook ansible rapidement.
Expliquer ce qu'il fait pendant qu'il se déroule

Creation de l'elb
Avec ou sans la parti healthcheck ?

Creation Route53
TODO belles phrase d'accroche sur route53