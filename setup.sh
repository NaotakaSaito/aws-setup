sudo yum install -y vim
sudo yum install -y httpd
sudo service httpd start
cd ~
git clone https://github.com/creationix/nvm.git ~/.nvm
cp .bash_profile ~/
source ~/.bash_profile

nvm install v6.1
nvm use v6.1
