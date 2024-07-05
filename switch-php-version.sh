#!/bin/bash

# 默认PHP版本
PHP_VERSION=${1:-7.4}

# 禁用所有PHP版本模块
a2dismod php7.4
a2dismod php8.0

# 启用指定的PHP版本模块并修改Apache配置文件
if [ "$PHP_VERSION" = "7.4" ]; then
    a2enmod php7.4
    sed -i 's/^LoadModule php8_module/;LoadModule php8_module/' /etc/apache2/mods-available/php7.4.conf
    sed -i 's/^;LoadModule php7_module/LoadModule php7_module/' /etc/apache2/mods-available/php7.4.conf
elif [ "$PHP_VERSION" = "8.0" ]; then
    a2enmod php8.0
    sed -i 's/^LoadModule php7_module/;LoadModule php7_module/' /etc/apache2/mods-available/php8.0.conf
    sed -i 's/^;LoadModule php8_module/LoadModule php8_module/' /etc/apache2/mods-available/php8.0.conf
else
    echo "Unsupported PHP version: $PHP_VERSION"
    exit 1
fi

# 重启Apache服务
service apache2 restart

echo "Switched to PHP $PHP_VERSION"

# 使用示例
## ./switch-php-version.sh [$PHP_VERSION]