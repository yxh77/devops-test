# 使用基础镜像
FROM debian:latest

# 设置维护者信息
LABEL maintainer="yourname@example.com"

# 更新包列表并安装所需的软件包
RUN apt-get update && apt-get install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget \
    && apt-get clean

# 添加 PHP 源
RUN wget -q https://packages.sury.org/php/apt.gpg -O /usr/share/keyrings/php-archive-keyring.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/php-archive-keyring.gpg] https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list

# 更新包列表并安装所需的 PHP 版本和 Apache
RUN apt-get update && apt-get install -y \
    apache2 \
    php7.4 \
    php7.4-cli \
    php7.4-mysql \
    php8.0 \
    php8.0-cli \
    php8.0-mysql \
    libapache2-mod-php7.4 \
    libapache2-mod-php8.0 \
    openssh-server \
    && apt-get clean

# 启用 PHP 模块
RUN a2enmod php7.4 && a2enmod php8.0

# 创建切换 PHP 版本的脚本
COPY switch-php-version.sh /usr/local/bin/switch-php-version.sh
RUN chmod +x /usr/local/bin/switch-php-version.sh
CMD ["switch-php-version.sh"]

# 确保目录权限正确
RUN chown -R www-data:www-data /var/www/html \
    && echo "<?php phpinfo(); ?>" > /var/www/html/index.php \
# 添加Apache配置以确保PHP文件被正确解析
    && echo "<IfModule mod_dir.c>\n    DirectoryIndex index.php index.html\n</IfModule>" > /etc/apache2/mods-enabled/dir.conf

# 创建必要的目录
RUN mkdir /var/run/sshd \
    # 设置 root 密码
    && echo 'root:rootpassword' | chpasswd \
    # 允许 root 登录 SSH
    && sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

    
# 暴露80端口
EXPOSE 80 22

# 默认开启 Apache 服务
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]