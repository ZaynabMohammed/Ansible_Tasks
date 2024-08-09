FROM ubuntu
RUN passwd -d root
# RUN useradd ansible
# RUN echo 'ansible: 123' | chpasswd
RUN useradd -m devops
RUN echo 'devops: 123' | chpasswd
RUN apt-get update
RUN apt-get install ssh -y
RUN apt install sudo -y
RUN usermod -aG sudo devops
RUN echo "PermitEmptyPasswords yes" >> /etc/ssh/sshd_config
RUN echo "PermitRootLogin yes" >> /etc/ssh/sshd_config
ENTRYPOINT service ssh start && bash
