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
RUN apt install -y php7.2-common php7.2-cgi php7.2-gd php7.2-cli php7.2-sqlite3 php7.2-mysql php7.2-bcmath
RUN apt install -y php7.2-curl php7.2-zip php7.2-gettext php7.2-xml php7.2-xmlrpc php7.2-mbstring php7.2-json 
RUN apt install -y php7.2-intl php7.2-readline php7.2-gmp php7.2-opcache gamin composer 
RUN apt install -y apache2 libapache2-mod-php jq phpmyadmin mcrypt
RUN a2enmod rewrite && phpenmod opcache
RUN rm -fr /var/lib/apt/lists/*

# Configure the packages
#RUN mysql -uroot -e "UPDATE mysql.user SET plugin='', Password=PASSWORD('toor') WHERE User='root';"
RUN sed -i 's/AllowOverride None/AllowOverride All/'       /etc/apache2/apache2.conf
RUN sed -i 's/Alias \/phpmyadmin/Alias \/myadmin/'       /etc/phpmyadmin/apache.conf
RUN echo "<?php phpinfo() ?>" > /var/www/html/index.php

# Add our config files
# ADD conf/php.ini /etc/php5/fpm/php.ini
# ADD build/setup.sh /home/setup.sh
# RUN chmod +x /home/setup.sh

# Define mountable directories.
#VOLUME ["/etc/apache2/sites-enabled", "/etc/apache2/sites-available", "/var/log/apache2", "/home/www"]
VOLUME ["/var/lib/mysql"]
WORKDIR /var/lib/mysql

# expose http & https
EXPOSE 80
EXPOSE 3306

# CMD ["/usr/bin/supervisord"]
# CMD ["/home/setup.sh"]

# Build with command:
# sudo docker login --username=riespandi
# sudo docker build -t riespandi/lampstack ./dockerfile-lampstack
# sudo docker images
# sudo docker tag 232874818a44 riespandi/lampstack:firsttry
# sudo docker push riespandi/lampstack
# sudo docker save lampstack > lampstack.tar
# sudo docker load --input lampstack.tar

# Run the container
# sudo docker run -d -p 0.0.0.0:8080:80 --name lampstack riespandi/lampstack
# mkdir -p /home/mysql-data
# mkdir -p /home/nginx-sites/{logs,sites-available,sites-enabled}
# sudo docker run -d -p 0.0.0.0:80:80 -v /home/mysql-data/:/var/lib/mysql \
#   -v /home/nginx-sites/sites-enabled/:/etc/nginx/sites-enabled \
#   -v /home/nginx-sites/sites-available/:/etc/nginx/sites-available \
#   -v /home/nginx-sites/logs/:/var/log/nginx \
#   -v /home/www/:/home/www \
#   riespandi/lampstack
#   --name lampstack
# sudo docker logs -f lampstack
# sudo docker inspect lampstack
# sudo docker stop lampstack