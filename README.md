<h1 align="center" id="title">Pet Adoption Ansible Auto Discovery</h1>
<p id="description">Ensuring a secure environment is crucial during application development. Servers, databases, and other components must be shielded from unauthorized access. In this project, we implement a Bastion Host, also referred to as a "jump box," to enable secure SSH access to our application servers. This configuration places our servers within a private subnet with strictly controlled access.

Additionally, the project introduces the principle of least privilege, meaning user access rights are limited to the essentials required for their tasks.

In a highly available system, application servers are distributed across multiple availability zones. Each zone contains identically configured servers. This setup enables seamless redirection by the application load balancer to servers in another zone if one becomes unavailable. The project includes an Ansible bash script designed to detect and update newly provisioned instances, ensuring they run the latest version from our private Docker Hub repository.
</p>
<p id="description">Here is the architectural diagram representing the project's objectives.</p>

![image](https://github.com/Iyewumi-Adesupo/Pet-Adoption-Ansible-Auto_Discovery-Project-/assets/135404420/19a82d45-64f8-41ae-a657-ef055e3f6473)

<p id="description">locals {
  ansible_user_data = <<-EOF
#!/bin/bash

# update instance and install ansible
sudo yum update -y
sudo dnf install -y ansible-core
sudo yum install python-pip -y
sudo -E pip3 install pexpect

# install wget, unzip, aws cli
sudo yum install wget -y
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws /usr/bin/aws
sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'

# configuring aws cli on our instance
sudo su -c "aws configure set aws_access_key_id ${aws_iam_access_key.user-access-key.id}" ec2-user
sudo su -c "aws configure set aws_secret_access_key ${aws_iam_access_key.user-access-key.secret}" ec2-user
sudo su -c "aws configure set default.region eu-west-3" ec2-user
sudo su -c "aws configure set default.output text" ec2-user

# setting credentials as environment variable on our instance
export AWS_ACCESS_KEY_ID=${aws_iam_access_key.user-access-key.id}
export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.user-access-key.secret}

# copying files from local machines to ansible server
sudo echo "${file(var.stage-playbook)}" >> /etc/ansible/stage-playbook.yml
sudo echo "${file(var.prod-playbook)}" >> /etc/ansible/prod-playbook.yml
sudo echo "${file(var.stage-bash-script)}" >> /etc/ansible/stage-bash-script.sh
sudo echo "${file(var.prod-bash-script)}" >> /etc/ansible/prod-bash-script.sh
sudo echo "${file(var.stage-trigger)}" >> /etc/ansible/stage-trigger.yml
sudo echo "${file(var.prod-trigger)}" >> /etc/ansible/prod-trigger.yml
sudo echo "${file(var.password)}" >> /etc/ansible/password.yml
sudo echo "${var.private-key}" >> /etc/ansible/key.pem
sudo bash -c 'echo "NEXUS_IP: ${var.nexus-server-ip}:8085" > /etc/ansible/ansible_vars_file.yml'

# pass.txt
echo 'admin123' > /etc/ansible/pass.txt
ansible-vault encrypt --vault-password-file /etc/ansible/pass.txt /etc/ansible/stage-playbook.yml
ansible-vault encrypt --vault-password-file /etc/ansible/pass.txt /etc/ansible/prod-playbook.yml
rm -rvf /etc/ansible/pass.txt

# giving the right permission to the files
sudo chown -R ec2-user:ec2-user /etc/ansible
sudo chmod 400 /etc/ansible/key.pem
sudo chmod 755 /etc/ansible/stage-bash-script.sh
sudo chmod 755 /etc/ansible/prod-bash-script.sh

#creating crontab to execute auto discovery script
echo "*/5 * * * * ec2-user sh /etc/ansible/stage-bash-script.sh" > /etc/crontab
echo "*/5 * * * * ec2-user sh /etc/ansible/prod-bash-script.sh" >> /etc/crontab

# adding newrelic agent to ansible server
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo  NEW_RELIC_API_KEY=NRAK-9D4ZJK6FA2133JZT3QZN0QHW3HT NEW_RELIC_ACCOUNT_ID=4092682 NEW_RELIC_REGION=EU /usr/local/bin/newrelic install
sudo hostnamectl set-hostname Ansible

EOF
} </p>
