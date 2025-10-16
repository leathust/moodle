FROM php:8.2-apache

# Cài package cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    libwebp-dev \
    pkg-config \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Configure và cài GD + các extension Moodle cần
RUN docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/ \
        --with-webp=/usr/include/ \
    && docker-php-ext-install gd intl mbstring xmlrpc soap zip pdo_pgsql pgsql opcache

# Bật mod_rewrite cho Apache
RUN a2enmod rewrite

# Copy code Moodle
COPY . /var/www/html

# Tạo thư mục dữ liệu Moodle
RUN mkdir -p /var/www/moodledata && chmod -R 777 /var/www/moodledata

# Working directory
WORKDIR /var/www/html

# Expose cổng 80
EXPOSE 80

# Start Apache
CMD ["apache2-foreground"]
