#!/bin/bash

%{ for host in runners ~}
echo "Start playbook for runner ${host["name"]}"
ansible-playbook -i ./inventory/host-${host["name"]}.yml site.yml
%{ endfor ~}


