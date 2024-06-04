FROM mcr.microsoft.com/devcontainers/python:1-3.12-bullseye

# install python packages
RUN python3 -m pip install 'ansible-core<2.17' ansible-lint pyyaml

# enable git bash completion and preserve bash history
RUN echo "source /usr/share/bash-completion/completions/git" >> ~/.bashrc
