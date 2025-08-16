# 1) Base image
FROM php:8.2-fpm

# 2) System deps (build deps + runtime)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git curl unzip zip \
    libpng-dev libjpeg-dev libwebp-dev libfreetype6-dev \
    libxml2-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) pdo_mysql mbstring exif pcntl bcmath gd zip opcache \
    && rm -rf /var/lib/apt/lists/*

# 3) Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 4) PHP ini (opsional, tapi disarankan)
RUN { \
      echo "memory_limit=512M"; \
      echo "upload_max_filesize=32M"; \
      echo "post_max_size=32M"; \
      echo "max_execution_time=120"; \
      echo "opcache.enable=1"; \
      echo "opcache.validate_timestamps=0"; \
      echo "opcache.jit=tracing"; \
    } > /usr/local/etc/php/conf.d/laravel.ini

# 5) Workdir
WORKDIR /var/www/html

# 6) User & permission
# (Di runtime kamu bind-mount ./src -> /var/www/html, jadi permission mengikuti host.
#  Tetap bagus men-setup user www-data untuk proses FPM.)
RUN chown -R www-data:www-data /var/www/html
USER www-data

# 7) Expose (opsional, default FPM=9000)
EXPOSE 9000

CMD ["php-fpm"]
