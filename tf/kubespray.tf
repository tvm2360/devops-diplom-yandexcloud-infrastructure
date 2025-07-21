resource "null_resource" "null_start_kubespray" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "remote-exec" {
    inline = [ "sudo docker run --rm -it --mount type=bind,source=/opt/kubespray/inventory,dst=/inventory --mount type=bind,source=${local.ssh_key_1_out},dst=/root/.ssh/ssh_key ${var.kubespray_docker_image} ansible-playbook -i /inventory/${var.kubespray_inventory_filename} --private-key /root/.ssh/ssh_key cluster.yml --become" ]
  }
  depends_on = [
    null_resource.null_copy_ssh_kubespray_inventory_to_jumphost
  ]
}
