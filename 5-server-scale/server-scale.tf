variable "count" {
        default = "5"
}

resource "sakuracloud_server" "servers" {
    count = "${var.count}"
    name = "${format("server%02d", count.index + 1)}"
    hostname = "${format("server%02d", count.index + 1)}"
    disks = ["${sakuracloud_disk.disks.*.id[count.index]}"]
    tags = ["@virtio-net-pci","step5"]
    description = "by Terraform"
    ssh_key_ids = ["${sakuracloud_ssh_key.key.id}"]
    disable_pw_auth = true
}

resource "sakuracloud_disk" "disks"{
    count = "${var.count}"
    name = "${format("server%02d", count.index + 1)}"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    tags = ["step5"]
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
    value = ["${sakuracloud_server.servers.*.ipaddress}"]
}
