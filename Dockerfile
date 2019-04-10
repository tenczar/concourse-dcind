FROM vmware/photon:2.0

ENV DOCKER_CHANNEL=stable \
    DOCKER_VERSION=17.12.1-ce \
    DOCKER_COMPOSE_VERSION=1.19.0 \
    DOCKER_SQUASH=0.2.0

# Install Docker, Docker Compose, Docker Squash
RUN tdnf install -y \
        shadow \
        bash \
        curl \
        git \
        gawk \
        tar \
        gzip \
        make \
        device-mapper \
        python3 \
        python3-pip \
        iproute2 \
        iptables \
        ca-certificates \
        && \
    tdnf clean all && \
    curl -fL "https://download.docker.com/linux/static/${DOCKER_CHANNEL}/x86_64/docker-${DOCKER_VERSION}.tgz" | tar zx && \
    mv /docker/* /bin/ && chmod +x /bin/docker* && \
    pip3 install setuptools && \
    pip3 install docker-compose==${DOCKER_COMPOSE_VERSION} && \
    curl -fL "https://github.com/jwilder/docker-squash/releases/download/v${DOCKER_SQUASH}/docker-squash-linux-amd64-v${DOCKER_SQUASH}.tar.gz" | tar zx && \
    mv /docker-squash* /bin/ && chmod +x /bin/docker-squash* && \
    rm -rf /var/cache/apk/* && \
    rm -rf /root/.cache

RUN git clone https://github.com/bats-core/bats-core.git && cd bats-core && ./install.sh /usr/local \
    cd .. && rm -rf bats-core

RUN curl -OL https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64 && \
    chmod +x jq-linux64 && mv jq-linux64 /usr/local/bin/jq

RUN curl -OL https://dl.minio.io/client/mc/release/linux-amd64/mc && \
    chmod +x ./mc && mv ./mc /usr/local/bin/mc

COPY entrypoint.sh /bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
