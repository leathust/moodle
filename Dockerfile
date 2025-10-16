FROM php:8.2-apache

# Cập nhật và cài các package cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    libpq-dev \
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    unzip \
    git \
    && rm -rf /var/lib/apt/lists/*

# Cấu hình gd với jpeg/freetype
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl mbstring xmlrpc soap zip pdo_pgsql pgsql opcache

# Bật mod_rewrite cho Apache
RUN a2enmod rewrite

# Copy mã Moodle vào container
COPY . /var/www/html

# Tạo thư mục dữ liệu Moodle
RUN mkdir -p /var/www/moodledata && chmod -R 777 /var/www/moodledata

# Đặt working dir
WORKDIR /var/www/html

# Expose cổng 80
EXPOSE 80

# Khởi động Apache
CMD ["apache2-foreground"]
