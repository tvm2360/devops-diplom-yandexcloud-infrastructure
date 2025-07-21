#!/bin/bash

%{ for host in runners ~}
cat << EOF > ./inventory/host-${host["name"]}.yml
---
all:
  hosts:
    gitlab-runners:
      ansible_host: ${host["network_interface"][0]["ip_address"]}
  vars:
    ansible_connection_type: paramiko
    ansible_user: ${default_user}
%{if use_nat}
    gitlab_url: "http://${gitlab_nat_ip}/"
%{else}
    gitlab_url: "http://${gitlab_ip}/"
%{endif}
    gitlab_registration_token: "................."
    gitlab_executor: "docker"
    gitlab_docker_image: "atnartur/yc:latest"
    gitlab_description: "docker-runner"
    gitlab_tag_list: "docker,yc"
    gitlab_run_untagged: "true"
    gitlab_locked: "false"
    gitlab_access_level: "not_protected"
EOF
%{ endfor ~}
