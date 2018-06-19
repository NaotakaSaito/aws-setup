# ロードバランサーを経由したhttpリクエストをhttpsにリダイレクトする方法
## /etc/apache2/apache2.conf
次のように変更をする

<Directory />
	AllowOverride All
</Directory>

<Directory /usr/share>
	AllowOverride None
	Require all granted
</Directory>

<Directory /var/www/>
	AllowOverride All
</Directory>


## /var/www/html
.htaccessを作成して次のデータを書き込む

RewriteEngine On 
RewriteCond %{HTTP:X-Forwarded-Proto} !https
RewriteRule ^(.*)?$ https://%{HTTP:Host}%{REQUEST_URI} [L,R=301]



## 正しくリダイレクトできない時
### Logの確認をする
cat /var/log/apache2/error.log
->
[Wed Jun 13 11:55:34.475728 2018] [core:alert] [pid 22553:tid 140390764865280] [client 172.31.15.178:55934] /var/www/html/.htaccess: Invalid command 'RewriteEngine', perhaps misspelled or defined by a module not included in the server configuration


###  Rewriteエンジンが利用できることを確認する
cat /etc/apache2/mods-available/rewrite.load
--> LoadModule rewrite_module /usr/lib/apache2/modules/mod_rewrite.so

### Rewriteエンジンを有効にする
sudo a2enmod rewrite

### Apache2サーバーの再起動
sudo apache2ctl restart

