#!/bin/bash

# Check if a version number was provided
if [ -z "$1" ]; then
    echo "Usage: sphp <version>"
    exit 1
fi

# Get the version number
PHP_VERSION=$1

# Check if the specified version is available
PHP_PATH=$(which php$PHP_VERSION)
if [ -z "$PHP_PATH" ]; then
    echo "PHP version $PHP_VERSION is not installed."
    exit 1
fi

# Update the alternatives to use the specified version
sudo update-alternatives --set php /usr/bin/php$PHP_VERSION
sudo update-alternatives --set phar /usr/bin/phar$PHP_VERSION
sudo update-alternatives --set phar.phar /usr/bin/phar.phar$PHP_VERSION
sudo update-alternatives --set phpize /usr/bin/phpize$PHP_VERSION
sudo update-alternatives --set php-config /usr/bin/php-config$PHP_VERSION

# Disable the current PHP module in Apache
for MOD in $(ls /etc/apache2/mods-enabled/php*.load | sed 's/\.load$//'); do
    sudo a2dismod $(basename $MOD)
done

# Enable the new PHP module in Apache
sudo a2enmod php$PHP_VERSION

# Restart Apache to apply changes
sudo systemctl restart apache2

echo "Switched to PHP version $PHP_VERSION (CLI and Apache)"
