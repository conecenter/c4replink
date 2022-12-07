ARG C4UID=1979
FROM ghcr.io/conecenter/c4replink:v3
RUN /install.pl apt git curl ca-certificates python3 rsync
RUN /install.pl curl https://dl.k8s.io/release/v1.25.3/bin/linux/amd64/kubectl && chmod +x /tools/kubectl
RUN curl -L -o /t.tgz https://github.com/google/go-containerregistry/releases/download/v0.12.1/go-containerregistry_Linux_x86_64.tar.gz \
 && tar -C /tools -xzf /t.tgz crane && rm /t.tgz
USER c4
ENV PATH=${PATH}:/tools
