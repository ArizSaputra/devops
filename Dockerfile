FROM php:8.0-fpm

# Membuat direktori /var/www/devops sebelum menjalankan perintah lainnya
RUN mkdir -p /var/www/devops

# Menentukan direktori kerja di dalam container
WORKDIR /var/www/devops

# Menyalin composer.* ke dalam direktori kerja di container
COPY composer.* /var/www/devops/

# Menginstal dependensi yang dibutuhkan dalam satu RUN untuk mengurangi lapisan
RUN apt-get update && apt-get install -y \
    build-essential \
    libmcrypt-dev \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim optipng pngquant gifsicle vim unzip git curl libzip-dev zip \
    && docker-php-ext-install pdo pdo_mysql gd zip \
    && curl -sS https://getcomposer.org/installer -o /tmp/composer-installer.php \
    && php /tmp/composer-installer.php --install-dir=/usr/local/bin --filename=composer \
    && rm /tmp/composer-installer.php \
    && groupadd -g 1000 www \
    && useradd -u 1000 -ms /bin/bash -g www www

# Menyalin file aplikasi ke dalam container dan mengubah kepemilikan file
COPY . /var/www/devops --chown=www:www  # Pastikan file aplikasi disalin dengan benar

# Menentukan user yang digunakan untuk menjalankan aplikasi
USER www

# Mengekspos port yang digunakan aplikasi
EXPOSE 9000

# Menentukan perintah untuk menjalankan aplikasi
CMD ["php-fpm"]
