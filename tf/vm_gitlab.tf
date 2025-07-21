resource "yandex_compute_instance" "vm_gitlab" {
  name            = "gitlab"
  hostname        = "gitlab"
  platform_id     = var.vm_config["gitlab"].platform_id
  resources {
    cores         = var.vm_config["gitlab"].cpu
    memory        = var.vm_config["gitlab"].ram
    core_fraction = var.vm_config["gitlab"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.os_image_2_id
      type     = var.vm_config["gitlab"].disk_type
      size     = var.vm_config["gitlab"].disk_volume
    }
  }
  scheduling_policy {
    preemptible = var.vm_config["gitlab"].preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.devops-diplom-subnet-4.id
    nat       = var.vm_config["gitlab"].use_nat
    security_group_ids = [
      yandex_vpc_security_group.sg-gitlab.id
    ]
  }
  allow_stopping_for_update = var.vm_config["gitlab"].stopping_for_update
  metadata = {
    serial-port-enable = var.vm_config["gitlab"].serial_port_enable
    ssh-keys           = "${var.default_user}:${local.ssh_pub_key_1}"
  }
}
