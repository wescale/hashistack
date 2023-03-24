FROM debian:11-slim AS hs-installer
WORKDIR /opt/hashistack
COPY . ./
RUN apt update \
    && apt install -y make sudo python3-apt apt-transport-https \
    && make install-requirements prepare

FROM hs-installer
WORKDIR /opt/hashistack
SHELL ["/bin/bash", "-c"]
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"
RUN sh ./docker/init.sh && \
    mkdir ~/.ssh
RUN make stage_99