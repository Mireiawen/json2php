FROM "php:7.3-apache"

# Set up the Apache configuration
ENV APACHE_DOCUMENT_ROOT "/var/www"
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

# Install git and zip for Composer
RUN \
	apt-get "update" && \
	apt-get --yes "install" \
		"git" \
		"unzip"

# Install composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

# Install the application itself
WORKDIR "/var/www"
COPY "app" "/var/www"

# Set up the smarty compile directory
RUN \
	mkdir "/var/www/templates_c" && \
	chown "www-data" "/var/www/templates_c"

# Run the composer setup step
RUN \
        cd "/var/www" && \
        composer "install" --no-dev
