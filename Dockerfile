
# Mulai dari image resmi PHP 8.2 dengan FPM
FROM php:8.2-fpm

# Install dependensi sistem yang dibutuhkan
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install ekstensi PHP yang umum digunakan oleh Laravel
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer (dependency manager untuk PHP)
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set direktori kerja
WORKDIR /var/www/html

# Ubah kepemilikan direktori ke user www-data
RUN chown -R www-data:www-data /var/www/html

# Ganti user ke www-data
USER www-data

# Perintah default yang akan dijalankan
CMD ["php-fpm"]
