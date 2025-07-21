resource "yandex_compute_instance_group" "ig-k8s-masters" {
  name               = "ig-k8s-masters"
  service_account_id = yandex_iam_service_account.sa-admin.id
  instance_template {
    name = "master{instance.index}"
    platform_id = var.ig_config["masters"].platform_id
    resources {
      cores         = var.ig_config["masters"].cpu
      memory        = var.ig_config["masters"].ram
      core_fraction = var.ig_config["masters"].core_fraction
    }
    boot_disk {
      initialize_params {
        image_id = var.os_image_1_id
        size     = var.ig_config["masters"].disk_volume
        type     = var.ig_config["masters"].disk_type
      }
    }
    network_interface {
      network_id = yandex_vpc_network.devops-diplom-network.id
      subnet_ids = [
        yandex_vpc_subnet.devops-diplom-subnet-1.id,
        yandex_vpc_subnet.devops-diplom-subnet-2.id,
        yandex_vpc_subnet.devops-diplom-subnet-3.id,
      ]
      nat = var.ig_config["masters"].use_nat
      security_group_ids = [
        yandex_vpc_security_group.sg-k8s.id
      ]
    }
    scheduling_policy {
      preemptible = var.ig_config["masters"].preemptible
    }
    metadata = {
      serial-port-enable = var.ig_config["masters"].serial_port_enable
      ssh-keys           = "${var.default_user}:${local.ssh_pub_key_1}"
      user-data = <<-EOF
                  #cloud-config
                  users:
                    - default
                    - name: ${var.default_user}
                      groups:
                        - sudo
                      shell: /bin/bash
                      sudo: ALL=(ALL) NOPASSWD:ALL
                  package_update: true
                  packages:
                    - nfs-common
                  EOF
    }
    network_settings {
      type = "STANDARD"
    }
  }
  scale_policy {
    fixed_scale {
      size = var.ig_config["masters"].count
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
    max_unavailable = var.ig_config["masters"].count
    max_creating    = var.ig_config["masters"].count
    max_expansion   = var.ig_config["masters"].count
    max_deleting    = var.ig_config["masters"].count
  }
}
