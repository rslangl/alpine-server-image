FROM alpine:3.21 AS build_hardened
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add --no-cache hardened-malloc \
  openrc \
  bash \
  openssh \
  && rm -rf /var/cache/apk/*

FROM build_hardened AS ssh_server

RUN ssh-keygen -A

RUN echo 'PasswordAuthentication no' >> /etc/ssh/sshd_config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# exec LD_PRELOAD=/usr/lib/libhardened_malloc.so

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 22
