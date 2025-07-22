resource "null_resource" "null_copy_ssh_kubespray_inventory_to_jumphost" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "remote-exec" {
    inline = [ "sudo rm -f /opt/kubespray/inventory/${var.kubespray_inventory_filename}" ]
  }
  provisioner "file" {
    source = "${var.kubespray_inventory_destination_path}/${var.kubespray_inventory_filename}"
    destination = "/opt/kubespray/inventory/${var.kubespray_inventory_filename}"
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 440 /opt/kubespray/inventory/${var.kubespray_inventory_filename}" ]
  }
  depends_on = [
    local_file.kubespray_inventory_cfg,
    yandex_compute_instance.vm_jumphost,
    null_resource.null_wait_kubespray_inventory_dir
  ]
}
