FROM ubuntu:bionic

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:lud-janvier/gnucobol
RUN apt-get update
RUN apt-get install gnucobol apache2 -y

COPY . /var/www/public
WORKDIR /var/www/public

RUN cobc -x -free serverless.cbl -o the.app
RUN chmod +x ./the.app

COPY docker/apache.conf /etc/apache2/sites-available/000-default.conf

EXPOSE 8080


RUN echo "Listen 8080" >> /etc/apache2/ports.conf && \
    chown -R www-data:www-data /var/www/ && \
    a2enmod rewrite && \
    a2enmod cgid

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
