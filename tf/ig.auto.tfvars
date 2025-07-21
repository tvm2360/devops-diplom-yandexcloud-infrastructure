ig_config = {
  masters = {
     count = 1,
     cpu = 2,
     ram = 2,
     core_fraction = 20,
     disk_type = "network-hdd",
     disk_volume = 10,
     platform_id = "standard-v3",
     preemptible = false,
     use_nat = false,
     serial_port_enable = 0
  },
  workers = {
     count = 3,
     cpu = 2,
     ram = 4,
     core_fraction = 20,
     disk_type = "network-hdd",
     disk_volume = 10,
     platform_id = "standard-v3",
     preemptible = true,
     use_nat = false,
     serial_port_enable = 0
  },
  gitlab_runners = {
     count = 1,
     cpu = 2,
     ram = 2,
     core_fraction = 20,
     disk_type = "network-hdd",
     disk_volume = 10,
     platform_id = "standard-v3",
     preemptible = true,
     use_nat = false,
     serial_port_enable = 0
  }
}