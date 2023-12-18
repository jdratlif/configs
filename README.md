# Home Directory Configs

Ansible playbook to keep home directory configuration consistent.

Writes the following configuration files from templates:

- .bashrc and .bash_profile
- .gitconfig
- .perltidyrc
- .ssh/config and .ssh/authorized_keys
- .tmux.conf
- .vimrc and vim yaml plugin

## Running from awx

Open the awx template

- [GRNOC](https://awx.grnoc.iu.edu/#/templates/job_template/463)
- [N-Wave](https://awx.bldc.nwave.noaa.gov/#/templates/job_template/222)

Click the Launch button.

- Add a ticket number (whatever you're currently working on should be fine).
- Add the target host or hosts (e.g. build-new.grnoc.iu.edu)
- Fill in your GHE name
- Add your custom vars file if you have one (you probably do not)

## Running from the CLI (bastions and laptops)

Checkout the repo

```bash
git clone https://github.grnoc.iu.edu/Ansible/home-dir-config.git
git submodule update --init
```

Run the repo against your host.
Replace TARGETS with the host target (e.g. skip.grnoc.iu.edu or laptop).

```bash
ansible-playbook playbook.yml -e targets=TARGETS
```

The inventory is configured to connect to most hosts thru a bastion.
If you want to run this on the CLI for non-local targets, you must add the ansible automation key to your ssh-agent.

```bash
eval $(ssh-agent)
ssh-add ~/private/ansible-syseng-servers-internal.pem
```

You can find the key file data in the passwords page.
