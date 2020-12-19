FROM php:7.2-apache
MAINTAINER ex0nuss

RUN apt-get -y update && \
    apt install -y --no-install-recommends \
    iputils-ping \
    wakeonlan \
    git
#RUN docker-php-ext-install curl

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN chmod u+s `which ping`
RUN git clone https://github.com/sciguy14/Remote-Wake-Sleep-On-LAN-Server.git

WORKDIR /var/www/html

RUN a2enmod headers &&\
    service apache2 restart

RUN mv -f Remote-Wake-Sleep-On-LAN-Server/000-default.conf /etc/apache2/sites-available/000-default.conf
COPY ports.conf /etc/apache2/

RUN sed -i.bak "s/expose_php = On/expose_php = Off/g" $PHP_INI_DIR/php.ini &&\
    sed -i.bak "s/E_ALL & ~E_NOTICE & ~E_STRICT & ~E_DEPRECATED/error_reporting = E_ERROR/g" $PHP_INI_DIR/php.ini &&\
    sed -i.bak "s/ServerSignature On/ServerSignature Off/g" /etc/apache2/conf-available/security.conf &&\
    sed -i.bak "s/ServerTokens OS/ServerTokens Prod/g" /etc/apache2/conf-available/security.conf &&\
    service apache2 restart

RUN mv Remote-Wake-Sleep-On-LAN-Server/* /var/www/html &&\
    mv Remote-Wake-Sleep-On-LAN-Server/.htaccess /var/www/html &&\
    rm -rf Remote-Wake-Sleep-On-LAN-Server/ &&\
    rm -f /var/www/html/index.html
#    mv /var/www/html/config_sample.php /var/www/html/config.php

COPY config.php /var/www/html/config.php
COPY entrypoint.sh /

ENV APACHE2_PORT=80
ENV PASSPHRASE=
ENV RWSOLS_MAX_PINGS=15
ENV RWSOL_SLEEP_TIME=5
ENV RWSOLS_COMPUTER_NAME=
ENV RWSOLS_COMPUTER_MAC=
ENV RWSOLS_COMPUTER_IP=

ENTRYPOINT ["/entrypoint.sh"]
