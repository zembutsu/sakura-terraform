variable "count" {
	default = "2"
}

resource "sakuracloud_server" "servers" {
    count = "${var.count}"
    name = "${format("server%02d", count.index + 1)}"
    disks = ["${sakuracloud_disk.disks.*.id[count.index]}"]
    tags = ["@virtio-net-pci","step5"]
    description = "by Terraform"
}

resource "sakuracloud_disk" "disks"{
    count = "${var.count}"
    name = "${format("disk%02d", count.index + 1)}"
    hostname = "${format("server%02d", count.index + 1)}"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.key.id}"]
    disable_pw_auth = true
    tags = ["step5"]
    description = "by Terraform"
}


data sakuracloud_archive "centos" {
    filter = {
        name   = "Tags"
        values = ["current-stable", "arch-64bit", "distro-centos"]
    }
}

resource "sakuracloud_ssh_key" "key"{
    name = "sshkey"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
    description = "by Terraform"
}

output "server_ip" {
   value = ["${sakuracloud_server.servers.*.base_nw_ipaddress}"]
}




