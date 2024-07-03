#!/bin/bash

# 默认PHP版本
PHP_VERSION=${1:-7.4}

# 禁用所有PHP版本模块
a2dismod php7.4
a2dismod php8.0

# 启用指定的PHP版本模块
if [ "$PHP_VERSION" = "7.4" ]; then
    a2enmod php7.4
elif [ "$PHP_VERSION" = "8.0" ]; then
    a2enmod php8.0
else
    echo "Unsupported PHP version: $PHP_VERSION"
    exit 1
fi

# 重启Apache服务
service apache2 restart

echo "Switched to PHP $PHP_VERSION"
