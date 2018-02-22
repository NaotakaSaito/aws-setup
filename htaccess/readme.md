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


