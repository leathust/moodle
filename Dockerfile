# Sử dụng image PHP có Apache sẵn
FROM php:8.2-apache

# Cài đặt các package và extension cần cho Moodle
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev libicu-dev libzip-dev zip unzip git curl libxslt1-dev libonig-dev libcurl4-openssl-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd intl soap xmlrpc zip mysqli pdo pdo_mysql xsl \
    && a2enmod rewrite

# Copy toàn bộ mã nguồn Moodle vào thư mục web
COPY . /var/www/html/

# Tạo và phân quyền cho thư mục moodledata
RUN mkdir -p /var/www/moodledata && chown -R www-data:www-data /var/www/html /var/www/moodledata

# Expose cổng 80 cho HTTP
EXPOSE 80

# Chạy Apache
CMD ["apache2-foreground"]
