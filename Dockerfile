FROM php:8.2-apache

# Cài các package cần thiết
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

# Configure GD đúng với PHP 8.2
RUN docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
        --with-webp \
        --with-png \
    && docker-php-ext-install gd intl mbstring xmlrpc soap zip pdo_pgsql pgsql opcache

# Bật mod_rewrite Apache
RUN a2enmod rewrite

# Copy mã Moodle
COPY . /var/www/html

# Tạo thư mục dữ liệu
RUN mkdir -p /var/www/moodledata && chmod -R 777 /var/www/moodledata

WORKDIR /var/www/html
EXPOSE 80

CMD ["apache2-foreground"]
