#!/bin/bash

sudo apt update
if [ $? -eq 0 ]; then
    echo "[LOG] apt update successful"
else
    echo "[LOG] apt update failed"
fi
echo "[LOG] install necessary packages"
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
sudo apt-get install -y nodejs

if [ $? -eq 0 ]; then
    echo "[LOG] Installing node 20.x successful"
else
    echo "[LOG] Installing node 20.x failed. retrying"
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\
    sudo apt-get install -y nodejs
    if [ $? -eq 0 ]; then
      echo "[LOG] Installing node 20.x successful on retry"
    else
      echo "[LOG] Installing node 20.x failed. Will not retry"
    fi
fi

sudo apt install npm -y
if [ $? -eq 0 ]; then
    echo "[LOG] installing of npm is successful"
else
    echo "[LOG] installing of npm is failed"
fi
sudo npm install pm2 vite nodemon cross-env express -g 
# sudo apt install npm -y
if [ $? -eq 0 ]; then
    echo "[LOG] installing of pm2 and other packages is successful"
else
    echo "[LOG] installing of pm2 and other packages failed"
fi
echo "done."

sudo apt-get install -y nginx
if [ $? -eq 0 ]; then
    echo "[LOG] installing of nginx is successful"
else
    echo "[LOG] installing of nginx is failed"
fi

echo "copy files"
cat /tmp/usr.sbin.nginx | sudo tee /etc/audit/rules.d/custom.rules

sudo apt-get install apparmor-utils -y
if [ $? -eq 0 ]; then
    echo "[LOG] installing of apparmor is successful"
else
    echo "[LOG] installing of apparmor is failed"
fi
# Reload AppArmor profiles
sudo apparmor_parser -r /etc/apparmor.d/usr.sbin.nginx

EOF

sudo aa-enforce nginx
sudo service nginx restart 

sudo mkdir -p  /ebs

echo "Check for volume attachment"
if [ ! -z "$(sudo file -s /dev/xvdf | grep 'ext4')" ]; then
  echo "[LOG] Volume is already formatted with ext4."
else
  echo "[LOG] Formatting the volume with ext4 filesystem..."
  sudo mkfs.ext4 /dev/xvdf
fi
mkdir -p /ebs
sudo mount /dev/xvdf /ebs
if [ $? -eq 0 ]; then
    echo "[LOG] mounting /ebs is successful"
    sudo chown ubuntu:ubuntu /ebs
    echo "[LOG] ownership change of /ebs is done"
else
    echo "[LOG] mounting /ebs failed"
fi
echo "/dev/xvdf /ebs ext4 defaults,nofail 0 2" | sudo tee -a /etc/fstab
sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json
