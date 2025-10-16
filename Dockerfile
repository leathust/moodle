# ============================
#  Dockerfile cho Moodle 5.1+
#  PHP 8.2 + PostgreSQL 15
#  Tối ưu cho Render Deployment
# ============================

# Sử dụng image PHP 8.2 có Apache sẵn
FROM php:8.2-apache

# Thiết lập môi trường
ENV DEBIAN_FRONTEND=noninteractive

# Cài đặt các gói cần thiết cho Moodle + PostgreSQL
RUN apt-get update && apt-get install -y \
    git unzip curl libpng-dev libjpeg-dev libfreetype6-dev libxml2-dev libzip-dev libicu-dev libpq-dev libonig-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd intl mbstring xml zip soap opcache pdo_pgsql \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Bật mod_rewrite cho Apache (cần thiết cho Moodle)
RUN a2enmod rewrite

# Thiết lập thư mục làm việc
WORKDIR /var/www/html

# Sao chép toàn bộ mã nguồn Moodle vào container
COPY . /var/www/html/

# Tạo thư mục moodledata bên ngoài web root
RUN mkdir -p /var/www/moodledata && chown -R www-data:www-data /var/www/moodledata

# Cấp quyền ghi cho Moodle
RUN chown -R www-data:www-data /var/www/html

# Tối ưu PHP (tùy chọn)
RUN echo "upload_max_filesize = 100M\npost_max_size = 100M\nmax_execution_time = 300" > /usr/local/etc/php/conf.d/moodle.ini

# Cấu hình Apache cho Moodle
RUN echo '<Directory /var/www/html/>\n\
    Options Indexes FollowSymLinks MultiViews\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>' > /etc/apache2/conf-available/moodle.conf \
    && a2enconf moodle

# Cổng Render sử dụng
EXPOSE 10000

# Apache lắng nghe port Render yêu cầu
ENV PORT=10000

# Khởi động Apache
CMD ["apache2-foreground"]
