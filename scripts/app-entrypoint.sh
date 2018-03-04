#!/bin/bash -e

SUBDIR=${SUBDIR:-/}
PUKIWIKIPLUS_INITDIR=/usr/src/pukiwiki_plus
VOLUME_DIR=/var/www/html
PUKIWIKIPLUS_DATADIR=${VOLUME_DIR%/}${SUBDIR}
WITHOUT_APACHEGUI=${WITH_APACHEGUI:-}

if [ ! -f "${PUKIWIKIPLUS_DATADIR}/pukiwiki.ini.php" ]; then
  echo "Installing PukiWiki Plus..."
  echo "Create PukiWiki Plus directory. ${PUKIWIKIPLUS_DATADIR}"
  mkdir -p "${PUKIWIKIPLUS_DATADIR}" || true
  shopt -s dotglob
  echo "Copy PukiWiki Plus directory."
  cp -rp ${PUKIWIKIPLUS_INITDIR}/* ${PUKIWIKIPLUS_DATADIR}
  echo "PukiWiki Plus was installed."
fi

if [ "$SUBDIR" != "/" ]; then
  # Set config to redirect subdir
  REDIRECT_CONF=conf-available/redirect-subdir.conf
  a2enmod rewrite
  ( cat > /etc/apache2/$REDIRECT_CONF <<- EOV
	RewriteEngine on
	RewriteRule ^/\$ $SUBDIR [R,L]
EOV
  ) || true
  (test ${SUBDIR} != "/" \
   && a2enconf redirect-subdir \
   && sed -i \
       -e "s|^\(\s*#Include conf-available/.*\)$|\1\n\tInclude ${REDIRECT_CONF}|" \
      /etc/apache2/sites-available/000-default.conf \
  ) || true
fi

if [ "${WITHOUT_APACHEGUI}" != "WITHOUT_APACHEGUI" ]; then
  cd "${APACHEGUI_HOME}/bin" && ./run.sh && cd "/"
fi

exec "apache2-foreground"
