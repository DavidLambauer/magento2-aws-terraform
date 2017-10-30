#!/usr/bin/env bash

########################################################################################################################
# Hello Internet!
# This bash script is the most simplest way to provision Magento 2 with all its dependencies. You might want to use
# another tool like ansible, puppet, chef or salt to install the necessary dependencies. Feel free to do so. You will
# find Information about other provisioners here: https://www.terraform.io/docs/provisioners/index.html
########################################################################################################################

# Make sure every command send output. Also make sure, that the program exits after an error.
set -x

# To get the whole user_data output, we save it to a log file under /var/log/user_data.log
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# Add PHP 7.1 Repository
sudo -E add-apt-repository -y ppa:ondrej/php
sudo -E apt-get update -y --force-yes

# Install necessary components like PHP with all Magento specific extension or nginx.
sudo -E apt-get install --no-install-recommends -y --force-yes  \
    nginx \
    python-software-properties \
    php7.1 \
    php7.1-xml \
    php7.1-xsl \
    php7.1-mbstring \
    php7.1-zip \
    php7.1-mysql \
    php7.1-opcache \
    php7.1-json \
    php7.1-curl \
    php7.1-intl \
    php7.1-fpm \
    php7.1-soap \
    php7.1-mcrypt \
    php7.1-gd \
    git

# Optimize the PHP.ini
# @TODO: Add the ini configuration to the correct php.ini
#memory_limit = 2G
#max_execution_time = 1800
#zlib.output_compression = On

# Restart PHP FPM Service
sudo -E service php7.1-fpm restart

# Remove the default page from nginx
sudo -E rm -Rf /var/www/html/index.nginx-debian.html

# Clone the Shop repository with an access key.
sudo -E git clone ${GIT_REPOSITORY_URL} /var/www/html

# Change Directory to /var/www/html
cd /var/www/html

# Add the nginx configuration for Magento
sudo -E cp /var/www/html/nginx.conf.sample /etc/nginx/sites-available/magento.conf

# Activate the configuration
sudo -E ln -s /etc/nginx/sites-available/magento.conf /etc/nginx/sites-enabled/

# Remove the default site
sudo -E rm -Rf /etc/nginx/sites-enabled/default

# Restart nginx
sudo -E service nginx restart

# Composer needs a Cache Directory. Normally composer takes the ~/ Dir, but we are not in an environment that supports ~/, so we do it manually.
mkdir -p /var/www/cache/composer
export COMPOSER_HOME=/var/www/cache/composer/

# Install PHP's Composer
sudo -E php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo -E php -r "if (hash_file('SHA384', 'composer-setup.php') === '544e09ee996cdf60ece3804abc52599c22b1f40f4323403c44d44fdfdd586475ca9813a858088ffbc1f233e9b180f061') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
sudo -E php composer-setup.php
sudo -E php -r "unlink('composer-setup.php');"

# Install dependencies
sudo -E php composer.phar --no-dev --optimize-autoloader --no-interaction install

# Add the production configuration
sudo -E rm -Rf app/etc/env.php
#sudo -E cp app/etc/env.php.production app/etc/env.php

# Make sure, permissions are set correctly.
sudo -E chown -R www-data:www-data .

# Set File Permissions as Magento expects it.
sudo -E chmod u+x bin/magento

# Configure Magento
sudo -E php bin/magento setup:install -n -v --db-host="${MAGENTO_DATABASE_HOST}" --db-name="${MAGENTO_DATABASE_NAME}" --db-user="${MAGENTO_DATABASE_USER}" --db-password="${MAGENTO_DATABASE_PASSWORD}" --base-url="${MAGENTO_BASE_URL}" --backend-frontname="${MAGENTO_ADMIN_FRONTNAME}" --admin-user="${MAGENTO_ADMIN_USER}" --admin-password="${MAGENTO_ADMIN_PASSWORD}" --admin-email="${MAGENTO_ADMIN_EMAIL}" --admin-firstname="${MAGENTO_ADMIN_FIRSTNAME}" --admin-lastname="${MAGENTO_ADMIN_LASTNAME}" --language="${MAGENTO_LOCALE}" --timezone="${MAGENTO_ADMIN_TIMEZONE}" --session-save=redis --session-save-redis-host=${MAGENTO_REDIS_HOST_NAME} --session-save-redis-log-level=3 --session-save-redis-db=2 --page-cache=redis --page-cache-redis-server=${MAGENTO_REDIS_HOST_NAME} --page-cache-redis-db=1 --cache-backend=redis --cache-backend-redis-server=${MAGENTO_REDIS_HOST_NAME} --cache-backend-redis-db=0

# Make sure the Base Url and the Cookie Domains are always set correctly. This will be necessary in case the DNS Name Changes. For example the DNS Name changes if you destroy the LoadBalancer.
sudo -E php bin/magento config:set web/unsecure/base_url ${MAGENTO_BASE_URL}
sudo -E php bin/magento config:set web/cookie/cookie_domain ${MAGENTO_HOST_NAME}

# Lets increase the Admin Session
sudo -E php bin/magento config:set admin/security/session_lifetime 1800

# Install Modules and Update the System, if it is not already done.
sudo -E php bin/magento setup:upgrade

# Set Production Mode
sudo -E php bin/magento deploy:mode:set production

# Compile DI
sudo -E php bin/magento setup:di:compile

# Publish Static Files
sudo -E php bin/magento setup:static-content:deploy

# Make sure, permissions are set correctly
sudo -E chown -R www-data:www-data .