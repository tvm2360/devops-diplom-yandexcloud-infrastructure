resource "local_file" "gitlab_runners_inventory_cfg_script" {
  filename = "${var.gitlab_runners_inventory_cfg_script_file}"
  file_permission = "0770"
  content = templatefile("${path.module}/templates/hosts_gitlab_runners.tpl",
    {
      runners       = yandex_compute_instance_group.ig-gitlab-runners.instances
      gitlab_ip     = yandex_compute_instance.vm_gitlab.network_interface.0.ip_address
      gitlab_nat_ip = yandex_compute_instance.vm_gitlab.network_interface.0.nat_ip_address
      default_user  = var.default_user
      use_nat       = var.gitlab_runners_connect_use_nat_ip
    }
  )
}

resource "null_resource" "gitlab_runners_inventory_cfg_script_file" {
  triggers = {
    gitlab_runners_inventory_cfg_script_file = var.gitlab_runners_inventory_cfg_script_file
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.triggers.gitlab_runners_inventory_cfg_script_file}"
  }
  depends_on = [local_file.gitlab_runners_inventory_cfg_script]
}

resource "local_file" "gitlab_runners_ansible_playbook_script" {
  filename = "${var.gitlab_runners_ansible_playbook_script_file}"
  file_permission = "0770"
  content = templatefile("${path.module}/templates/hosts_gitlab_runners_start_registry.tpl",
    {
      runners      = yandex_compute_instance_group.ig-gitlab-runners.instances
    }
  )
}

resource "null_resource" "gitlab_runners_ansible_playbook_script_file" {
  triggers = {
    gitlab_runners_ansible_playbook_script_file = var.gitlab_runners_ansible_playbook_script_file
  }
  provisioner "local-exec" {
    when    = destroy
    command = "rm -f ${self.triggers.gitlab_runners_ansible_playbook_script_file}"
  }
  depends_on = [local_file.gitlab_runners_ansible_playbook_script]
}
