cp hosts /etc/ansible/
ansible-playbook --become --ask-become-pass -u adam add_client.yml
