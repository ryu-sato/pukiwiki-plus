#!/bin/bash -e

PUKIWIKIPLUS_INITDIR=/usr/src/pukiwiki_plus
VOLUME_DIR=/var/www/html

if [ ! -d "${VOLUME_DIR}/wiki" ]; then
  echo "Initializing PukiWiki Plus..."
  shopt -s dotglob
  cp -rp ${PUKIWIKIPLUS_INITDIR}/* ${VOLUME_DIR}
  echo "PukiWiki Plus initialized."
fi

if [ "${1#-}" != "$1" ]; then
  set -- apache2-foreground "$@"
fi

exec "$@"
