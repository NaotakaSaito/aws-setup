#!/bin/bash
SCRIPT_DIR=$(cd $(dirname $(readlink -f $0 || echo $0));pwd -P)

sudo mkdir /tmp/ssm
sudo curl https://s3-ap-northeast-1.amazonaws.com/amazon-ssm-ap-northeast-1/latest/debian_amd64/amazon-ssm-agent.deb -o /tmp/ssm/amazon-ssm-agent.deb
sudo apt -y install /tmp/ssm/amazon-ssm-agent.deb

# check amazon-ssm-agent
#sudo systemctl status amazon-ssm-agent






