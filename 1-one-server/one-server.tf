
resource "sakuracloud_server" "server01" {
    name = "server01"
    disks = ["${sakuracloud_disk.disk01.id}"]
    tags = ["@virtio-net-pci","step1"]
    description = "by Terraform"
}

resource "sakuracloud_disk" "disk01"{
    name = "disk01"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.key.id}"]
    disable_pw_auth = true
    tags = ["step1"]
    description = "by Terraform"
}


data sakuracloud_archive "centos" {
    os_type = "centos"
}

resource "sakuracloud_ssh_key" "key"{
    name = "sshkey"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
    description = "by Terraform"
}

output "server_ip" {
   value = "${sakuracloud_server.server01.ipaddress}"
}



