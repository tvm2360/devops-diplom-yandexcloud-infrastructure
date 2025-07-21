locals {
   ssh_key_1_in = sensitive("./id_yc_ed25519_1")
   ssh_key_2_in = sensitive("~/.ssh/id_yc_ed25519_1")
   ssh_key_1_out = sensitive("/home/ubuntu/.ssh/id_yc_ed25519_1")
   ssh_config = sensitive("~/.ssh/config")
   ssh_key = sensitive(file("./id_yc_ed25519"))
   ssh_key_1 = sensitive(file("./id_yc_ed25519_1"))
   ssh_pub_key = sensitive(file("./id_yc_ed25519.pub"))
   ssh_pub_key_1 = sensitive(file("./id_yc_ed25519_1.pub"))
}
