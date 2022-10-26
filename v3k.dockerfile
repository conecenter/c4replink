ARG C4UID=1979
FROM ghcr.io/conecenter/c4replink:v3
RUN /install.pl apt git curl ca-certificates python3
RUN /install.pl curl https://dl.k8s.io/release/v1.25.3/bin/linux/amd64/kubectl && chmod +x /tools/kubectl
USER c4
ENV PATH=${PATH}:/tools