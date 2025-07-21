resource "yandex_dns_recordset" "tvm2360-recordset-in-domain" {
  zone_id = var.dns_zone_id
  name    = "${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_alb_load_balancer.alb.listener[0].endpoint[0].address[0].external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "tvm2360-recordset-in-subdomain-1" {
  zone_id = var.dns_zone_id
  name    = "${var.gitlab_subdomain_name}.${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.vm_gitlab.network_interface.0.nat_ip_address]
}

resource "yandex_dns_recordset" "tvm2360-recordset-in-subdomain-2" {
  zone_id = var.dns_zone_id
  name    = "${var.jumphost_subdomain_name}.${var.domain_name}."
  type    = "A"
  ttl     = 600
  data    = [yandex_compute_instance.vm_jumphost.network_interface.0.nat_ip_address]
}

data "yandex_cm_certificate" "tvm2360-cm-certificate" {
  certificate_id  = var.certificate_id
  wait_validation = var.certificate_wait_validation
}
