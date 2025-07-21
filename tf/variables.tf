variable "token" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive   = true
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
  sensitive   = true
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
  sensitive   = true
}

variable "dns_zone_id" {
  type        = string
  description = "https://yandex.cloud/ru/docs/dns/concepts/dns-zone"
  sensitive   = true
}

variable "certificate_id" {
  type        = string
  description = "https://yandex.cloud/ru/docs/certificate-manager/operations/managed/cert-create"
  sensitive   = true
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_1" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_2" {
  type        = string
  default     = "ru-central1-b"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "zone_3" {
  type        = string
  default     = "ru-central1-d"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}

variable "cidr_1" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cidr_2" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cidr_3" {
  type        = list(string)
  default     = ["10.0.3.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "cidr_4" {
  type        = list(string)
  default     = ["10.0.4.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "devops-diplom-network"
  description = "VPC name"
}

variable "subnet_name_1" {
  type        = string
  default     = "devops-diplom-subnet-1"
  description = "Subnet 1 name"
}

variable "subnet_name_2" {
  type        = string
  default     = "devops-diplom-subnet-2"
  description = "Subnet 2 name"
}

variable "subnet_name_3" {
  type        = string
  default     = "devops-diplom-subnet-3"
  description = "Subnet 3 name"
}

variable "subnet_name_4" {
  type        = string
  default     = "devops-diplom-subnet-4"
  description = "Subnet 4 name"
}

variable "default_user" {
  type        = string
  default     = "ubuntu"
  description = "Default user via ssh"
}

variable "os_image_1_id" {
  type        = string
  default     = "fd8a364q1kb08cqvr9o7"
  description = "Image OS ubuntu-2004-lts"
}

variable "os_image_2_id" {
  type        = string
  default     = "fd8duj8tk09diqs6t2rq"
  description = "Image OS gitlab"
}

variable "os_image_3_id" {
  type        = string
  default     = "fd816m4fbp8be1hkdopi"
  description = "Image OS nat-instance-ubuntu-2204"
}

variable "ig_config" {
  type = map(object({
    count               = number,
    cpu                 = number,
    ram                 = number,
    core_fraction       = number,
    disk_type           = string,
    disk_volume         = number,
    platform_id         = string,
    preemptible         = bool,
    use_nat             = bool,
    serial_port_enable  = number
  }))
  default     = {}
  description = "Instance group config"
}

variable "vm_config" {
  type = map(object({
    cpu                 = number,
    ram                 = number,
    core_fraction       = number,
    disk_type           = string,
    disk_volume         = number,
    platform_id         = string,
    preemptible         = bool,
    use_nat             = bool,
    ip_address          = string,
    stopping_for_update = bool,
    serial_port_enable  = number
  }))
  default     = {}
  description = "Virtual machines config"
}

variable "kubespray_inventory_destination_path" {
  type        = string
  default     = "../kubespray/inventory"
  description = "Path to export inventory for kubespray use"
}

variable "kubespray_inventory_filename" {
  type        = string
  default     = "inventory.ini"
  description = "Inventory filename for kubespray use"
}

variable "kubespray_inventory_nat_ip" {
  type        = bool
  default     = false
  description = "Use nat_ip in inventory file"
}

variable "kubespray_docker_image" {
  type        = string
  default     = "quay.io/kubespray/kubespray:v2.27.0"
  description = "Docker image path for kubespray"
}

variable "kubectl_download_link" {
  type        = string
  default     = "https://dl.k8s.io/release/v1.31.4/bin/linux/amd64/kubectl"
  description = "Kubespray link for download"
}

variable "k9s_download_link" {
  type        = string
  default     = "https://github.com/derailed/k9s/releases/download/v0.32.5/k9s_linux_amd64.deb"
  description = "K9s link for download"
}

variable "get_helm_script_download_link" {
  type        = string
  default     = "https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3"
  description = "K9s link for download"
}

variable "k8s_username" {
  type        = string
  default     = "k8suser"
  description = "Kubernetes username for create"
}

variable "k8s_default_group" {
  type        = string
  default     = "system:masters"
  description = "Kubernetes group for created user"
}

variable "k8s_user_context" {
  type        = string
  default     = "k8suser-context"
  description = "Kubernetes user context"
}

variable "gitlab_runners_connect_use_nat_ip" {
  type        = bool
  default     = false
  description = "Use gtitlab nat_ip for runners connecting"
}

variable "gitlab_runners_playbook_file" {
  type        = string
  default     = "../gitlab-runners/playbooks/site.yml"
  description = "Path to export ansible playbook file for connecting gitlab runners use"
}

variable "gitlab_runners_inventory_cfg_script_file" {
  type        = string
  default     = "../gitlab-runners/generate_inventory.sh"
  description = "Path to export ansible playbook inventory config script file for running on gitlab runners platforms"
}

variable "gitlab_runners_ansible_playbook_script_file" {
  type        = string
  default     = "../gitlab-runners/start_reg_runners.sh"
  description = "Path to export ansible playbook script file for running on gitlab runners platforms"
}

variable "alb_backend_healthcheck_interval" {
  type        = string
  default     = "1s"
  description = "Backend health check test interval"
}

variable "alb_backend_healthcheck_timeout" {
  type        = string
  default     = "1s"
  description = "Backend health check test timeout"
}

variable "alb_backend_healthcheck_port" {
  type        = number
  default     = 80
  description = "Backend health check TCP port"
}

variable "alb_backend_weight" {
  type        = number
  default     = 1
  description = "Backend weight"
}

variable "alb_backend_panic_threshold" {
  type        = number
  default     = 50
  description = "Backend panic threshold"
}

variable "domain_name" {
  type        = string
  default     = "tvm2360.ru"
  description = "Domain name"
}

variable "gitlab_subdomain_name" {
  type        = string
  default     = "gitlab"
  description = "Gitlab subdomain name"
}

variable "jumphost_subdomain_name" {
  type        = string
  default     = "jumphost"
  description = "Jumphost subdomain name"
}

variable "gitlab_change_gitlab_settings_timeout" {
  type        = number
  default     = 180
  description = "Timeout in seconds before start gitlab settings changing"
}

variable "certificate_wait_validation" {
  type        = bool
  default     = true
  description = "Wait certificate lets encrypt validation"
}
