# 使用基础镜像
FROM debian:latest

# 更新包列表并安装 MySQL
RUN apt-get update && apt-get install -y mysql-server

# 初始化 MySQL 数据库
RUN service mysql start && \
    mysql -e "CREATE DATABASE mydatabase;" && \
    mysql -e "CREATE USER 'myuser'@'%' IDENTIFIED BY 'mypassword';" && \
    mysql -e "GRANT ALL PRIVILEGES ON mydatabase.* TO 'myuser'@'%';" && \
    mysql -e "FLUSH PRIVILEGES;"

# 修改 MySQL 配置，允许外部连接
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mysql.conf.d/mysqld.cnf

# 暴露 MySQL 端口
EXPOSE 3306

# 启动 MySQL 服务
CMD ["mysqld"]
