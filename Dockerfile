# Sử dụng image PHP chính thức có Apache
FROM php:8.2-apache

# Cài các extension cần cho Moodle
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libxml2-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libonig-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl mbstring xmlrpc soap zip pdo_pgsql pgsql opcache

# Bật mod_rewrite cho Apache
RUN a2enmod rewrite

# Copy mã Moodle vào container
COPY . /var/www/html

# Thiết lập quyền ghi cho thư mục dữ liệu
RUN mkdir -p /var/www/moodledata && chmod -R 777 /var/www/moodledata

# Đặt thư mục làm working dir
WORKDIR /var/www/html

# Expose cổng mặc định
EXPOSE 80

# Khởi động Apache
CMD ["apache2-foreground"]
