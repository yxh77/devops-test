#!/bin/bash
set -e

# 启动 MariaDB 服务
mysqld_safe --skip-networking &

# 等待 MariaDB 完全启动
until mysqladmin ping &>/dev/null; do
  echo -n "."; sleep 1
done

# 初始化数据库和用户
mysql -e "CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};"
mysql -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';"
mysql -e "FLUSH PRIVILEGES;"

# 关闭 MariaDB 服务
mysqladmin shutdown

# 重新启动 MariaDB 服务并保持前台运行
exec mysqld_safe
