FROM php:8.4-fpm

# 安裝系統依賴
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libzip-dev \
    libicu-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# 配置和安裝 PHP 擴展
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    mysqli \
    pdo_mysql \
    zip \
    intl \
    exif \
    opcache \
    bcmath \
    soap \
    mbstring

# 安裝 Xdebug
RUN pecl install xdebug-3.4.0 \
    && docker-php-ext-enable xdebug

# 安裝 Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 修改 www-data 的 UID/GID 為 1000（與主機用戶一致）
RUN usermod -u 1000 www-data && \
    groupmod -g 1000 www-data

# 設定工作目錄
WORKDIR /var/www/html

# 建立啟動腳本來確保正確的權限
RUN echo '#!/bin/bash\n\
# 確保 wp-content 目錄結構存在\n\
mkdir -p /var/www/html/wp-content/plugins \
         /var/www/html/wp-content/themes \
         /var/www/html/wp-content/uploads \
         /var/www/html/wp-content/upgrade\n\
\n\
# 設定正確的所有權和權限\n\
chown -R www-data:www-data /var/www/html/wp-content\n\
chmod -R 755 /var/www/html/wp-content\n\
\n\
# 啟動 PHP-FPM\n\
exec php-fpm\n\
' > /usr/local/bin/docker-entrypoint.sh && \
chmod +x /usr/local/bin/docker-entrypoint.sh

# 暴露 PHP-FPM 端口
EXPOSE 9000

CMD ["/usr/local/bin/docker-entrypoint.sh"]

