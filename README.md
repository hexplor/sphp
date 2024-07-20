# PHP Version Switcher Script

A simple bash script to switch between different PHP versions on an Ubuntu system. This script updates the CLI PHP version and also switches the PHP module used by Apache.

## Prerequisites

Ensure that you have multiple PHP versions installed on your system. You can install them using the following commands:

```bash
sudo apt install php7.4 php8.0
```

Also, you need to configure `update-alternatives` for the PHP versions you have installed:

```bash
sudo update-alternatives --install /usr/bin/php php /usr/bin/php7.4 74
sudo update-alternatives --install /usr/bin/php php /usr/bin/php8.0 80
```

## Installation

1. Clone the repository or download the `sphp` script.

2. Place the `sphp` script in a directory that's in your `PATH`, such as `/usr/local/bin/`:

    ```bash
    sudo mv sphp /usr/local/bin/
    sudo chmod +x /usr/local/bin/sphp
    ```

## Usage

To switch to a different PHP version, run the script followed by the version number. For example, to switch to PHP 7.4, use:

```bash
sphp 7.4
```

To switch to PHP 8.0, use:

```bash
sphp 8.0
```

The script performs the following actions:
1. Updates the `update-alternatives` settings to point to the specified PHP version for CLI usage.
2. Disables the currently enabled PHP module in Apache.
3. Enables the specified PHP version module in Apache.
4. Restarts Apache to apply the changes.

## Script Content

Here is the content of the `sphp` script:

```bash
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
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contributing

Feel free to submit pull requests or open issues for any improvements or bug fixes.

## Acknowledgements

Inspired by the need to easily switch PHP versions on development and production servers.