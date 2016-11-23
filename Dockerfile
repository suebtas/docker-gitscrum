FROM php:7-fpm

RUN apt-get update && apt-get install -y \
	wget \
	git \
	libcurl4-gnutls-dev \
	libmcrypt-dev  \
        libxml2-dev \
	libicu-dev \
	mysql-client \
	&& docker-php-ext-install pdo_mysql \
        && docker-php-ext-install mysqli \
	&& docker-php-ext-install iconv \
	&& docker-php-ext-install mcrypt \
	&& docker-php-ext-install intl \
	&& docker-php-ext-install opcache \
	&& docker-php-ext-install mbstring \
	&& docker-php-ext-install gettext \
	&& docker-php-ext-install soap \
        && docker-php-ext-install curl

RUN apt-get install -y locales

RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

ENV LC_ALL C.UTF-8 ENV LANG en_US.UTF-8

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
RUN wget https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar

RUN chmod u+x *.phar

RUN mv phpcbf.phar /usr/local/bin/phpcbf
RUN mv phpcs.phar /usr/local/bin/phpcs
RUN chmod -Rf 0777 /usr/local/bin/phpcs
##RUN phpcs --config-set default_standard PSR2

CMD ["php-fpm"]
