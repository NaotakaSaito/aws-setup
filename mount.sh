#!/bin/zsh
sshfs -o IdentityFile=/Users/naotakasaito/.ssh/solutions-op-key-pair.pem ubuntu@ec2-54-199-181-106.ap-northeast-1.compute.amazonaws.com:/var/www/html ~/aws-mount/www
sshfs -o IdentityFile=/Users/naotakasaito/.ssh/solutions-op-key-pair.pem ubuntu@ec2-13-231-71-177.ap-northeast-1.compute.amazonaws.com:/home/ubuntu/release ~/aws-mount/api
sshfs -o IdentityFile=/Users/naotakasaito/.ssh/solutions-op-key-pair.pem :/home/ubuntu ~/aws-mount/vpn


diskutil unmount ~/aws-mount/www
diskutil unmount ~/aws-mount/api
diskutil unmount ~/aws-mount/vpn
