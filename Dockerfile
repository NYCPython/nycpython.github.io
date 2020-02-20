FROM alpine:edge

RUN apk add --no-cache python3 python3-dev nodejs npm g++ linux-headers zeromq-dev bash less \
 && apk add --no-cache --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing gosu
RUN python3 -m pip install circus

WORKDIR /web

COPY . /web/

# used by env/entrypoint.sh
ENV DOCKER_USER=web
ENV DOCKER_USER_RW_DIRS=/web

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod ugo+rx /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD ["/usr/bin/circusd", "circus.ini"]

EXPOSE 5000
EXPOSE 5001

# See https://github.com/opencontainers/image-spec/blob/master/annotations.md
# LABEL name=
# LABEL description=
# LABEL created=
# LABEL version=
