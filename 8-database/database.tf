# データベースの定義
resource "sakuracloud_database" "foobar" {
  database_type = "postgresql"
  plan          = "10g"
  user_name     = "defuser"
  user_password = "DatabasePasswordUser397"

  # レプリケーションのマスターにする場合(postgresの場合のみ指定可)
  #replica_password = "DatabasePasswordUser397"

  allow_networks = ["192.168.11.0/24", "192.168.12.0/24"]

  port = 54321

#  backup_weekdays = ["mon", "tue", "wed"]
#  backup_time     = "00:00"

  switch_id     = "${sakuracloud_switch.local-sw02.id}"
  ipaddress1    = "192.168.11.101"
  nw_mask_len   = 24
  default_route = "192.168.11.1"

  name        = "name"
  description = "description"
  tags        = ["tag1", "tag2"]
}

#接続するスイッチの定義
resource "sakuracloud_switch" "local-sw02" {
    name = "local-sw02"
    tags = ["step8"]
    description = "by Terraform"
}
