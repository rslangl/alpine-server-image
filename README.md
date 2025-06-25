# infra-alpine-sandbox

Test-runs of various configs on an Alpine instance

## Usage

Launch nix-shell:
```shell
nix-shell
```

This will build and launch the Docker container. Once ready, run the playbook:
```shell
ansible-playbook -i inventory -u root --private-key ssh/ssh playbook.yml
```
## Bugs

* It seems that the python packages required for the docker module is not properly installed, so the workaround was to `docker exec` into the container and manually install them
* There is some issues with `requests` and the docker module, as [discussed here](https://github.com/ansible-collections/community.docker/issues/860). The solution for now was to run `ansible-galaxy collection install community.docker --force`

## TODO

* `.env` file containing versions (e.g. `alpine=3.21.2`, `arch=x86_64`)
* Nix-shell with `qemu-utils` installed
* Download image:
```shell
curl https://dl-cdn.alpinelinux.org/alpine/v3.21/releases/cloud/nocloud_alpine-3.21.2-x86_64-uefi-cloudinit-r0.qcow2
```
* Mount image:
```shell
sudo modprobe nbd max_part=8
sudo qemu-nbd --connect=/dev/nbd0 nocloud_alpine-3.21.2-x86_64-uefi-cloudinit-r0.qcow2
sudo mount /dev/nbd0p1 /mnt
```
* Chroot into image:
```shell
sudo mount --bind /dev /mnt/dev
sudo mount --bind /proc /mnt/proc
sudo mount --bind /sys /mnt/sys
sudo mount --bind /run /mnt/run
sudo chroot /mnt
```
* Install packages:
```shell
apk update
apk add openssh cloud-init qemu-guest-agent net-tools
```
* Configure:
```shell
rc-update add sshd
```
* Clear package cache
```shell
apk cache clean
```
* Exit and unmount:
```shell
exit
sudo umount /mnt/dev
sudo umount /mnt/proc
sudo umount /mnt/sys
sudo umount /mnt/run
sudo umount /mnt
sudo qemu-nbd --disconnect /dev/nbd0
```

