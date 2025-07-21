resource "local_file" "kubespray_inventory_cfg" {
  filename = "${var.kubespray_inventory_destination_path}/${var.kubespray_inventory_filename}"
  file_permission = "0644"
  content = templatefile("${path.module}/templates/hosts_kubespray.tpl",
    {
      masters   = yandex_compute_instance_group.ig-k8s-masters.instances
      workers   = yandex_compute_instance_group.ig-k8s-workers.instances
      user      = var.default_user
      use_nat   = var.kubespray_inventory_nat_ip
    }
  )
}

resource "null_resource" "kubespray_inventory_cfg_file" {
  triggers = {
    kubespray_inventory_destination_path     = var.kubespray_inventory_destination_path
    kubespray_inventory_filename             = var.kubespray_inventory_filename
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.triggers.kubespray_inventory_destination_path}/${self.triggers.kubespray_inventory_filename}"
  }
  depends_on = [local_file.kubespray_inventory_cfg]
}
