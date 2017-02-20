# terraform_devoxx

docker run -i -t hashicorp/terraform:0.8.6 version

alias terraform='docker run --rm -it -v $HOME/.aws/credentials:/credentials:ro -v $(pwd):/data --workdir=/data hashicorp/terraform:0.8.6'

terraform plan
terraform apply
terraform show
terraform destroy

# inventory
docker run --rm --workdir=/data -v $(pwd):/data ansible terraform-inventory --inventory > inventory.tmp


ssh-keygen -t rsa -C "aws_instance_rsakey" -P '' -f ssh/aws_instance_rsakey

#launch ansible cmd
docker run --rm -v $(pwd)/inventory.tmp:/etc/ansible/hosts:ro -v $(pwd)/ssh/aws_instance_rsakey:/id_rsa:ro ansible:dev ansible -e 'ansible_python_interpreter=/usr/bin/python3' --private-key /id_rsa all -m ping -u ubuntu
alias ansible='docker run --rm -v $(pwd)/inventory.tmp:/etc/ansible/hosts:ro -v $(pwd)/ssh/aws_instance_rsakey:/id_rsa:ro ansible:dev ansible -e "ansible_python_interpreter=/usr/bin/python3" --private-key /id_rsa -u ubuntu'

/etc/ansible/hosts
--private-key /id_rsa