#!/bin/bash
# Update system
yum update -y

# Enable Amazon Linux Extras for PHP and install Apache + PHP
amazon-linux-extras enable php8.0
yum install -y php php-cli httpd

# Create a simple PHP app
echo "<?php phpinfo(); ?>" > /var/www/html/index.php
echo "<?php echo '<h1>Welcome to Terraform PHP App on Amazon Linux 2!</h1>'; ?>" > /var/www/html/app.php

# Start Apache
systemctl enable httpd
systemctl start httpd
EOF