resource "yandex_compute_instance" "vm_jumphost" {
  name            = "jumphost"
  hostname        = "jumphost"
  platform_id     = var.vm_config["jumphost"].platform_id
  resources {
    cores         = var.vm_config["jumphost"].cpu
    memory        = var.vm_config["jumphost"].ram
    core_fraction = var.vm_config["jumphost"].core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = var.os_image_3_id
      type     = var.vm_config["jumphost"].disk_type
      size     = var.vm_config["jumphost"].disk_volume
    }
  }
  scheduling_policy {
    preemptible = var.vm_config["jumphost"].preemptible
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.devops-diplom-subnet-4.id
    nat        = var.vm_config["jumphost"].use_nat
    ip_address = var.vm_config["jumphost"].ip_address
  }
  allow_stopping_for_update = var.vm_config["jumphost"].stopping_for_update
  metadata = {
    serial-port-enable = var.vm_config["jumphost"].serial_port_enable
    ssh-keys           = "${var.default_user}:${local.ssh_pub_key}"
    user-data = <<-EOF
                #cloud-config
                users:
                  - default
                  - name: ubuntu
                    groups:
                      - sudo
                    shell: /bin/bash
                    sudo: ALL=(ALL) NOPASSWD:ALL
                package_update: true
                packages:
                  - sudo
                  - ca-certificates
                  - software-properties-common
                  - curl
                  - wget
                  - mc
                runcmd:
                  - sudo install -m 0755 -d /etc/apt/keyrings
                  - curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
                  - sudo chmod a+r /etc/apt/keyrings/docker.asc
                  - echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu focal stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
                  - sudo apt-get update
                  - sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
                  - sudo docker pull ${var.kubespray_docker_image}
                  - curl -LO ${var.kubectl_download_link}
                  - sudo chmod +x ./kubectl && sudo mv ./kubectl /usr/bin/kubectl
                  - wget ${var.k9s_download_link}
                  - sudo apt install -y ./k9s_linux_amd64.deb
                  - sudo rm k9s_linux_amd64.deb
                  - curl -fsSL -o get_helm.sh ${var.get_helm_script_download_link}
                  - sudo chmod 700 get_helm.sh
                  - sudo ./get_helm.sh
                  - sudo rm get_helm.sh
                  - sudo add-apt-repository --yes --update ppa:ansible/ansible
                  - sudo apt install -y ansible
                  - sudo echo "[defaults]" >> /etc/ansible/ansible.cfg
                  - sudo echo "host_key_checking = False" >> /etc/ansible/ansible.cfg
                  - sudo mkdir -p /opt/kubespray/inventory /opt/gitlab-runners/inventory
                  - sudo chmod 0777 -R /opt/kubespray /opt/gitlab-runners
                  - sudo mkdir -p /mnt/nfs
                  - sudo chmod 0777 /mnt/nfs
                  - sudo DEBIAN_FRONTEND=noninteractive apt install -y nfs-kernel-server nfs-common
                  - sudo chown nobody:nogroup /mnt/nfs
                  - sudo chmod 646 /etc/exports
                  - sudo echo "/mnt/nfs *(rw,sync,no_subtree_check,no_root_squash)" >> /etc/exports
                  - sudo chmod 644 /etc/exports
                  - sudo exportfs -a
                  - sudo systemctl restart nfs-kernel-server
                EOF
  }
}

