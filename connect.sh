#!/bin/bash

## ----------------------------
# ユーザからのキーボードの入力を受け取り、
# yes と入力されたらスクリプトを実行する、no と入力されたらスクリプトを終了します.
## ----------------------------
S10=ubuntu@ec2-54-199-181-106.ap-northeast-1.compute.amazonaws.com
S20=ubuntu@ec2-54-95-105-22.ap-northeast-1.compute.amazonaws.com
S30=ubuntu@ec2-18-179-196-237.ap-northeast-1.compute.amazonaws.com
S40=ubuntu@ec2-18-183-140-25.ap-northeast-1.compute.amazonaws.com
function ConfirmExecution() {

	echo "----------------------------"
	echo "  接続するAWSのサーバーを選択してください。"
	echo "  [ 10] ssh:   www.iot.lapis-semi.com(master) :"$S10
	echo "  [ 11] sshfs: www.iot.lapis-semi.com(master) :"
	echo "  [ 12] umount:www.iot.lapis-semi.com(master) :"
	echo "  [ 20] ssh:   api.lazurite.io(master) :       "$S20
	echo "  [ 21] sshfs: api.lazurite.io(master) :       "
	echo "  [ 22] umount:api.lazurite.io(master) :       "
	echo "  [ 30] vpn.lazurite.io(master) :              "$S30
	echo "  [ 40] ssh:   www.lio-solution.com(master)    "$S40
	echo "  [0] exit"

	read input

	if [ -z $input ] ; then

		echo "  接続するサーバーの番号を入力してください。"
		echo "  接続をするためにはアクセスSSHのキーファイルを~/.sshに保存しておく必要があります。"
		ConfirmExecution

	elif [ $input = '10' ] ; then
		ssh -i ~/.ssh/solutions-op-key-pair.pem $S10
		ConfirmExecution

	elif [ $input = '11' ] ; then
		sshfs -o IdentityFile=/Users/naotakasaito/.ssh/solutions-op-key-pair.pem ubuntu@ec2-54-199-181-106.ap-northeast-1.compute.amazonaws.com:/var/www/html ~/aws-mount/www
		ConfirmExecution

	elif [ $input = '12' ] ; then
		diskutil unmount ~/aws-mount/www
		ConfirmExecution

	elif [ $input = '20' ] ; then
		ssh -i ~/.ssh/solutions-op-key-pair.pem $S20
		ConfirmExecution

	elif [ $input = '21' ] ; then
		sshfs -o IdentityFile=/Users/naotakasaito/.ssh/solutions-op-key-pair.pem ubuntu@ec2-54-95-105-22.ap-northeast-1.compute.amazonaws.com:/home/ubuntu/release ~/aws-mount/api
		ConfirmExecution

	elif [ $input = '22' ] ; then
		diskutil unmount ~/aws-mount/api
		ConfirmExecution

	elif [ $input = '30' ] ; then
		ssh -i ~/.ssh/solutions-op-key-pair.pem -p 40920 $S30
		ConfirmExecution

	elif [ $input = '40' ] ; then
		ssh -i ~/.ssh/lio-solution.pem $S40
		ConfirmExecution

	elif [ $input = '0' ] ; then

		echo "  スクリプトを終了します."
		exit 1

	else

		echo "  接続するサーバーの番号を入力してください。"
		ConfirmExecution

	fi

}

# シェルスクリプトの実行を継続するか確認します。
ConfirmExecution

echo "----------------------------"
echo "hello world!"

