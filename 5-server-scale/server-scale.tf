resource "sakuracloud_switch" "local-sw01" {
    name = "local-sw01"
    tags = ["step6"]
    description = "by Terraform"
}

resource "sakuracloud_server" "web01" {
    name = "web01"
    hostname = "web01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.web01.id}"]
    tags = ["@virtio-net-pci","step6"]
    nic = "shared"
    additional_nics = ["${sakuracloud_switch.local-sw01.id}"]
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
}

resource "sakuracloud_disk" "web01"{
    name = "web01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    tags = ["step6"]
}

resource "sakuracloud_server" "db01" {
    name = "db01"
    hostname = "db01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.db01.id}"]
    tags = ["@virtio-net-pci","step6"]
    nic = "shared"
    additional_nics = ["${sakuracloud_switch.local-sw01.id}"]
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
}

resource "sakuracloud_disk" "db01"{
    name = "db01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    tags = ["step6"]
}

data "sakuracloud_archive" "centos" {
    os_type = "centos"
}

resource "sakuracloud_ssh_key" "terraform"{
    name = "terraform-sshkey"
    public_key = "${file("~/.ssh/id_rsa.pub")}"
    description = "by Terraform"
}

[terraform@terraform sakura-terraform]$
[terraform@terraform sakura-terraform]$ cat 5-server-scale/
.terraform/               server-scale.tf           terraform.tfstate.backup
README.md                 terraform.tfstate
[terraform@terraform sakura-terraform]$ cat 5-server-scale/server-scale.tf
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
