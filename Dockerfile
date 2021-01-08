FROM ubuntu:18.04
COPY install.pl /
RUN perl install.pl apt git
COPY replink.pl /
ARG C4UID
RUN chmod +x /*.pl \
 && /install.pl useradd $C4UID
USER c4
