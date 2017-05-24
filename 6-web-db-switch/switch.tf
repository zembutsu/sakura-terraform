resource "sakuracloud_switch" "local-sw01" {
    name = "local-sw01"
    tags = ["step6"]
    description = "by Terraform"
}

resource "sakuracloud_server" "web01" {
    name = "web01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.web01.id}"]
    tags = ["@virtio-net-pci","step6"]
    nic = "shared"
    additional_nics = ["${sakuracloud_switch.local-sw01.id}"]
}

resource "sakuracloud_disk" "web01"{
    name = "web01"
    hostname = "web01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
    tags = ["step6"]
}

resource "sakuracloud_server" "db01" {
    name = "db01"
    description = "by Terraform"
    core = "1"
    memory = "1"
    disks = ["${sakuracloud_disk.db01.id}"]
    tags = ["@virtio-net-pci","step6"]
    nic = "shared"
    additional_nics = ["${sakuracloud_switch.local-sw01.id}"]
}

resource "sakuracloud_disk" "db01"{
    name = "db01"
    hostname = "db01"
    description = "by Terraform"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.terraform.id}"]
    disable_pw_auth = true
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

