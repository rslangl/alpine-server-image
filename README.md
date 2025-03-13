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

