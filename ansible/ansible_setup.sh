#!/bin/bash
# Install ansible 
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y

# Create hosts file.
# Add Jenkins controller and builder as hosts.
touch /opt/hosts
cat << EOF > /opt/hosts
[jenkins-controller]
<private-ip-address>

[jenkins-controller:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/opt/devops_workshop.pem
ansible_host_key_checking=false

[jenkins-builder]
<private-ip-address>

[jenkins-builder:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=/opt/devops_workshop.pem
ansible_host_key_checking=false
EOF

ansible --version

# create pem file and set permissions
touch /opt/devops_workshop.pem
chmod 400 /opt/devops_workshop.pem

echo "Add contents to /opt/devops_workshop.pem"
echo "Add IPs to /opt/hosts"
echo "run 'ansible -i hosts all -m ping' to validate connectivity"