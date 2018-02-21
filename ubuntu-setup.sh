sudo apt-get update
sudo apt-get upgrade

# setup 
sudo apt-get install -y vim
sudo apt-get install -y build-essential
sudo apt-get install sqlite3
# installing node.js ver6.x
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo apt-get install -y npm node-gyp

#install for S3
sudo apt-get install automake autotools-dev g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config

#setup vim
cp .vimrc ~/
sudo npm i -g eslint



