FROM ubuntu:16.04

MAINTAINER Liho <me@lehungio.com>

#  run sudo in docker ubuntu 16.04
# https://github.com/tianon/docker-brew-ubuntu-core/issues/48#issuecomment-215522746
RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*

# init
RUN apt-get update \
    && apt-get install -y git wget curl vim iputils-ping mysql-client python make g++

# nginx
RUN apt-get install -y nginx
COPY conf/nginx.conf /etc/nginx/nginx.conf
RUN mkdir -p /etc/nginx/sites-enabled
COPY conf/liho /etc/nginx/sites-enabled/

# php
# RUN apt-get install -y php7.1-cli php7.1-fpm php7.1-cgi php7.1-mbstring php7.1-xml php7.1-mysql
RUN apt-get install -y php-cli php-fpm php-cgi php-mbstring php-xml php-mysql
RUN apt-get install -y libapache2-mod-php

# composer
RUN curl -o composer -L https://getcomposer.org/composer.phar \
    && chmod +x composer \
    && mv composer /usr/local/bin/

# phpunit
RUN curl -o phpunit -L https://phar.phpunit.de/phpunit-6.1.phar \
    && chmod +x phpunit \
    && mv phpunit /usr/local/bin/

# start service
RUN service php7.0-fpm start
# RUN service nginx start

# init configuration
COPY conf/.bashrc /root
COPY conf/environment /etc/environment
COPY conf/ntp.conf /etc

# env
RUN . $HOME/.bashrc

EXPOSE 80
EXPOSE 8000
EXPOSE 9000

# get server started
# CMD ["nginx", "-g", "daemon off;"]
CMD php -S 0.0.0.0:8000
