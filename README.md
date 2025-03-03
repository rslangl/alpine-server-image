# home-infra-sandbox

Test-runs of various workloads I want to utilize at home.

## Usage

Launch nix-shell:
```shell
nix-shell
```

This will build and launch the Docker container. Once ready, run the playbook:
```shell
ansible-playbook -i inventory -u root --private-key ssh/ssh playbook.yml
```

## TODO

* ~~SSH server~~
* ~~Short-lived SSH keys: auto-generate client keys and copy to Docker container~~
* ~~Ansible playbook test~~
* Vault workload
* FreeIPA workload
