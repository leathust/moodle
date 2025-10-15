# Sử dụng image PHP có Apache sẵn
FROM php:8.2-apache

# Cài các gói và extension cần thiết cho Moodle
RUN apt-get update && apt-get install -y \
    libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev zip unzip git curl \
    && docker-php-ext-install mysqli pdo pdo_mysql gd intl xmlrpc soap \
    && a2enmod rewrite

# Copy toàn bộ mã nguồn Moodle vào thư mục web
COPY . /var/www/html/

# Tạo và phân quyền cho thư mục moodledata
RUN mkdir /var/www/moodledata && chown -R www-data:www-data /var/www/html /var/www/moodledata

# Expose cổng 80 cho HTTP
EXPOSE 80

# Lệnh chạy Apache
CMD ["apache2-foreground"]
