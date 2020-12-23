FROM ubuntu:18.04
COPY install.pl /
RUN perl install.pl apt libjson-xs-perl git
COPY replink.pl /
RUN chmod +x /install.pl /replink.pl \
 && /install.pl useradd 1979 \
 && mkdir -p /c4repo && chown c4:c4 /c4repo
COPY --chown=c4:c4 .tmp-ssh/* /c4/.ssh/
ENV C4REPO_PARENT_DIR=/c4repo
