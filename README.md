# terraform_devoxx

docker run -i -t hashicorp/terraform:0.8.6 version

alias terraform='docker run --rm -it -v $HOME/.aws/credentials:/credentials:ro -v $(pwd):/data --workdir=/data hashicorp/terraform:0.8.6'

terraform plan
terraform apply
terraform show
terraform destroy

# inventory
docker run --rm --workdir=/data -v $(pwd):/data ansible terraform-inventory --inventory


ssh-keygen -t rsa -C "aws_instance_rsakey" -P '' -f ssh/aws_instance_rsakey