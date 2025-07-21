resource "yandex_vpc_security_group" "sg-k8s" {
  name        = "sg-k8s"
  network_id  = yandex_vpc_network.devops-diplom-network.id
  ingress {
    protocol          = "TCP"
    predefined_target = "loadbalancer_healthchecks"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    predefined_target = "self_security_group"
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ANY"
    v4_cidr_blocks    = concat(yandex_vpc_subnet.devops-diplom-subnet-1.v4_cidr_blocks, yandex_vpc_subnet.devops-diplom-subnet-2.v4_cidr_blocks, yandex_vpc_subnet.devops-diplom-subnet-3.v4_cidr_blocks, yandex_vpc_subnet.devops-diplom-subnet-4.v4_cidr_blocks)
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol          = "ICMP"
    v4_cidr_blocks    = ["10.0.0.0/8", "172.16.0.0/12", "192.168.0.0/16"]
  }
  ingress {
    protocol          = "TCP"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 30000
    to_port           = 32767
  }
  egress {
    protocol          = "ANY"
    v4_cidr_blocks    = ["0.0.0.0/0"]
    from_port         = 0
    to_port           = 65535
  }
  ingress {
    protocol       = "TCP"
    v4_cidr_blocks = ["0.0.0.0/0"]
    port           = 443
  }
}