locals {
  ansible_user_data = <<-EOF
#!/bin/bash

#updating the instance and install tools
sudo yum update -y
sudo yum install wget -y
sudo yum install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
sudo ln -svf /usr/local/bin/aws /usr/bin/aws
sudo bash -c 'echo "StrictHostKeyChecking No" >> /etc/ssh/ssh_config'

#configuring awscli on the ansible server
sudo su -c "aws configure set aws_access_key_id ${aws_iam_access_key.user-access-key.id}" ec2-user
sudo su -c "aws configure set aws_secret_access_key ${aws_iam_access_key.user-access-key.secret}" ec2-user
sudo su -c "aws configure set default.region us-west-2" ec2-user
sudo su -c "aws configure set default.output json" ec2-user

# Set Access_keys as ENV Variables
export AWS_ACCESS_KEY_ID=${aws_iam_access_key.user-access-key.id}
export AWS_SECRET_ACCESS_KEY=${aws_iam_access_key.user-access-key.secret}

# install ansible
wget https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
sudo yum install epel-release-latest-7.noarch.rpm -y
sudo yum update -y
sudo yum install python python-devel python-pip ansible -y
sudo -E pip3 install pexpect

# copying files from local machines into Ansible server
sudo echo "${file(var.prod-bashscript)}" >> /etc/ansible/prod-bashscript.sh
sudo echo "${file(var.prod-playbook)}" >> /etc/ansible/prod-playbook.yml
sudo echo "${file(var.prod-trigger)}" >> /etc/ansible/prod-trigger.yml
sudo echo "${file(var.stage-bashscript)}" >> /etc/ansible/stage-bashscript.sh
sudo echo "${file(var.stage-playbook)}" >> /etc/ansible/stage-playbook.yml
sudo echo "${file(var.stage-trigger)}" >> /etc/ansible/stage-trigger.yml
sudo echo "${file(var.password)}" >> /etc/ansible/password.yml
sudo echo "${var.private-key}" >> /etc/ansible/key.pem
sudo bash -c 'echo "NEXUS_IP: ${var.nexus-server-ip}:8085" > /etc/ansible/ansible_vars_file.yml'
echo 'admin123' > /etc/ansible/pass.txt
ansible-vault encrypt --vault-password-file /etc/ansible/pass.txt /etc/ansible/prod-playbook.yml
ansible-vault encrypt --vault-password-file /etc/ansible/pass.txt /etc/ansible/stage-playbook.yml
rm -rvf /etc/ansible/pass.txt

# Give the right permissions to the files copied from the local machine into the ansible server
sudo chown -R ec2-user:ec2-user /etc/ansible
sudo chmod 400 /etc/ansible/key.pem
sudo chmod 755 /etc/ansible/stage-bashscript.sh
sudo chmod 755 /etc/ansible/prod-bashscript.sh

#creating crontab to execute auto discovery script
echo "*/5 * * * * ec2-user sh /etc/ansible/stage-bashscript.sh" > /etc/crontab
echo "*/5 * * * * ec2-user sh /etc/ansible/prod-bashscript.sh" >> /etc/crontab

#Install New relic
curl -Ls https://download.newrelic.com/install/newrelic-cli/scripts/install.sh | bash && sudo  NEW_RELIC_API_KEY=NRAK-81D5A0VU3I67CXWHC7ENSQE45IK NEW_RELIC_ACCOUNT_ID=4091023 NEW_RELIC_REGION=EU /usr/local/bin/newrelic install -y
sudo hostnamectl set-hostname Ansible
EOF
}