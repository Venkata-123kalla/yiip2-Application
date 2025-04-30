FROM php:8.1-apache

# Install required extensions
RUN apt-get update && apt-get install -y \
    git unzip zip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql gd

# Enable Apache rewrite module
RUN a2enmod rewrite

# Set working directory to Apache root
WORKDIR /var/www/html

# Copy Yii2 app
COPY yii2-app/ /var/www/html/

# Set DocumentRoot to Yii2's web folder
ENV APACHE_DOCUMENT_ROOT=/var/www/html/web

# Update Apache site config
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/000-default.conf \
    && sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}/../!g' /etc/apache2/apache2.conf

# Set permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html

# Install Composer and Yii dependencies
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer install --no-interaction --prefer-dist --working-dir=/var/www/html

EXPOSE 80
CMD ["apache2-foreground"]


