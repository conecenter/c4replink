FROM ubuntu:18.04
COPY install.pl /
ARG C4UID
RUN perl install.pl useradd $C4UID
RUN perl install.pl apt curl libjson-xs-perl openssh-client rsync git
RUN perl install.pl curl https://github.com/fatedier/frp/releases/download/v0.21.0/frp_0.21.0_linux_amd64.tar.gz
COPY replink.pl /
COPY frpc.pl /
RUN chmod +x /replink.pl /frpc.pl
USER c4