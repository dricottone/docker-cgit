# CGit Dockerfile
# Dominic Ricottone
# BSD 3-Clause

ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION}

WORKDIR /app

COPY cgitrc /etc/cgitrc
COPY cgit.d /etc/cgit.d
COPY app /app

RUN apk add --update spawn-fcgi fcgiwrap cgit git python3 py3-setuptools py3-pygments py3-markdown dumb-init

EXPOSE 9000

ENTRYPOINT ["/usr/bin/dumb-init", "--"]

CMD ["spawn-fcgi", "-p", "9000", "-n", "/usr/bin/fcgiwrap"]

