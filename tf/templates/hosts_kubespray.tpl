[kube_control_plane]
%{ for host in masters ~}
%{if use_nat}
${host["name"]} ansible_host=${user}@${host["network_interface"][0]["nat_ip_address"]} ip=${host["network_interface"][0]["ip_address"]} etcd_member_name=${replace(host["name"], "master", "etcd")}
%{else}
${host["name"]} ansible_host=${user}@${host["network_interface"][0]["ip_address"]} ip=${host["network_interface"][0]["ip_address"]} etcd_member_name=${replace(host["name"], "master", "etcd")}
%{endif}
%{ endfor ~}

[etcd:children]
kube_control_plane

[kube_node]
%{ for host in workers ~}
%{if use_nat}
${host["name"]} ansible_host=${user}@${host["network_interface"][0]["nat_ip_address"]} ip=${host["network_interface"][0]["ip_address"]}
%{else}
${host["name"]} ansible_host=${user}@${host["network_interface"][0]["ip_address"]} ip=${host["network_interface"][0]["ip_address"]}
%{endif}
%{ endfor ~}

