#!/bin/bash

## ----------------------------
# ユーザからのキーボードの入力を受け取り、
# yes と入力されたらスクリプトを実行する、no と入力されたらスクリプトを終了します.
## ----------------------------
S10=ubuntu@ec2-52-69-244-75.ap-northeast-1.compute.amazonaws.com
S20=ubuntu@ec2-13-231-71-177.ap-northeast-1.compute.amazonaws.com
S30=ubuntu@ec2-54-199-99-142.ap-northeast-1.compute.amazonaws.com
echo $S10
echo $S20
echo $S30
function ConfirmExecution() {

	echo "----------------------------"
	echo "  接続するAWSのサーバーを選択してください。"
	echo "  [10] www.iot.lapis-semi.com(master) :"$S10
	echo "  [20] api.lazurite.io(master) :       "$S20
	echo "  [30] www.lazurite.io(master) :       "$S30
	echo "  [99] exit"

	read input

	if [ -z $input ] ; then

		echo "  接続するサーバーの番号を入力してください。"
		echo "  接続をするためにはアクセスSSHのキーファイルを~/.sshに保存しておく必要があります。"
		ConfirmExecution

	elif [ $input = '10' ] ; then
		ssh -i ~/.ssh/solutions-op-key-pair.pem $S10
		ConfirmExecution

	elif [ $input = '20' ] ; then
		ssh -i ~/.ssh/solutions-op-key-pair.pem $S20
		ConfirmExecution

	elif [ $input = '30' ] ; then
		ssh -i ~/.ssh/solutions-op-key-pair.pem $S30
		ConfirmExecution

	elif [ $input = '99' ] ; then

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

