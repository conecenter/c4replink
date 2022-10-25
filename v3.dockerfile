FROM ubuntu:22.04
COPY install.pl replink.pl /
RUN chmod +x /*.pl
RUN /install.pl apt git curl ca-certificates python3
RUN /install.pl curl https://dl.k8s.io/release/v1.25.3/bin/linux/amd64/kubectl && chmod +x /tools/kubectl
ENV PATH=${PATH}:/tools
