# Gunakan image PHP 8.2 FPM Alpine sebagai dasar
FROM php:8.2-fpm-alpine

# Set working directory
WORKDIR /var/www/html

# Install dependensi sistem yang dibutuhkan
RUN apk update && apk add --no-cache \
    build-base \
    libpng-dev \
    libzip-dev \
    zip \
    oniguruma-dev \
    libxml2-dev \
    curl \
    git

# Install ekstensi PHP yang umum dibutuhkan Laravel
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer (Package Manager untuk PHP)
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Ganti user ke www-data
USER www-data

# Expose port 9000 untuk PHP-FPM
EXPOSE 9000