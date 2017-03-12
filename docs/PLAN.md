5 minutes max : Explication sur terraform et contexte



Déroulement démo
Premier déploiement ::
avoir préparé valeur dans commentaire pour simplifier écriture
Déploiement basique : une instance une clef ssh
Montrer une vue de la console aws vierge avant le premier déploiement.

Montrer machine dispo sur console
Tester connexion ssh (pre configurer sssh ou rappel de commande pour rapidité)

Deuxième déploiement :
Ajout provider pour sleep timing
Ajout security group (ou dans la partie précédente ? )
Ajout deuxième instance

Montrer le teraform plan
Terraform apply

Pendant apply, mise en place des variables
Montrer dans console aws, ou terraform show la présence de 2 ip différentes

Now : déployer l'app avec ansible
Montrer / générer l'inventaire teraforum
Montrer le playbook ansible rapidement.
Expliquer ce qu'il fait pendant qu'il se déroule