resource "null_resource" "null_change_gitlab_settings" {
  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = yandex_compute_instance.vm_gitlab.network_interface.0.ip_address
      user        = var.default_user
      private_key = "${local.ssh_key_1}"
      bastion_host        = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
      bastion_user        = var.default_user
      bastion_port        = 22
      bastion_private_key = "${local.ssh_key}"
    }
    inline = [<<EOF
      echo "Timeout ${var.gitlab_change_gitlab_settings_timeout} seconds....." 
      sleep ${var.gitlab_change_gitlab_settings_timeout}
      sudo sed -i 's/${yandex_compute_instance.vm_gitlab.network_interface.0.nat_ip_address}/${var.gitlab_subdomain_name}.${var.domain_name}/g' /etc/gitlab/gitlab.rb
      sudo gitlab-ctl reconfigure
      sudo gitlab-ctl restart
      sudo gitlab-rake cache:clear
    EOF
    ]
  }
  depends_on = [
    yandex_compute_instance.vm_gitlab
  ]
}

