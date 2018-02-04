FROM php:7-apache

MAINTAINER Ryu Sato <ryu@weseek.co.jp>

VOLUME /var/www/html

# Variable environment value
ARG SUBDIR="/"
ENV SUBDIR $SUBDIR

# Const environment value
ARG PUKIWIKIPLUS_INITDIR="/usr/src/pukiwiki_plus"
ARG PUKIWIKIPLUS_PLUGINDIR="${PUKIWIKIPLUS_INITDIR}/plugin"

# Install pukiwiki-plus
RUN cd /
RUN apt-get update && apt-get install -y \
      git \
    && rm -rf /var/lib/apt/lists/*
RUN git clone git://git.pf.osdn.net/gitroot/n/ni/night1ynx/pukiwiki_plus.git ${PUKIWIKIPLUS_INITDIR} \
	&& rm -rf ${PUKIWIKIPLUS_INITDIR}/.git

# Install pukiwiki-plus plugin
## ls2_1
##   ref: http://pukiwiki.sonots.com/?Old%2FPlugin%2Fls2_1.inc.php
ARG PUKIWIKIPLUS_PLUGIN_LS2_1_VER="27"
RUN cd ${PUKIWIKIPLUS_PLUGINDIR} \
	&& curl -o ls2_1.inc.php -SL "http://pukiwiki.sonots.com/?plugin=attach&refer=Old%2FPlugin%2Fls2_1.inc.php&openfile=ls2_1.inc.php.${PUKIWIKIPLUS_PLUGIN_LS2_1_VER}"

# Set permissions of pukiwiki
RUN cd ${PUKIWIKIPLUS_INITDIR} \
	&& chown -R www-data:www-data ${PUKIWIKIPLUS_INITDIR}

# Prepare apache user for sudoers
RUN apt-get update && apt-get install -y \
      sudo \
    && rm -rf /var/lib/apt/lists/*
RUN echo "${APACHE_RUN_USER:-www-data} ALL=NOPASSWD: ALL" >> /etc/sudoers

# Set config to redirect subdir
ARG REDIRECT_CONF=conf-available/redirect-subdir.conf
RUN a2enmod rewrite
RUN echo "RewriteEngine on\n" \
	"RewriteRule ^/$ $SUBDIR [R,L]" > /etc/apache2/$REDIRECT_CONF
RUN (test ${SUBDIR} != "/" \
     && a2enconf redirect-subdir \
     && sed -i \
         -e "s|^\(\s*#Include conf-available/.*\)$|\1\n\tInclude ${REDIRECT_CONF}|" \
        /etc/apache2/sites-available/000-default.conf \
    ) || true

COPY scripts/app-entrypoint.sh /
USER ${APACHE_RUN_USER:-www-data}
# Use shell form with ENV
#   cf. https://github.com/moby/moby/issues/5509
ENTRYPOINT sudo /app-entrypoint.sh ${SUBDIR}
CMD ["sudo", "apache2-foreground"]
