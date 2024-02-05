FROM python:3.12

RUN apt update -y && apt install -y ansible-core ansible-lint bash-completion

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=$USER_UID

# Create local user instead of using root
RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m -s /bin/bash $USERNAME
COPY prompt.sh /home/vscode/.bash_aliases
USER $USERNAME
