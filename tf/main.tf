resource "yandex_vpc_network" "devops-diplom-network" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "devops-diplom-subnet-1" {
  name           = var.subnet_name_1
  zone           = var.zone_1
  network_id     = yandex_vpc_network.devops-diplom-network.id
  v4_cidr_blocks = var.cidr_1
  route_table_id = yandex_vpc_route_table.vpc_route_table.id
}

resource "yandex_vpc_subnet" "devops-diplom-subnet-2" {
  name           = var.subnet_name_2
  zone           = var.zone_2
  network_id     = yandex_vpc_network.devops-diplom-network.id
  v4_cidr_blocks = var.cidr_2
  route_table_id = yandex_vpc_route_table.vpc_route_table.id
}

resource "yandex_vpc_subnet" "devops-diplom-subnet-3" {
  name           = var.subnet_name_3
  zone           = var.zone_3
  network_id     = yandex_vpc_network.devops-diplom-network.id
  v4_cidr_blocks = var.cidr_3
  route_table_id = yandex_vpc_route_table.vpc_route_table.id
}

resource "yandex_vpc_subnet" "devops-diplom-subnet-4" {
  name           = var.subnet_name_4
  zone           = var.default_zone
  network_id     = yandex_vpc_network.devops-diplom-network.id
  v4_cidr_blocks = var.cidr_4
}

resource "yandex_vpc_address" "external-address" {
  name = "external-address"
  external_ipv4_address {
    zone_id                  = var.default_zone
    ddos_protection_provider = "qrator"
  }
}

resource "yandex_vpc_route_table" "vpc_route_table" {
  name       = "vpc_route_table"
  network_id = yandex_vpc_network.devops-diplom-network.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = var.vm_config["jumphost"].ip_address
  }
}

