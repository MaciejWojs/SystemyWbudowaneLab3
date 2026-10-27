FROM mcr.microsoft.com/vscode/devcontainers/base:ubuntu
COPY --from=ghcr.io/typst/typst /bin/typst /usr/local/bin/typst
COPY upload.sh /usr/local/bin/upload.sh

RUN chmod 777 /usr/local/bin/upload.sh