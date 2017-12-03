# What is pukiwiki-plus-docker-compose

PukiWiki Plus for Docker container.

# How to use

## Begin to use PukiWiki Plus

```sh
$ curl -o docker-compose.yml https://raw.githubusercontent.com/ryu-sato/pukiwiki-plus-docker-compose/master/docker-compose.yml
$ docker-compose up -d
```

## Migrate from existing PukiWiki Plus

If you have old contents of PukiWiki Plus in "/var/www/html/wiki", edit volume setting of docker-compose.yml to use these contents.

```sh
$ curl -o docker-compose.yml https://raw.githubusercontent.com/ryu-sato/pukiwiki-plus-docker-compose/master/docker-compose.yml
$ sed -i "/- 'wiki_data:/ s|wiki_data:|/var/www/html/wiki:|" docker-compose.yml
$ docker-compose up -d
```

# for Developer

## How to install PukiWiki Plus plugins

Edit Dockerfile and rebuild Docker image.

```text
# Dockerfile
  : <snip>
# Install pukiwiki-plus plugin
## ls2_1
##   ref: http://pukiwiki.sonots.com/?Old%2FPlugin%2Fls2_1.inc.php
ENV PUKIWIKIPLUS_PLUGIN_LS2_1_VER 27
RUN cd ${PUKIWIKIPLUS_PLUGINDIR} \
        && curl -o ls2_1.inc.php -SL "http://pukiwiki.sonots.com/?plugin=attach&refer=Old%2FPlugin%2Fls2_1.inc.php&openfile=ls2_1.inc.php.${PUKIWIKIPLUS_PLUGIN_LS2_1_VER}"
  : <snip>
```

And then, edit docker-compose.yml to use new image.

```YAML
# docker-compose.yml
version: '2'
services:
  wiki:
    image: 'ryu310/pukiwiki-plus:7-apache' # EDIT IMAGE'S TAG !!!
    build:
      context: .
      dockerfile: Dockerfile
    volumes:
      - 'wiki_data:/var/www/html'
    ports:
      - 80:80
volumes:
  wiki_data:
```

```
$ docker-compose up --build
```
