FROM php:8.2-fpm-alpine
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# 1) deps
RUN apk add --no-cache \
    git curl unzip zip \
    $PHPIZE_DEPS \
    libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev \
    libxml2-dev libzip-dev zlib-dev

# 2) pasang per-EXT (biar tahu yang mana yang fail)
RUN docker-php-ext-install -j1 pdo_mysql
RUN docker-php-ext-install -j1 mbstring
RUN docker-php-ext-install -j1 exif
RUN docker-php-ext-install -j1 pcntl
RUN docker-php-ext-install -j1 bcmath

# GD: configure dulu (sering jadi sumber gagal)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp
RUN docker-php-ext-install -j1 gd

# ZIP: sering gagal kalau zlib/libzip kurang (sudah kita pasang)
RUN docker-php-ext-install -j1 zip

RUN docker-php-ext-install -j1 opcache

# Composer & sisa step…
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
RUN addgroup -g 1000 -S www && adduser -S www -G www -u 1000 && chown -R www:www /var/www/html
USER www
CMD ["php-fpm"]
