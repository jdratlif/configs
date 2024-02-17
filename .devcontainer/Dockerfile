FROM python:3.12

RUN apt update -y && apt install -y ansible-core ansible-lint bash-completion

# Create the docker user
RUN useradd -m -s /bin/bash docker

# add prompt
COPY prompt.sh /etc/profile.d
RUN echo ". /etc/profile.d/prompt.sh" >> /home/docker/.bashrc
