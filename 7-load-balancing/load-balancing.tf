# データソース(アーカイブ)
data sakuracloud_archive "centos" {
    os_type = "centos"
}

# ディスク
resource "sakuracloud_disk" "disks" {
    # 2台分
    count = 2
    # ディスク名
    name = "disk${count.index}"
    hostname = "server${count.index}"
    # コピー元アーカイブ(CentOS7を利用)
    source_archive_id = "${data.sakuracloud_archive.centos.id}"
    # パスワード
    password = "YOUR_PASSWORD_HERE"

    # スタートアップスクリプトと紐付け
    note_ids = ["${sakuracloud_note.setup_lb_dsr.id}","${sakuracloud_note.install_httpd.id}"]
}

# サーバー
resource "sakuracloud_server" "servers" {
    # 2台分
    count = 2
    # サーバー名
    name = "server${count.index}"
    # 接続するディスク
    disks = ["${sakuracloud_disk.disks.*.id[count.index]}"]
    # タグ(NICの準仮想化モード有効化)
    tags = ["@virtio-net-pci"]

    # ルータ+スイッチを接続
    nic = "${sakuracloud_internet.router.switch_id}"

    # eth0のIPアドレス/ネットマスク/ゲートウェイ設定
    ipaddress = "${sakuracloud_internet.router.ipaddresses[count.index]}"
    nw_mask_len = "${sakuracloud_internet.router.nw_mask_len}"
    gateway = "${sakuracloud_internet.router.gateway}"
}

# ルータ+スイッチ
resource "sakuracloud_internet" "router" {
    name = "router"
}

#---------------------------------------
# スタートアップスクリプト
#---------------------------------------
# DSR方式に対応するための通信設定用スタートアップスクリプト
resource "sakuracloud_note" "setup_lb_dsr" {
    name = "setup_lb_dsr"
    # VIPを反映したテンプレートの値を参照する
    content = "${data.template_file.lb_dsr_tmpl.rendered}"
}
# 割り当てられたVIPをスタートアップスクリプトに反映するためのテンプレート
data "template_file" "lb_dsr_tmpl" {
  template = "${file("setup_lb_dsr.sh")}"

  vars {
    # ルータ+スイッチのグローバルIPを参照しテンプレートに渡す
    vip = "${sakuracloud_internet.router.ipaddresses[3]}"
  }
}

# apache(httpd)をインストールするためのスタートアップスクリプト
resource "sakuracloud_note" "install_httpd" {
    name = "install_httpd"
    content = "${file("install_httpd.sh")}"
}

#---------------------------------------
# ロードバランサー
#---------------------------------------

# ロードバランサー本体
resource "sakuracloud_load_balancer" "lb" {
    name = "load_balancer"
    # 接続するルータ+スイッチのID
    switch_id = "${sakuracloud_internet.router.switch_id}"
    # VRID(複数のロードバランサーを利用する場合、一意になる値を指定すること)
    VRID = 1

    # IPv4アドレス#1 / ネットマスク / ゲートウェイ
    ipaddress1 = "${sakuracloud_internet.router.ipaddresses[2]}"
    nw_mask_len = "${sakuracloud_internet.router.nw_mask_len}"
    default_route = "${sakuracloud_internet.router.gateway}"
}

# ロードバランサーのVIP
resource "sakuracloud_load_balancer_vip" "vip" {
    # VIPが紐づくロードバランサのID
    load_balancer_id = "${sakuracloud_load_balancer.lb.id}"

    # VIP
    vip = "${sakuracloud_internet.router.ipaddresses[3]}"

    # 監視ポート
    port = 80
}

# ロードバランサー配下にサーバーを登録
resource "sakuracloud_load_balancer_server" "servers"{
    # 2台分
    count = 2
    
    # VIPリソースのID
    load_balancer_vip_id = "${sakuracloud_load_balancer_vip.vip.id}"

    # 実サーバーのIPアドレス
    ipaddress = "${sakuracloud_server.servers.*.ipaddress[count.index]}"

    # 監視設定
    check_protocol = "http"
    check_path = "/"
    check_status = "200"
}

# ロードバランサーのVIP用アウトプット定義
output vip {
    value = "${sakuracloud_load_balancer_vip.vip.vip}"
}
