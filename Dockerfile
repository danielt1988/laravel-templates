FROM alpine:3.13

LABEL maintainer=dantuka01@gmail.com

ENV TZ=America/Los_Angeles \
    APACHE_LOG_DIR=/var/log/apache2

# Installing Essentials, PHP, and PHP-Extensions
RUN apk add --no-cache \
    composer \
    supervisor \
    curl \
    bash \
    tzdata \
    apache2 && \
    sed -i 's/bin\/ash/bin\/bash/g' /etc/passwd && \
    mkdir -p /etc/supervisor.d/ && \
    adduser -D -H -u 1000 -s /bin/bash www-data -G www-data && \
    apk add --no-cache \
    php7 \
    php7-apache2 \
    php7-bcmath \
    php7-cli \
    php7-curl \
    php7-ctype \
    php7-common \
    php7-dom \
    php7-fileinfo \
    php7-pdo \
    php7-opcache \
    php7-zip \
    php7-phar \
    php7-iconv \
    php7-openssl \
    php7-mbstring \
    php7-tokenizer \
    php7-fileinfo \
    php7-json \
    php7-xml \
    php7-xmlwriter \
    php7-simplexml \
    php7-pdo \
    php7-pdo_pgsql \
    php7-pdo_mysql \
    php7-pdo_sqlite \
    php7-tokenizer \
    php7-pecl-redis && \
    ln -sf /dev/stdout /var/log/apache2/access.log && \
    ln -sf /dev/stderr /var/log/apache2/error.log && \
    cd /var/www/localhost/htdocs/ && \
    composer install --no-dev && \
    touch /var/www/localhost/htdocs/storage/logs/laravel.log && \
    mkdir -p /var/www/localhost/htdocs/storage/bootstrap/cache && \
    chmod -R 777 /var/www/localhost/htdocs/storage/bootstrap/cache && \
    chown -R apache:apache /var/www/localhost/htdocs && \
    rm /var/www/localhost/htdocs/index.html && \
    httpd -k stop && rm /etc/apache2/httpd.conf

COPY laravel /var/www/localhost/htdocs/
COPY /config/server/supervisord.ini /etc/supervisor.d/supervisord.ini
COPY /config/server/httpd.conf /etc/apache2/httpd.conf

WORKDIR /var/www/localhost/htdocs/

EXPOSE 80
CMD [ "supervisord","-n" ]
