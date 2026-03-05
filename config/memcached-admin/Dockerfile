FROM php:8-apache
RUN apt-get update && apt-get install -y libmemcached-dev zlib1g-dev unzip \
    && pecl install memcached \
    && docker-php-ext-enable memcached \
    && rm -rf /var/lib/apt/lists/*
ADD https://github.com/elijaa/phpmemcachedadmin/archive/refs/heads/master.zip /tmp/app.zip
RUN unzip /tmp/app.zip -d /tmp \
    && cp -r /tmp/phpmemcachedadmin-master/* /var/www/html/ \
    && rm -rf /tmp/app.zip /tmp/phpmemcachedadmin-master \
    && chown -R www-data:www-data /var/www/html
COPY Memcache.php /var/www/html/Config/Memcache.php
