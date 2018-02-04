#!/bin/bash -e

SUBDIR=${1:-/}
PUKIWIKIPLUS_INITDIR=/usr/src/pukiwiki_plus
VOLUME_DIR=/var/www/html
PUKIWIKIPLUS_DATADIR=${VOLUME_DIR%/}${SUBDIR}

env
echo SUBDIR is $SUBDIR
if [ ! -d "${PUKIWIKIPLUS_DATADIR}/wiki" ]; then
  echo "Initializing PukiWiki Plus..."
  echo "Creating PukiWiki Plus directory...: ${PUKIWIKIPLUS_DATADIR}"
  mkdir -p "${PUKIWIKIPLUS_DATADIR}"
  shopt -s dotglob
  echo "Copying PukiWiki Plus directory..."
  cp -rp ${PUKIWIKIPLUS_INITDIR}/* ${PUKIWIKIPLUS_DATADIR}
  echo "PukiWiki Plus initialized."
fi

exec "apache2-foreground"
