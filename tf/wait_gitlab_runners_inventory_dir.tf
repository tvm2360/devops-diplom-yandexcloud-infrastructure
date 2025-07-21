resource "null_resource" "null_wait_gitlab_runners_inventory_dir" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "remote-exec" {
    inline = [ " while [ ! -d /opt/gitlab-runners/inventory ]; do sleep 5; done; " ]
  }
  depends_on = [
    yandex_compute_instance.vm_jumphost
  ]
}
