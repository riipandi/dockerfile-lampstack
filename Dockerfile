# LAMP Stack
# VERSION 0.1

FROM debian:buster
LABEL maintainer "ripandi@protonmail.com" description "Linux Web Development stack with Apache, PHP7, and MariaDB"

# disable interactive functions
ENV DEBIAN_FRONTEND noninteractive

# Get some security updates
RUN apt update
RUN apt full-upgrade -y

# Unatended MariaDB Installation
RUN echo "mysql-server mysql-server/root_password password toor"           | debconf-set-selections
RUN echo "mysql-server mysql-server/root_password_again password toor"     | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/dbconfig-install boolean false"            | debconf-set-selections
RUN echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections

# Install required packages
RUN apt install -y mariadb-server mariadb-client libmariadb-dev libmariadbclient-dev
RUN apt install -y php-common php-cgi php-gd php-cli php-sqlite3 php-mysql php-bcmath
RUN apt install -y php-curl php-zip php-gettext php-xml php-xmlrpc php-mbstring php-json 
RUN apt install -y php-intl php-readline php-gmp php-opcache gamin composer 
RUN apt install -y apache2 libapache2-mod-php jq phpmyadmin mcrypt
RUN a2enmod rewrite && phpenmod opcache
RUN rm -rf /var/lib/apt/lists/*

# Configure the packages
RUN mysql -uroot -e "UPDATE mysql.user SET plugin='', Password=PASSWORD('toor') WHERE User='root';"
RUN sed -i 's/AllowOverride None/AllowOverride All/'       /etc/apache2/apache2.conf
RUN sed -i 's/Alias \/phpmyadmin/Alias \/myadmin/'       /etc/phpmyadmin/apache.conf
RUN echo "<?php phpinfo();?>" > /var/www/html/index.php

# Add our config files
# ADD conf/php.ini /etc/php5/fpm/php.ini
ADD build/setup.sh /home/setup.sh
RUN chmod +x /home/setup.sh

# Define mountable directories.
VOLUME ["/etc/apache2/sites-enabled", "/etc/apache2/sites-available", "/var/log/apache2", "/var/www/html"]
VOLUME ["/var/lib/mysql"]
WORKDIR /var/lib/mysql

# expose http & https
EXPOSE 80
EXPOSE 443
EXPOSE 3306

# CMD ["/usr/bin/supervisord"]
CMD ["/home/setup.sh"]

# Build with command:
# sudo docker build -t riespandi/lampstack ./dockerfile-lampstack