resource "null_resource" "null_copy_ssh_gitlab_runners_ansible_playbook_to_jumphost" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "file" {
    source = "${var.gitlab_runners_playbook_file}"
    destination = "/opt/gitlab-runners/site.yml"
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 440 /opt/gitlab-runners/site.yml" ]
  }
  depends_on = [
    yandex_compute_instance.vm_jumphost,
    null_resource.null_wait_gitlab_runners_inventory_dir
  ]
}

resource "null_resource" "null_copy_ssh_gitlab_runners_ansible_inventory_config_script_to_jumphost" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "file" {
    source = "${var.gitlab_runners_inventory_cfg_script_file}"
    destination = "/opt/gitlab-runners/generate_inventory.sh"
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 770 /opt/gitlab-runners/generate_inventory.sh" ]
  }
  depends_on = [
    yandex_compute_instance.vm_jumphost,
    null_resource.null_wait_gitlab_runners_inventory_dir,
    null_resource.gitlab_runners_inventory_cfg_script_file
  ]
}

resource "null_resource" "null_copy_ssh_gitlab_runners_ansible_playbook_script_to_jumphost" {
  connection {
    host = yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address
    type = "ssh"
    user = var.default_user
    private_key = "${local.ssh_key}"
  }
  provisioner "file" {
    source = "${var.gitlab_runners_ansible_playbook_script_file}"
    destination = "/opt/gitlab-runners/start_reg_runners.sh"
  }
  provisioner "remote-exec" {
    inline = [ "sudo chmod 770 /opt/gitlab-runners/start_reg_runners.sh" ]
  }
  depends_on = [
    yandex_compute_instance.vm_jumphost,
    null_resource.null_wait_gitlab_runners_inventory_dir,
    null_resource.gitlab_runners_ansible_playbook_script_file
  ]
}

