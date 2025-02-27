#!/bin/sh

# # start openrc
# touch /run/openrc/softlevel
# rc-status
#
# # add sshd service to openrc runlevel
# rc-update add sshd default
#
# # start sshd service
# rc-service sshd start

sshd -D &

# keep container running
tail -f /dev/null
