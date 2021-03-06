# ユーザアカウントの作成
## マスター／スレーブの双方にrsyncをするためのユーザアカウント(rsync)を作成する
```
sudo adduser rsync
```
パスワードなど色々聞かれるが入力しない

## sshキーを作成して、双方向にログインできるようにする。

### sshキーを作成する
```
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa.rsync
```
次の２つのファイルが作成されます。
	1) 公開鍵: ~/.ssh/id_rsa.rsync.pub
	2) 秘密鍵: ~/.ssh/id_rsa.rsync

### 公開鍵をログイン先に登録する
ログイン先の`~/.ssh/authorized_keys`にログイン元の公開鍵を追記する

### ログインの試験
ログイン元から接続試験を行う
```
ssh -i ~/.ssh/id_rsa.rsync rsync@xxx.xxx.xxx.xxx
```

### rsyncのユーザアカウントにsudoの後のパスワードを不要にする
```
sudo visudo
=====
# Allow members of group sudo to execute any command
%sudo	ALL=(ALL:ALL) ALL
rsync   ALL=(ALL) NOPASSWD: ALL
=====
```


# master側
##lsyncdのinstall
sudo apt-get install lsyncd


## /etc/lsyncd.confを作成
targetにはIPアドレスをrsync先のIPアドレスを指定する

```
settings {
        logfile    = "/var/log/lsyncd.log",
        statusFile = "/tmp/lsyncd.stat",
        delay        = 1
}
sync{
    default.rsync,
    source="/var/www/html/",
    target="rsync@172.31.19.118:/var/www/html",
    rsync = {
        archive = true,
        rsync_path = "sudo /usr/bin/rsync",
        links = true,
        update = true,
        verbose = false,
          rsh = "/usr/bin/ssh -i /home/rsync/.ssh/id_rsa.rsync -o UserKnownHostsFile=/home/rsync/.ssh/known_hosts"
    }
}
```

## /etc/init.d/lsyncを編集
lsyncd.confのパスが異なっているので修正する


# slave側
## rsyncの設定 /etc/rsync.conf
===============
uid = root
gid = root
read only = no
log file = /var/log/rsyncd.log
pid file = /var/run/rsyncd.pid

[www]
path = /var/www/html/
hosts allow = 172.31.17.120
hosts deny = *
read only = false
exclude = .svn
===============

# AWSの設定
## rsyncに使用するslave側873ポートの開放

# サービスの起動
## ホスト側(lsyncd側)
sudo service lsyncd start
sudo service lsyncd stop
sudo service lsyncd restart

## スレーブ側(rsync側)
sudo service rsync start
sudo service rsync stop
sudo service rsync restart


