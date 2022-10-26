FROM ubuntu:22.04
COPY install.pl replink.pl /
RUN chmod +x /*.pl
ONBUILD ARG C4UID
ONBUILD RUN /install.pl useradd $C4UID
