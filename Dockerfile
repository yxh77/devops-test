# 使用基础镜像
FROM debian:latest

# 设置维护者信息
LABEL maintainer="yourname@example.com"

# 更新包列表并安装所需的软件包
RUN apt-get update && apt-get install -y \
    lsb-release \
    apt-transport-https \
    ca-certificates \
    wget

# 添加PHP源
RUN wget -q https://packages.sury.org/php/apt.gpg -O- | apt-key add - \
    && echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/php.list

# 更新包列表并安装所需的软件包
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
    && apt-get clean

# 创建切换PHP版本的脚本
COPY switch-php-version.sh /usr/local/bin/switch-php-version.sh
RUN chmod +x /usr/local/bin/switch-php-version.sh

# 默认开启Apache服务
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
