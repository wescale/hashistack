FROM debian:12-slim AS hs-installer
WORKDIR /opt/hashistack
COPY . ./
RUN apt update \
    && apt install -y make sudo python3-apt apt-transport-https \
    && rm -rf /usr/lib/python3.11/EXTERNALLY-MANAGED \
    && make install-requirements prepare \
    && touch /opt/hashistack/.is_container

FROM hs-installer
WORKDIR /opt/hashistack
SHELL ["/bin/bash", "-c"]
ENV TF_PLUGIN_CACHE_DIR="/root/.terraform.d/plugin-cache"
RUN sh ./docker/init.sh && \
    mkdir ~/.ssh
RUN make stage_99
