#!/bin/sh

# start openrc
rc-status
touch /run/openrc/softlevel

# add sshd service to openrc runlevel
rc-update add sshd default

# start sshd service
rc-service sshd start

# keep container running
tail -f /dev/null
