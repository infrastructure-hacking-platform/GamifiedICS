FROM debian:bookworm

USER root
WORKDIR /root/

RUN apt-get update && \
    apt-get -y install git python3 python3-pip python3-venv autoconf bison build-essential pkg-config flex automake libtool make sudo sqlite3 cmake

RUN useradd --create-home --shell /bin/bash openplc
RUN adduser openplc sudo && \
    echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER openplc
WORKDIR /home/openplc

RUN git clone https://github.com/thiagoralves/OpenPLC_v3.git

USER root

RUN python3 -m venv /home/openplc/OpenPLC_v3/.venv
RUN /home/openplc/OpenPLC_v3/.venv/bin/pip install --upgrade pip
RUN /home/openplc/OpenPLC_v3/.venv/bin/pip install flask flask-login pyserial "pymodbus==2.5.3"

USER openplc

WORKDIR /home/openplc/OpenPLC_v3
RUN sudo ./install.sh custom

RUN sudo apt-get clean

RUN mkdir /home/openplc/scripts

COPY run.sh /home/openplc
RUN sudo chmod +x /home/openplc/run.sh

EXPOSE 502 8080 20000 43628

CMD ["/home/openplc/run.sh"]