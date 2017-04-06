# Terraform for Sakura Cloud ハンズオン資料

## セットアップ手順

さくらのクラウド上に仮想サーバを作成します。ログイン後、作業用アカウント `terraform` を作成し、 Terraoform が使えるようにセットアップします。必要な設定ファイル等は GitHub から取得します。

### 1. さくらのクラウドでサーバの作成

1. [コントロールパネル](https://secure.sakura.ad.jp/cloud/) にログイン URL: https://secure.sakura.ad.jp/cloud/
2. 【さくらのクラウド(IaaS)】をクリック
3. 画面左上のゾーンを【東京第1ゾーン】に変更
4. 「サーバの」の【追加】をクリック
5. `CentOS 7.3` が選択されたまま画面をスクロール
6. 「管理ユーザのパスワード」で`root`のパスワードを入力（英数記号を使い「パスワード強度が強い」に）
7. 「ホスト名」に【terraform】を入力
8. 【作成】をクリック
9. 確認画面でも【作成】をクリック

### 2. API キーの発行

1. コントロールパネル上側メニューの【設定】をクリック
2. 【APIキー】をクリック
3. 【追加】をクリック
4. 「名前」に【ハンズオン】と入力
5. 【追加】をクリック
6. 確認画面でも【追加】をクリック
7. `ACCESS TOKEN`（アクセス・トークン）と、`ACCESS TOKEN SECRET`（アクセス・トークン・シークレット）の文字列をコピーし、手元のエディタ等に控える

### 3. Terraform 環境のセットアップ

1. サーバに SSH で接続（ログイン用IDは `root` ）
```
$ ssh -l root <IPアドレス>
```
2. 作業用アカウント `terraform` の作成
```
# adduser terraform
```
3. ユーザの切り替え
```
# su - terraform
```
4. ハンズオン環境一式をダウンロード
```
$ git clone https://github.com/zembutsu/sakura-terraform.git
```
5. ディレクトリを移動し、Terraform セットアップ用スクリプトを実行（Terraform 本体と、Terraform for さくらのクラウド・プロバイダをセットアップ）
```
$ cd sakura-terraform
$ sh ./terraform-setup.sh
```
6. Terraform の動作確認（バージョン情報の表示）
```
$ terraform version
Terraform v0.9.2
```

### 4. 環境変数の設定

Terraform を操作する前に、さくらのクラウドの API トークンを環境変数に設定します。
設定対象は以下の３つです。

* `SAKURACLOUD_ACCESS_TOKEN` … アクセス・トークンの文字列
* `SAKURACLOUD_ACCESS_TOKEN_SECRET` … アクセス・トークン・シークレットの文字列
* `SAKURACLOUD_ZONE` … 操作対象のゾーン指定
  * `tk1a` … 東京第1ゾーン
  * `is1a` … 石狩第1ゾーン
  * `is1b` … 石狩第2ゾーン
  * `tk1v` … サンドボックス

コマンドをシェルの履歴に残らないようにするには、次のように実行し、コマンドの前に空白スペースを入れます。
```
HISTCONTROL=ignorespace
```
そして、環境変数を設定します。
```
 export SAKURACLOUD_ACCESS_TOKEN=<文字列>
 export SAKURACLOUD_ACCESS_TOKEN_SECRET=<文字列>
 export SAKURACLOUD_ZONE=tk1a
```

以上で準備は完了です。

## ハンズオンの進め方

数字で始まるディレクトリ内にサンプルの Terraform 用設定ファイル `.tf` があります。
各ディレクトリ内で `terraform plan` → `terraform apply` を実行し、リソースを作成します。

## リソースの削除の仕方

各ディレクトリ内で `terraform destroy` を入力し、確認プロンプトで `yes` を入力します。あとは、Terraform が自動的にリソースを削除します。

## リファレンス

* Terraform
  * https://www.terraform.io/
* Terraform for さくらのクラウド
  * https://github.com/yamamoto-febc/terraform-provider-sakuracloud
* Terraform for さくらのクラウド スタートガイド （第一回） ～インストールから基本操作 ～ - さくらのナレッジ
  * http://knowledge.sakura.ad.jp/knowledge/7230/
* Terraform for さくらのクラウド スタートガイド （第二回） ～便利なビルトイン機能～ - さくらのナレッジ
  * http://knowledge.sakura.ad.jp/knowledge/7550/
* Terraform for さくらのクラウド スタートガイド （第三回）〜さくらのクラウド上にインフラ構築〜 - さくらのナレッジ
  * http://knowledge.sakura.ad.jp/knowledge/7660/
* Terraform for さくらのクラウド スタートガイド （第四回）〜ネットワークの構築〜 - さくらのナレッジ
  * http://knowledge.sakura.ad.jp/knowledge/8248/



