FROM ubuntu:18.04
COPY install.pl /
RUN perl install.pl apt git
COPY replink.pl /
RUN chmod +x /*.pl
ONBUILD ARG C4UID
ONBUILD RUN /install.pl useradd $C4UID
ONBUILD USER c4
