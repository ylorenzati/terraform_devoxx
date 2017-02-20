#!/usr/bin/env bash

alias terraform='docker run --rm -it -v $HOME/.aws/credentials:/credentials:ro -v $(pwd):/data --workdir=/data hashicorp/terraform:0.8.6'
alias ansible='docker run --rm -v $(pwd)/terraform101.inventory:/etc/ansible/hosts:ro -v $(pwd)/ssh/aws_instance_rsakey:/id_rsa:ro ansible:dev ansible -e "ansible_python_interpreter=/usr/bin/python3" --private-key /id_rsa -u ubuntu'
