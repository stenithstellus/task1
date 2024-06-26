FROM ubuntu


RUN apt-get update && \
    DEBIAN_FRONTEND="noninteractive" apt-get install -y mysql-server mysql-client && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


EXPOSE 3306


CMD ["mysqld", "--datadir=/var/lib/mysql", "--user=mysql", "--port=3306", "--bind-address=0.0.0.0", "--default-authentication-plugin=mysql_native_password", "--character-set-server=utf8mb4", "--collation-server=utf8mb4_unicode_ci"]


RUN service mysql start && \
    sleep 5 && \
    mysql -u root -e "CREATE DATABASE smart;" && \
    mysql -u root -e "CREATE USER 'so_user'@'localhost' IDENTIFIED BY 'gearup@123';" && \
    mysql -u root -e "ALTER USER 'so_user'@'localhost' IDENTIFIED WITH mysql_native_password BY 'gearup@123';" && \
    mysql -u root -e "GRANT ALL PRIVILEGES ON *.* TO 'so_user'@'localhost';" && \
    mysql -u root -e "UPDATE mysql.user SET Host='172.17.0.1' WHERE Host='localhost' AND User='so_user';" && \
    mysql -u root -e "FLUSH PRIVILEGES;"
