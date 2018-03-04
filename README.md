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

## Use subdirectory instead of root

If you want to access pukiwiki plus with sub directory path like `http://localhost/wiki/`,
running with SUBDIR environment.

```sh
$ docker run --env SUBDIR=/wiki --name my-pukiwiki-plus ryu310/pukiwiki-plus
```

## Configure Apache

[Apache設定](https://github.com/ryu-sato/pukiwiki-plus-docker-compose/wiki/Apache-%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%92%E8%A8%AD%E5%AE%9A%E3%81%99%E3%82%8B)

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
