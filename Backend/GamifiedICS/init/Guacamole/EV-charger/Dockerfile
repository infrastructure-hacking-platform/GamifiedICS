FROM rastasheep/ubuntu-sshd

RUN apt update && apt install sudo && apt install -y python3 python3-pip && python3 -m pip install flask pymodbus

RUN mkdir -p /scripts
COPY scripts/install_mbpoll.sh /scripts

RUN chmod +x /scripts/install_mbpoll.sh
RUN /scripts/install_mbpoll.sh

#CMD ["/usr/sbin/sshd", "-D"]
