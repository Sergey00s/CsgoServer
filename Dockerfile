FROM debian:buster-slim


RUN apt-get update && apt-get install -y openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir /var/run/sshd && \
    echo 'root:password' | chpasswd && \
    sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#X11Forwarding yes/X11Forwarding yes/' /etc/ssh/sshd_config && \
    sed -i 's/#X11UseLocalhost yes/X11UseLocalhost no/' /etc/ssh/sshd_config && \
    sed -i 's/#LogLevel INFO/LogLevel VERBOSE/' /etc/ssh/sshd_config && \
    sed -i 's/#SyslogFacility AUTH/SyslogFacility AUTHPRIV/' /etc/ssh/sshd_config && \
    sed -i 's/#AuthorizedKeysFile/AuthorizedKeysFile/' /etc/ssh/sshd_config

EXPOSE 22

CMD ["/usr/sbin/sshd", "-D"]
# Install necessary packages
RUN dpkg --add-architecture i386 \
 && apt-get update \
 && apt-get install -y \
        curl \
        lib32gcc1 \
        lib32stdc++6 \
        libcurl4-gnutls-dev:i386 \
        libfontconfig1:i386 \
        libkrb5-3:i386 \
        libsdl2-2.0-0:i386 \
        libtcmalloc-minimal4:i386 \
        libtbb2:i386 \
        libtbb-dev:i386 \
        tmux \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get install -y adduser

RUN apt-get update && \
    apt-get install -y adduser

RUN apt-get update && apt-get install -y wget





# Configure the server
# Install LinuxGSM

RUN adduser --disabled-password --gecos "" csgoserver

USER csgoserver

WORKDIR /home/csgoserver

RUN mkdir -p /home/csgoserver/lgsm-servers \
    && cd /home/csgoserver/lgsm-servers \
    && wget -O linuxgsm.sh https://linuxgsm.sh \
    && chmod +x linuxgsm.sh \
    && ./linuxgsm.sh csgoserver

# Expose the CS:GO server ports
EXPOSE 27015/tcp
EXPOSE 27015/udp
EXPOSE 27020/tcp
EXPOSE 27020/udp


# Start the server
ENTRYPOINT ["/bin/bash", "csgoserver", "start"]
