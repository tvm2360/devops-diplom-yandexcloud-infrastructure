resource "null_resource" "null_copy_ssh_privatekey_to_jumphost" {
  depends_on = [yandex_compute_instance.vm_jumphost]
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "file" {
    source = local.ssh_key_1_in
    destination = local.ssh_key_1_out
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 400 ${local.ssh_key_1_out}",
               "echo 'Host * ' > ${local.ssh_config}",
               "echo '   User ${var.default_user}' >> ${local.ssh_config}",
               "echo '   IdentityFile ${local.ssh_key_2_in}' >> ${local.ssh_config}"
             ]
  }
}
