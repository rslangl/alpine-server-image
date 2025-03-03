FROM alpine:3.21 AS build_hardened
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add --no-cache \
  hardened-malloc \
  openrc \
  bash \
  openssh \
  docker \
  lxd \
  python3 \
  && rm -rf /var/cache/apk/*

FROM build_hardened AS ssh_server

ENV LD_PRELOAD=/usr/lib/libhardened_malloc.so

RUN ssh-keygen -A

RUN mkdir -p /var/run/sshd

RUN mkdir -p /root/.ssh
RUN chmod -R 700 /root/.ssh
COPY ssh/ssh.pub /root/.ssh

RUN cat /root/.ssh/ssh.pub >> /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 22
