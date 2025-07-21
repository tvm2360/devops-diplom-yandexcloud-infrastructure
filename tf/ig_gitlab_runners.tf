resource "yandex_compute_instance_group" "ig-gitlab-runners" {
  name               = "ig-gitlab-runners"
  service_account_id = yandex_iam_service_account.sa-admin.id
  instance_template {
    name = "gitlab-runner{instance.index}"
    platform_id = var.ig_config["gitlab_runners"].platform_id
    resources {
      cores         = var.ig_config["gitlab_runners"].cpu
      memory        = var.ig_config["gitlab_runners"].ram
      core_fraction = var.ig_config["gitlab_runners"].core_fraction
    }
    boot_disk {
      initialize_params {
        image_id = var.os_image_1_id
        size     = var.ig_config["gitlab_runners"].disk_volume
        type     = var.ig_config["gitlab_runners"].disk_type
      }
    }
    network_interface {
      network_id = yandex_vpc_network.devops-diplom-network.id
      subnet_ids = [
        yandex_vpc_subnet.devops-diplom-subnet-1.id,
        yandex_vpc_subnet.devops-diplom-subnet-2.id,
        yandex_vpc_subnet.devops-diplom-subnet-3.id,
      ]
      nat = var.ig_config["gitlab_runners"].use_nat
      security_group_ids = [
        yandex_vpc_security_group.sg-gitlab-runners.id
      ]
    }
    scheduling_policy {
      preemptible = var.ig_config["gitlab_runners"].preemptible
    }
    metadata = {
      serial-port-enable = var.ig_config["gitlab_runners"].serial_port_enable
      ssh-keys           = "${var.default_user}:${local.ssh_pub_key_1}"
    }
    network_settings {
      type = "STANDARD"
    }
  }
  scale_policy {
    fixed_scale {
      size = var.ig_config["gitlab_runners"].count
    }
  }
  allocation_policy {
    zones = [
      var.zone_1,
      var.zone_2,
      var.zone_3,
    ]
  }
  deploy_policy {
    max_unavailable = var.ig_config["gitlab_runners"].count
    max_creating    = var.ig_config["gitlab_runners"].count
    max_expansion   = var.ig_config["gitlab_runners"].count
    max_deleting    = var.ig_config["gitlab_runners"].count
  }
}
