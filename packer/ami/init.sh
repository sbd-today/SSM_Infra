# Install and configure unattended-upgrades for automatic security updates
apt install unattended-upgrades -y
sudo su
cat <<EOF | sudo tee  /etc/apt/apt.conf.d/20auto-upgrades
APT::Periodic::Update-Package-Lists "1";
APT::Periodic::Unattended-Upgrade "1";
EOF

# Secure shared memory
echo "tmpfs /run/shm tmpfs defaults,noexec,nosuid 0 0" | sudo tee -a /etc/fstab

# Set proper permissions on sensitive files
sudo chmod 600 /etc/shadow
sudo chmod 644 /etc/passwd
sudo chmod 600 /etc/sudoers


echo "configure session manager"

### -------- AWS Session Manager
sudo useradd --user-group ssm-user
echo "ssm-user ALL=(ALL) NOPASSWD:ALL" | sudo tee -a /etc/sudoers.d/ssm-user

# disable ufw in favour of security groups
sudo ufw disable

# enable ssm agent
sudo snap restart amazon-ssm-agent
echo "done."


sudo apt install auditd -y
 
echo "setup auditd custom rules"

cat /tmp/custom.rules  | sudo tee /etc/audit/rules.d/custom.rules

echo "setup logrorate for auditd"

cat /tmp/logrotate.conf  | sudo tee /etc/logrotate.d/auditd

sudo service auditd restart
------ Lock root account

#configure cloudwatch agent

echo "installing cloudwatch agent"
sudo wget https://s3.amazonaws.com/amazoncloudwatch-agent/debian/amd64/latest/amazon-cloudwatch-agent.deb
echo "current working path"
sudo dpkg -i -E ./amazon-cloudwatch-agent.deb
cat /tmp/audited.conf  | sudo tee /etc/logrotate.d/auditd

cat /tmp/cloudwatch-config.json | sudo tee /opt/aws/amazon-cloudwatch-agent/bin/config.json

echo "lock root account"
sudo passwd -l root
echo "done."

# insall AWS Cli
sudo apt install unzip -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
exit 0