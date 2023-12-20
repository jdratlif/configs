# Home Directory Configs

Ansible playbook to keep home directory configuration consistent.

Writes the following configuration files from templates:

- .bashrc/.bash_profile (linux) / .zshrc (macOS)
- .gitconfig
- .perltidyrc
- .ssh/config and .ssh/authorized_keys
- .tmux.conf
- .vimrc and vim yaml plugin

## Running from the CLI (bastions and laptops)

Run the repo against your host.
Replace TARGETS with the host target (e.g. skip.grnoc.iu.edu or laptop).

```bash
ansible-playbook playbook.yml -e targets=TARGETS
```
