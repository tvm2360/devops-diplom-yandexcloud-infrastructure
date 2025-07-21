resource "yandex_alb_target_group" "alb-target-group-1" {
  name        = "alb-target-group-1"
  folder_id = var.folder_id
  dynamic "target" {
    for_each = [
      for current_instance in yandex_compute_instance_group.ig-k8s-workers.instances : current_instance
      if current_instance.network_interface.0.subnet_id == yandex_vpc_subnet.devops-diplom-subnet-1.id
    ]
    content {
      subnet_id = yandex_vpc_subnet.devops-diplom-subnet-1.id
      ip_address   = target.value.network_interface.0.ip_address
    }
  }
  depends_on = [
    yandex_compute_instance_group.ig-k8s-workers
  ]
}

resource "yandex_alb_target_group" "alb-target-group-2" {
  name        = "alb-target-group-2"
  folder_id = var.folder_id
  dynamic "target" {
    for_each = [
      for current_instance in yandex_compute_instance_group.ig-k8s-workers.instances : current_instance
      if current_instance.network_interface.0.subnet_id == yandex_vpc_subnet.devops-diplom-subnet-2.id
    ]
    content {
      subnet_id = yandex_vpc_subnet.devops-diplom-subnet-2.id
      ip_address   = target.value.network_interface.0.ip_address
    }
  }
  depends_on = [
    yandex_compute_instance_group.ig-k8s-workers
  ]
}

resource "yandex_alb_target_group" "alb-target-group-3" {
  name        = "alb-target-group-3"
  folder_id = var.folder_id
  dynamic "target" {
    for_each = [
      for current_instance in yandex_compute_instance_group.ig-k8s-workers.instances : current_instance
      if current_instance.network_interface.0.subnet_id == yandex_vpc_subnet.devops-diplom-subnet-3.id
    ]
    content {
      subnet_id = yandex_vpc_subnet.devops-diplom-subnet-3.id
      ip_address   = target.value.network_interface.0.ip_address
    }
  }
  depends_on = [
    yandex_compute_instance_group.ig-k8s-workers
  ]
}

resource "yandex_alb_backend_group" "alb-backend-group" {
  name = "alb-backend-group"
  http_backend {
    name             = "http-backend"
    weight           = var.alb_backend_weight
    port             = var.alb_backend_healthcheck_port
    target_group_ids = [
      "${yandex_alb_target_group.alb-target-group-1.id}",
      "${yandex_alb_target_group.alb-target-group-2.id}",
      "${yandex_alb_target_group.alb-target-group-3.id}"
    ]
    load_balancing_config {
      panic_threshold = var.alb_backend_panic_threshold
    }
    healthcheck {
      timeout  = var.alb_backend_healthcheck_timeout
      interval = var.alb_backend_healthcheck_interval
      http_healthcheck {
        path = "/"
      }
    }
  }
}

resource "yandex_alb_http_router" "alb-router" {
  name   = "alb-router"
}

resource "yandex_alb_virtual_host" "alb-virtual-host" {
  name           = "alb-virtualhost"
  http_router_id = yandex_alb_http_router.alb-router.id
  route {
    name = "route-1"
    http_route {
      http_route_action {
        backend_group_id = yandex_alb_backend_group.alb-backend-group.id
      }
    }
  }
}

resource "yandex_alb_load_balancer" "alb" {
  name               = "alb"
  network_id         = yandex_vpc_network.devops-diplom-network.id
  allocation_policy {
    location {
      zone_id   = var.zone_1
      subnet_id = yandex_vpc_subnet.devops-diplom-subnet-1.id
    }
  }
  listener {
    name = "alb-listener"
    endpoint {
      address {
        external_ipv4_address {
          address = yandex_vpc_address.external-address.external_ipv4_address[0].address
        }
      }
      ports = [443]
    }
    tls {
      default_handler {
        http_handler {
          http_router_id = yandex_alb_http_router.alb-router.id
        }
        certificate_ids = [var.certificate_id]
      }
    }
  }
  depends_on = [
    yandex_alb_backend_group.alb-backend-group,
    yandex_alb_target_group.alb-target-group-1,
    yandex_alb_target_group.alb-target-group-2,
    yandex_alb_target_group.alb-target-group-3
  ]
}
