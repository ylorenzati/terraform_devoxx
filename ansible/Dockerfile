FROM ubuntu:16.04

RUN echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu xenial main" > /etc/apt/sources.list.d/ansible.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367 && \
    apt-get update && \
    apt-get install -y ansible unzip && \
    apt-get clean

ADD https://github.com/adammck/terraform-inventory/releases/download/v0.7-pre/terraform-inventory_v0.7-pre_linux_amd64.zip /usr/bin

RUN cd /usr/bin && unzip terraform-inventory_v0.7-pre_linux_amd64.zip && chmod +x terraform-inventory