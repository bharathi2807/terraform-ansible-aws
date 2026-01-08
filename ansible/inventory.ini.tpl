[web]
${web1_ip}
${web2_ip}

[web:vars]
ansible_user=ec2-user
ansible_ssh_private_key_file=/home/jeeva/.ssh/ansible-key.pem
ansible_python_interpreter=/usr/bin/python3
