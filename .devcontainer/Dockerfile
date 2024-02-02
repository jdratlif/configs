FROM python:3.12

RUN apt update -y && apt install -y ansible-core ansible-lint bash-completion
COPY prompt.sh /etc/profile.d/
COPY root.bashrc /root/.bashrc
