# AWS CLI経由で動作をさせるための設定
sudo mkdir /tmp/ssm
sudo curl https://s3-ap-northeast-1.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb -o /tmp/ssm/amazon-ssm-agent.deb
sudo apt -y install /tmp/ssm/amazon-ssm-agent.deb

# check amazon-ssm-agent
#sudo systemctl status amazon-ssm-agent

