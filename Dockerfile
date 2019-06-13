FROM php:7.3-apache

RUN set -x \
    && apt-get update -y \
    && apt-get install -y \
        libjpeg-dev \
        libmagickwand-dev \
        libpng-dev \
        libzip-dev \
        sudo vim mysql-client \
    && docker-php-ext-configure gd \
        --with-png-dir=/usr \
        --with-jpeg-dir=/usr \
    && docker-php-ext-install \
        bcmath \
        exif \
        gd \
        mysqli \
        opcache \
        zip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# set recommended PHP.ini settings
# see https://secure.php.net/manual/en/opcache.installation.php
RUN { \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini
# https://codex.wordpress.org/Editing_wp-config.php#Configure_Error_Logging
RUN { \
    echo 'error_reporting = 4339'; \
    echo 'display_errors = Off'; \
    echo 'display_startup_errors = Off'; \
    echo 'log_errors = On'; \
    echo 'error_log = /dev/stderr'; \
    echo 'log_errors_max_len = 1024'; \
    echo 'ignore_repeated_errors = On'; \
    echo 'ignore_repeated_source = Off'; \
    echo 'html_errors = Off'; \
} > /usr/local/etc/php/conf.d/error-logging.ini

# enable mod_rewrite
RUN a2enmod rewrite expires

# wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
    php wp-cli.phar --info &&\
    chmod +x wp-cli.phar &&\
    sudo mv wp-cli.phar /usr/local/bin/wp
RUN wp --info

# fix Permission denied
WORKDIR /var/www/html
RUN mkdir /var/www/.wp-cli
RUN chown -R www-data:www-data /var/www/html /var/www/.wp-cli

# download wordpress
# --locale=jaにすると変更が入るため、checksumsで転ける
ENV WORDPRESS_VERSION=5.2.1
RUN wp core download --version=${WORDPRESS_VERSION} --allow-root \
    && wp core verify-checksums --version=${WORDPRESS_VERSION} --allow-root

# 1. env_fileの内容は取得できない（コンテナ起動後に使われる）
# 2. この時点ではDB_HOSTに接続できない
# 3. 実行ユーザーはrootなのでallow-rootが必要。
# 4. root以外のユーザにするとapacheがshutdownする(restarting...が終わらない)

# configure and install (wp-cli doesn't allow being executed as root)
#ENV WORDPRESS_DB_NAME=wordpress
#ENV WORDPRESS_DB_USER=wp_user
#ENV WORDPRESS_DB_PASSWORD=hogehoge
#RUN wp core config --allow-root \
#        --dbhost=${WORDPRESS_DB_HOST} \
#        --dbname=${WORDPRESS_DB_NAME} \
#        --dbuser=${WORDPRESS_DB_USER} \
#        --dbpass=${WORDPRESS_DB_PASSWORD} \
#        --skip-check
## ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2 "No such file or directory")
#RUN wp db create --allow-root
#RUN wp core install --allow-root \
#        --url=localhost:9000 \
#        --title=test \
#        --admin_user=root \
#        --admin_password=root \
#        --admin_email=root@example.com \
#    && wp core language install ja --activate --allow-root
