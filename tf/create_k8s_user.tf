resource "null_resource" "null_create_k8s_user" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = yandex_compute_instance_group.ig-k8s-masters.instances.0.network_interface.0.ip_address
      user        = var.default_user
      private_key = "${local.ssh_key_1}"
      bastion_host        = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
      bastion_user        = var.default_user
      bastion_port        = 22
      bastion_private_key = "${local.ssh_key}"
    }
    inline = [<<EOF
      sudo id -u ${var.k8s_username} &>/dev/null || useradd ${var.k8s_username} && sudo mkdir -p /home/${var.k8s_username}
      cd /home/${var.k8s_username} && sudo mkdir -p .certs && sudo mkdir -p .kube
      sudo openssl genrsa -out ./.certs/${var.k8s_username}.key 2048
      sudo openssl req -new -key ./.certs/${var.k8s_username}.key -out ./.certs/${var.k8s_username}.csr -subj "/CN=${var.k8s_username}/O=${var.k8s_default_group}"
      sudo openssl x509 -req -in ./.certs/${var.k8s_username}.csr -CA /etc/kubernetes/ssl/ca.crt -CAkey /etc/kubernetes/ssl/ca.key -CAcreateserial -out ./.certs/${var.k8s_username}.crt -days 365
      sudo kubectl config set-credentials ${var.k8s_username} --client-certificate=/home/${var.k8s_username}/.certs/${var.k8s_username}.crt --client-key=/home/${var.k8s_username}/.certs/${var.k8s_username}.key
      sudo kubectl config set-context ${var.k8s_user_context} --cluster=cluster.local --user=${var.k8s_username}
      sudo kubectl config view --minify --flatten --context=${var.k8s_user_context} > /home/ubuntu/config
      sed -i -e 's/127.0.0.1/${yandex_compute_instance_group.ig-k8s-masters.instances.0.network_interface.0.ip_address}/g' /home/ubuntu/config
    EOF
    ]
  }
  depends_on = [
    null_resource.null_start_kubespray
  ]
}

resource "null_resource" "null_pull_kube_config" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
      user        = var.default_user
      private_key = "${local.ssh_key}"
    }
    inline = [<<EOF
      mkdir -p ~/.kube
      scp -o StrictHostKeyChecking=no ${var.default_user}@${yandex_compute_instance_group.ig-k8s-masters.instances.0.network_interface.0.ip_address}:/home/${var.default_user}/config ~/.kube/config
      helm upgrade --install ingress-nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx --namespace ingress-nginx --create-namespace --set controller.kind="DaemonSet" --set controller.hostNetwork="true"
    EOF
    ]
  }
  depends_on = [
    null_resource.null_create_k8s_user
  ]
}
