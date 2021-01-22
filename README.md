# docker-cgit

A Docker image for running CGit, a simple and fast web frontend to the git
versioning system. See the [project page](https://git.zx2c4.com/cgit/about/)
for details and features.


## Build

```
make build
```


## Configure

Edit `cgit.d/cgitrc`, which follows the
[cgitrc](https://git.zx2c4.com/cgit/tree/cgitrc.5.txt) specification.

This file (and any additonal files, such as a list of repositories) should be
mounted to `/etc/cgit.d`.


## Deploy

This image depends on an external web server running with CGI support.

NGINX would be configured as:

```
server {
  listen 80;
  server_name _;

  root /app
  try_files $uri @cgit;

  location @cgit {
    include fastcgi_params;
    fastcgi_param SCRIPT_FILENAME /app/cgit.cgi;
    fastcgi_param PATH_INFO $uri;
    fastcgi_param QUERY_STRING $args;
    fastcgi_param HTTP_HOST $server_name;
    fastcgi_pass cgit:9000;
  }
}
```

Both CGit and NGINX can be spun up in a single `docker-compose.yml` file. This
could look like:

```
version: '3.7'
services:
  cgit:
    container_name: cgit
    image: dricottone/cgit:latest
    volumes:
      - /path/to/your/git/repositories:/var/git:ro
      - ./cgit.d:/ext/cgit.d:ro
    networks:
      - cgit-bridge
  nginx:
    container_name: nginx
    image: nginx:alpine
    volumes:
      - ./nginx.d:/etc/nginx/conf.d:ro
    networks:
      - cgit-bridge
    ports:
      - 80:80

networks:
  cgit-bridge:
    name: cgit-bridge
```


## Scope

The container is configured without caching and without path scanning. If you
are interested in those features of CGit, consider using this as a starting
point rather than a final product.


## Licensing

The Dockerfile is licensed under BSD 3-Clause. There are many more pieces of
software involved in the actual build and deploy processes, all under separate
and disparate licenses.


