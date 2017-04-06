
resource "sakuracloud_server" "dev01" {
    name = "dev01"
    disks = ["${sakuracloud_disk.dev01.id}"]
    tags = ["@virtio-net-pci","step2"]
    packet_filter_ids = ["${sakuracloud_packet_filter.dev_ssh_http.id}"]
    description = "by Terraform"
    provisioner "remote-exec" {
        connection {
            type = "ssh"
	    user = "root"
            host = "${sakuracloud_server.dev01.base_nw_ipaddress}"
            private_key = "${file("~/.ssh/id_rsa")}"
        }
        inline = [
		"yum -y update",
		"yum -y install httpd",
		"systemctl enable httpd",
		"systemctl start httpd",
		"echo hello, this is ${sakuracloud_server.dev01.base_nw_ipaddress} > /var/www/html/index.html",
		"firewall-cmd --add-port=80/tcp --permanent",
		"firewall-cmd --reload"
        ]
    }
}

resource "sakuracloud_disk" "dev01"{
    name = "dev01"
    hostname = "dev01"
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    ssh_key_ids = ["${sakuracloud_ssh_key.key.id}"]
    disable_pw_auth = true
    tags = ["step2"]
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
   value = "${sakuracloud_server.dev01.base_nw_ipaddress}"
}

resource "sakuracloud_packet_filter" "dev_ssh_http" {
    name = "dev_ssh_http"
    tags = ["step2"]
    description = "by Terraform"
    expressions = {
        protocol = "icmp"
        allow = true
    }
    expressions = {
        protocol = "tcp"
        #source_nw = "192.168.2.0/24"
        #source_port = "0-65535"
        dest_port = "22"
        allow = true
    }
    expressions = {
        protocol = "tcp"
        #source_nw = "192.168.2.0/24"
        #source_port = "0-65535"
        dest_port = "80"
        allow = true
    }
    expressions = {
        protocol = "ip"
        source_nw = "0.0.0.0"
        allow = false
        description = "Deny all"
    }
}

