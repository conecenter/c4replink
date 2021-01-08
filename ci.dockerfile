FROM c4replink:v2
COPY --chown=c4:c4 .tmp-ssh/* /c4/.ssh/
