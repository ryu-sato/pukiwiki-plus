FROM php:7-apache

MAINTAINER Ryu Sato <ryu@weseek.co.jp>

VOLUME /var/www/html

# Static variables
ENV PUKIWIKIPLUS_INITDIR /usr/src/pukiwiki_plus
ENV PUKIWIKIPLUS_PLUGINDIR ${PUKIWIKIPLUS_INITDIR}/plugin

# Install pukiwiki-plus
RUN cd /
RUN apt-get update && apt-get install -y git
RUN git clone git://git.pf.osdn.net/gitroot/n/ni/night1ynx/pukiwiki_plus.git ${PUKIWIKIPLUS_INITDIR} \
	&& rm -rf ${PUKIWIKIPLUS_INITDIR}/.git

# Install pukiwiki-plus plugin
## ls2_1
##   ref: http://pukiwiki.sonots.com/?Old%2FPlugin%2Fls2_1.inc.php
ENV PUKIWIKIPLUS_PLUGIN_LS2_1_VER 27
RUN cd ${PUKIWIKIPLUS_PLUGINDIR} \
	&& curl -o ls2_1.inc.php -SL "http://pukiwiki.sonots.com/?plugin=attach&refer=Old%2FPlugin%2Fls2_1.inc.php&openfile=ls2_1.inc.php.${PUKIWIKIPLUS_PLUGIN_LS2_1_VER}"

# Set permissions of pukiwiki
RUN cd ${PUKIWIKIPLUS_INITDIR} \
	&& chown -R www-data:www-data ${PUKIWIKIPLUS_INITDIR}


COPY scripts/app-entrypoint.sh /
ENTRYPOINT ["/app-entrypoint.sh"]
CMD ["apache2-foreground"]