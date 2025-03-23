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
