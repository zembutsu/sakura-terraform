resource "sakuracloud_simple_monitor" "dev-mon01" {
    #target = "${sakuracloud_server.myserver.ipaddress}"
    target = "<IP_ADDRESS_HERE>"
    health_check = {
        protocol = "http"
        delay_loop = 60
        path = "/"
        status = "200"
    }
    #notify_email_enabled = true
    #notify_email_html = true
    #notify_slack_enabled = true
    #notify_slack_webhook = "https://hooks.slack.com/services/<TOKEN>"
}
