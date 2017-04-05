#resource "sakuracloud_dns" "toaru" {
#    zone = "toaru.org"
#}

resource "sakuracloud_dns_record" "dev01" {
    #dns_id = "${sakuracloud_dns.toaru.id}"
    dns_id = "<ID_HERE>"
    name = "dev01"
    type = "A"
    value = "<IP_ADDRESS>"
}
