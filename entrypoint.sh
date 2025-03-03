#!/bin/sh

# start openrc
rc-status
touch /run/openrc/softlevel

# add sshd and docker service to openrc runlevel
rc-update add sshd default
rc-update add docker default

# start sshd and docker service
rc-service sshd start
rc-service docker start

# initialize LXD
cat <<EOF | lxd init --preseed
config:
  core.https_address: 192.0.2.1:9999
  images.auto_update_interval: 15
networks:
- name: lxdbr0
  type: bridge
  config:
    ipv4.address: auto
    ipv6.address: none
EOF

# keep container running
tail -f /dev/null
