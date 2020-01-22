InIP=`ip -4 a show eth0 | grep -oP '(?<=inet\s)\d+(\.\d+){3}'`;
echo ${InIP} > /etc/ansible/hosts

ansible-playbook icp-install.yaml
