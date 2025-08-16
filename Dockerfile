FROM php:8.2-fpm-alpine

# Build tools & deps untuk ekstensi
RUN apk add --no-cache \
    git curl unzip zip \
    libpng-dev libjpeg-turbo-dev libwebp-dev freetype-dev \
    libxml2-dev libzip-dev $PHPIZE_DEPS \
 && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
 && docker-php-ext-install -j"$(nproc)" pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# (Opsional) tuning PHP
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
