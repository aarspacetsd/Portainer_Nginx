FROM php:8.2-fpm-alpine

# Tampilkan perintah + error detail
SHELL ["/bin/sh", "-o", "pipefail", "-c"]

# 1) Build tools + library dev yang diperlukan
#    (tambahkan zlib-dev; sering terlupa dan bikin ext/zip gagal)
RUN apk add --no-cache \
    git curl unzip zip \
    $PHPIZE_DEPS \
    libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev \
    libxml2-dev libzip-dev zlib-dev

# 2) Konfigurasi GD (pisah step agar errornya jelas)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp

# 3) Install ekstensi PHP (pakai -j1 untuk menghindari OOM di host kecil)
RUN docker-php-ext-install -j1 pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# 4) Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 5) Tuning PHP (opsional)
RUN { \
      echo "memory_limit=512M"; \
      echo "upload_max_filesize=128M"; \
      echo "post_max_size=128M"; \
      echo "max_execution_time=120"; \
      echo "opcache.enable=1"; \
      echo "opcache.enable_cli=1"; \
      echo "opcache.jit=tracing"; \
      echo "opcache.validate_timestamps=0"; \
    } > /usr/local/etc/php/conf.d/laravel.ini

WORKDIR /var/www/html

# User non-root (opsional)
RUN addgroup -g 1000 -S www && adduser -S www -G www -u 1000 \
 && chown -R www:www /var/www/html
USER www

EXPOSE 9000
CMD ["php-fpm"]
