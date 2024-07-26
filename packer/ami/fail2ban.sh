
#install fall2ban to protect SSH login 

sudo apt install fail2ban -y

# Create a custom fail2ban configuration for SSH
sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local

# Configure fail2ban jail.local
sudo tee -a /etc/fail2ban/jail.local > /dev/null <<EOT

[sshd]
enabled = true
port = ssh,2222
filter = sshd
logpath = /var/log/auth.log
findtime = 10m
maxretry = 5
bantime = 10m
EOT

# Restart fail2ban
sudo systemctl resta