# Use the official Ubuntu 22.04 image as base
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=nonintercative

# Update and install necessary packages
RUN apt-get update && apt-get install -y \
    php8.1-fpm \
    nginx \
    composer \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-zip \
    php8.1-curl \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Laravel
RUN composer global require laravel/installer

# Add Laravel application to the container
WORKDIR /var/www/
RUN composer create-project --prefer-dist laravel/laravel projectlar

# Configure Nginx
COPY nginx-site.conf /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/nginx-site.conf /etc/nginx/sites-enabled/my-site

# Expose ports
EXPOSE 80

# Start PHP-FPM and Nginx
CMD service php8.1-fpm start && nginx -g "daemon off;"

# Define a healthcheck to ensure the container is healthy
HEALTHCHECK CMD curl -f http://localhost || exit 1

