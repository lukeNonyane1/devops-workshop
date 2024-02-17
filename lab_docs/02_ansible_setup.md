
# Setup Ansible
1. Install ansible on Ubuntu 22.04 
   ```sh 
   sudo apt update
   sudo apt install software-properties-common -y
   sudo add-apt-repository --yes --update ppa:ansible/ansible
   sudo apt install ansible -y
   ```

2. Add Jenkins controller and target as hosts 
Add jenkins controller and target private IPs in the inventory file 
in this case, we are using /opt is our working directory for Ansible. 
   ```
    [jenkins-controller]
    <private-ip-address>
    
    [jenkins-controller:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=/opt/devops_workshop.pem
    ansible_host_key_checking=false
    
    [jenkins-target]
    <private-ip-address>
    
    [jenkins-target:vars]
    ansible_user=ubuntu
    ansible_ssh_private_key_file=/opt/devops_workshop.pem
    ansible_host_key_checking=false
   ```
2.1 Upload your pem key file to /opt/ directory on the ansible-controller.
   - copy the contents of your pem file and paste into /opt/devops_workshop.pem
   ```
   vim /opt/devops_workshop.pem
   ```
   - modify permissions on pem file
   ```
   chmod 400 /opt/devops_workshop.pem
   ```

1. Test the connection  
   ```sh
   ansible -i hosts all -m ping 
   ```