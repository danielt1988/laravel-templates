FROM alpine:3.15

LABEL maintainer=dantuka01@gmail.com

ENV TZ=America/Los_Angeles \
    APACHE_LOG_DIR=/var/log/apache2

# Installing Essential Binaries
RUN apk add --no-cache \
    composer \
    supervisor \
    curl \
    bash \
    tzdata \
    npm \
    apache2 && \
    sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd && \
    mkdir -p /etc/supervisor.d/ && \
    adduser -D -H -u 1000 -s /bin/bash www-data -G www-data && \
    apk add --no-cache \
    php8 \
    php8-apache2 \
    php8-bcmath \
    php8-cli \
    php8-curl \
    php8-ctype \
    php8-common \
    php8-dom \
    php8-fileinfo \
    php8-pdo \
    php8-opcache \
    php8-zip \
    php8-phar \
    php8-iconv \
    php8-openssl \
    php8-mbstring \
    php8-tokenizer \
    php8-fileinfo \
    php8-json \
    php8-xml \
    php8-xmlwriter \
    php8-simplexml \
    php8-pdo \
    php8-pdo_pgsql \
    php8-pdo_mysql \
    php8-pdo_sqlite \
    php8-tokenizer \
    php8-pecl-redis && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log 

COPY laravel /var/www/localhost/htdocs/
COPY /config/server/supervisord.ini /etc/supervisor.d/supervisord.ini
COPY /config/server/httpd.conf /etc/apache2/httpd.conf

RUN cd /var/www/localhost/htdocs/ && composer install --no-dev && \
    touch /var/www/localhost/htdocs/storage/logs/laravel.log && \
    mkdir -p /var/www/localhost/htdocs/storage/bootstrap/cache && \
    chmod -R 777 /var/www/localhost/htdocs/storage/bootstrap/cache && \
    chown -R apache:apache /var/www/localhost/htdocs && \
    npm install && \
    npm run production && \
    rm /var/www/localhost/htdocs/index.html && \
    httpd -k stop && \
    mv /usr/bin/php8 /usr/bin/php


WORKDIR /var/www/localhost/htdocs/

EXPOSE 80
CMD [ "supervisord","-n" ]
