FROM alpine:3.21 AS build_hardened
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories
RUN apk update && apk add --no-cache hardened-malloc \
  openrc \
  bash \
  openssh \
  && rm -rf /var/cache/apk/*

FROM build_hardened AS ssh_server

RUN ssh-keygen -A

RUN mkdir -p /var/run/sshd

RUN mkdir -p /root/.ssh
RUN chmod -R 700 /root/.ssh
COPY ssh/ssh.pub /root/.ssh

# RUN mkdir /etc/ssh/authorized_keys
# COPY ssh/ssh.pub /etc/ssh/authorized_keys/ssh.pub
# RUN cat /etc/ssh/authorized_keys/ssh.pub >> /home/root/.ssh/authorized_keys
RUN cat /root/.ssh/ssh.pub >> /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys

RUN echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
RUN echo 'PasswordAuthentication yes' >> /etc/ssh/sshd_config
RUN echo 'PubkeyAuthentication yes' >> /etc/ssh/sshd_config

COPY entrypoint.sh /usr/local/bin/entrypoint.sh

# exec LD_PRELOAD=/usr/lib/libhardened_malloc.so

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 22
