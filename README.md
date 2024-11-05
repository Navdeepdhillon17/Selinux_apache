# Selinux_apache
Securing apache with selinux on red hat linux 9.4
# Securing Apache with SELinux on Red Hat Linux 9.4

This project demonstrates how to configure Apache to serve files from a custom directory using SELinux on Red Hat Linux 9.4. It includes steps to install Apache, configure SELinux permissions, and set up firewall rules to allow web traffic.

## Prerequisites

- Red Hat Linux 9.4
- Basic knowledge of SELinux and Apache configuration

## Installation and Configuration

1. **Install Apache:**
    ```bash
    sudo dnf install httpd
    ```

2. **Start and Enable Apache to Run on Boot:**
    ```
    sudo systemctl start httpd
    sudo systemctl enable httpd
    ```

3. **Check Apache Status:**
    ```
    sudo systemctl status httpd
    ```

4. **Get the IP Address of the VM:**
    ```
    ip a
    ```

5. **Set up the Default Document Root:**
    - Place an HTML file in `/var/www/html`, for example:
    ```bash
    echo "<h1>Hello, world from Apache</h1>" | sudo tee /var/www/html/index.html
    ```

6. **Modify Apache Configuration to Serve Files from a Custom Directory:**
    - Edit the Apache configuration file to set a new document root.
    ```
    sudo nano /etc/httpd/conf/httpd.conf
    ```
    - Change `DocumentRoot` to your custom directory (e.g., `/mycustomweb`).

7. **Restart Apache to Apply Changes:**
    ```
    sudo systemctl restart httpd
    ```

## Configuring SELinux

1. **Enable Apache Access to Custom Directories:**
    ```
    sudo setsebool -P httpd_enable_homedirs 1
    ```

2. **Label the Custom Directory for Apache Access:**
    ```
    sudo semanage fcontext -a -t httpd_sys_content_t "/mycustomweb(/.*)?"
    ```

3. **Apply the SELinux Context Recursively:**
    ```bash
    sudo restorecon -Rv /mycustomweb
    ```

4. **Set Directory Permissions and Ownership:**
    ```
    sudo chmod -R 755 /mycustomweb
    sudo chown -R apache:apache /mycustomweb
    ```

## Verifying the Setup

- Check the SELinux context of the directory:
    ```
    ls -Z /mycustomweb
    ```
- Test the configuration by accessing `http://<ip_address>` in a browser or using `curl`:
    ```
    curl http://<ip_address>
    ```

## Notes

- Check the IP address each time as it may change.
- Ensure firewall settings allow HTTP and HTTPS services to enable web traffic.

## Troubleshooting

If you encounter issues:
- Verify Apache is running.
- Check SELinux settings and file permissions.
- Confirm that HTTP/HTTPS services are allowed through the firewall:
    ```bash
    sudo firewall-cmd --permanent --add-service=http
    sudo firewall-cmd --permanent --add-service=https
    sudo firewall-cmd --reload
    ```


