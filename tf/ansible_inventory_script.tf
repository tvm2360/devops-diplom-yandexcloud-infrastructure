resource "null_resource" "null_start_ansible_inventory_script" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "remote-exec" {
    inline = [ "cd /opt/gitlab-runners && ./generate_inventory.sh && sudo rm -f generate_inventory.sh" ]
  }
  depends_on = [
    null_resource.null_copy_ssh_gitlab_runners_ansible_inventory_config_script_to_jumphost
  ]
}
