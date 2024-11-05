#!/bin/bash

# Install Apache
sudo dnf install httpd -y

# Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Get the IP address
echo "Your IP address is:"
ip a

# Create a custom directory
sudo mkdir /mycustomweb

# Add HTML content to custom directory
echo "<h1>Hello, world from Apache</h1>" | sudo tee /mycustomweb/index.html

# Update Apache's DocumentRoot
sudo sed -i 's|DocumentRoot "/var/www/html"|DocumentRoot "/mycustomweb"|' /etc/httpd/conf/httpd.conf
sudo sed -i 's|<Directory "/var/www">|<Directory "/mycustomweb">|' /etc/httpd/conf/httpd.conf

# Restart Apache to apply changes
sudo systemctl restart httpd

# Enable SELinux for custom directory access
sudo setsebool -P httpd_enable_homedirs 1

# Label the custom directory for Apache access
sudo semanage fcontext -a -t httpd_sys_content_t "/mycustomweb(/.*)?"
sudo restorecon -Rv /mycustomweb

# Set permissions for the directory
sudo chmod -R 755 /mycustomweb
sudo chown -R apache:apache /mycustomweb

echo "Setup complete. You can access the web page at http://<your_ip_address>"
