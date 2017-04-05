#!/bin/sh
#
# @sacloud-once

# httpdのインストール
yum install -y httpd || exit 1

# 確認用ページ
hostname >> /var/www/html/index.html || exit1

# サービス起動設定
systemctl enable httpd.service || exit 1
systemctl start httpd.service || exit 1

# ファイアウォール設定
firewall-cmd --add-service=http --zone=public --permanent || exit 1
firewall-cmd --reload || exit 1

exit 0
