FROM php:8.0-fpm

# Menyalin composer.* ke dalam direktori kerja di container
COPY composer.* /var/www/devops

# Menentukan direktori kerja di dalam container
WORKDIR /var/www/devops

# Menginstal dependensi yang dibutuhkan
RUN apt-get update && apt-get install -y \
    build-essential \
    libmcrypt-dev \
    mariadb-client \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    jpegoptim optipng pngquant gifscale \
    vim \
    unzip \
    git \
    curl \
    libzip-dev \
    zip

# Menjalankan perintah untuk instalasi ekstensi PHP yang diperlukan
RUN docker-php-ext-install pdo pdo_mysql gd zip

# Mengunduh dan menginstal Composer
RUN curl -sS https://getcomposer.org/installer | php --install-dir=/usr/local/bin --filename=composer

# Membuat grup dan pengguna 'www' untuk menjalankan aplikasi
RUN groupadd -g 1000 www 
RUN useradd -u 1000 -ms /bin/bash -g www www

# Menyalin file aplikasi ke dalam container
COPY . .

# Mengubah kepemilikan file menjadi 'www'
COPY . --chown=www:www .

# Menentukan user yang digunakan untuk menjalankan aplikasi
USER www

# Mengekspos port yang digunakan aplikasi
EXPOSE 9000

# Menentukan perintah untuk menjalankan aplikasi
CMD ["php-fpm"]
