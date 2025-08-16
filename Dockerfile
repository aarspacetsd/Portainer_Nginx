FROM php:8.2-fpm-alpine

# Install system dependencies
RUN apk add --no-cache \
    git \
    curl \
    unzip \
    zip \
    libpng-dev \
    libjpeg-turbo-dev \
    libwebp-dev \
    freetype-dev \
    libxml2-dev \
    libzip-dev \
    zlib-dev \
    oniguruma-dev \
    mysql-client \
    nodejs \
    npm

# Install PHP extensions
RUN docker-php-ext-configure gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-install -j$(nproc) \
        pdo_mysql \
        mbstring \
        exif \
        pcntl \
        bcmath \
        gd \
        zip \
        opcache

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Create user and set permissions
RUN addgroup -g 1000 -S www \
    && adduser -S www -G www -u 1000

# Copy PHP-FPM configuration
COPY ./php/php-fpm.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./php/php.ini /usr/local/etc/php/php.ini

# Set working directory
WORKDIR /var/www/html

# Change ownership of working directory
RUN chown -R www:www /var/www/html

# Switch to non-root user
USER www

# Expose port 9000
EXPOSE 9000

CMD ["php-fpm"]