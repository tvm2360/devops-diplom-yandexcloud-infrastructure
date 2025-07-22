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

