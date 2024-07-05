# 使用基础镜像
FROM debian:latest

# 更新包列表并安装 MariaDB
RUN apt-get update && apt-get install -y mariadb-server

# 复制初始化脚本到容器中
COPY mysqlinit.sh /usr/local/bin/

# 修改 MariaDB 配置，允许外部连接
RUN sed -i 's/bind-address.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

# 暴露 MariaDB 端口
EXPOSE 3306

RUN chmod +x /usr/local/bin/mysqlinit.sh
# 启动 MariaDB 服务并初始化数据库
CMD ["mysqlinit.sh"]
