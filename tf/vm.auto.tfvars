vm_config = {
  jumphost = {
     cpu = 2,
     ram = 2,
     core_fraction = 20,
     disk_type = "network-hdd",
     disk_volume = 30,
     platform_id = "standard-v3",
     preemptible = false,
     use_nat = true,
     ip_address = "10.0.4.254",
     stopping_for_update = true,
     serial_port_enable = 0
  },
  gitlab = {
     cpu = 2,
     ram = 8,
     core_fraction = 50,
     disk_type = "network-hdd",
     disk_volume = 20,
     platform_id = "standard-v3",
     preemptible = false,
     use_nat = true,
     ip_address = "",
     stopping_for_update = true,
     serial_port_enable = 0
  }
}
