FROM php:fpm

COPY archivarix /var/www/html

RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

WORKDIR /var/www/html

EXPOSE 9000

# Запускаем PHP-FPM
CMD ["php-fpm"]
