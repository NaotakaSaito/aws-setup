# scriptについて
## publish_test_server.rb
config.jsonに記載されている設定に従って、HTMLファイルをサーバーにuploadします。
本ソフトウエアを動作させるためには、"yuicompressor-2.4.8.jar"とJAVAの動作環境が必要です。
###機能
ローカルPCのHTMLファイルをAWSのサーバーにpublishします。
1) "projectPath.src"で指定したフォルダを"release__日付___時間"のフォルダの下に"src/projectPath.dst", "release/projectPath.dst"のフォルダにコピーします。
2) "release/projectPath.dst"の方のみ、targetJSで指定したjavascriptファイルを"yuicompressor-2.4.8.jar"を使用して圧縮します。
圧縮後は、元のファイルを削除します。
3) "targetHTML"のファイルの内部をサーチして、javascriptのファイル名をxxx.min.jsに置き換えます。
4) "release___日付___時間"フォルダをzip圧縮します。
5) zip圧縮したファイルをtargetInstanceに送信します。
6) AWS-CLIを使用して、targetInstance内のhtml___deploy.rbを実行して、ファイルの中身を"/var/www/html"にdeployします。

###使用方法
■環境設定
・本ファイルを実行するパスに、xxxx.pemファイルが必要です。
・AWS側にhtml_deploy.rbのスクリプトファイルが必要になります。

■config.jsonについて
projectPath.src:: プロジェクトのソースパスを指定します。
projectPath.dst:: プロジェクトの出力パスを指定します。
targetJS::  圧縮するjavascriptを指定します。コピー後に圧縮するので、projectPath.dstのフォルダで指定します。
targetHTML:: javascriptファイルのファイル名がxxxx.min.jsに変わります。ファイル名を置き換えるHTMLファイルを指定します。
targetInstancePath:: AWS側のファイルパスを指定します。
targetInstance.dns:: instanceのDNSを指定します。
targetInstance.id::  EC2のIDを指定します。

```
{
	"root": "/var/www/html",
	"projectPath": [
		{
			"src": "/var/www/html/factory-iot2",
			"dst": "factory-iot"
		},
		{
			"src": "/var/www/html/lib",
			"dst": "lib"
		}
	],
	"targetJS":[
		"factory-iot/dashboard/index.js",
		"lib/common.js"
	],
	"targetHTML": [
		"factory-iot/userConfig/index.html"
	],
	"targetInstancePath": "/home/ubuntu/backup/",
	"targetInstance": [
		{
			"dns": "ubuntu@ec2-54-199-99-142.ap-northeast-1.compute.amazonaws.com",
			"id":  "i-036e23bbb3783b4bf"
		}
	]
}
```

## delete__backup.rbについて
release_xxxx_xxxxのフォルダとzipファイルをクリーンナップします。

