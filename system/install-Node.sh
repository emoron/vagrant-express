#!/usr/bin/bash
cd /tmp
wget https://nodejs.org/dist/v6.10.3/node-v6.10.3-linux-x64.tar.xz
mkdir node
tar xvf node-v*.tar.?z --strip-components=1 -C ./node
mkdir node/etc
echo 'prefix=/usr/local' > node/etc/npmrc
sudo mv node /opt/
sudo chown -R root: /opt/node
sudo ln -s /opt/node/bin/node /usr/local/bin/node
sudo ln -s /opt/node/bin/npm /usr/local/bin/npm
sudo npm install pm2 nodemon -g
