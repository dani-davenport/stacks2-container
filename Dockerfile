FROM ubuntu:24.04

ARG STACKS_VERSION=2.68

LABEL org.opencontainers.image.title="Stacks RAD-seq container"
LABEL org.opencontainers.image.description="Stacks 2.68 with Bash and common command-line utilities"
LABEL org.opencontainers.image.source="https://github.com/${GITHUB_REPOSITORY}"
LABEL org.opencontainers.image.version="${STACKS_VERSION}"

ENV DEBIAN_FRONTEND=noninteractive
ENV PATH="/usr/local/bin:${PATH}"

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash \
    build-essential \
    ca-certificates \
    curl \
    wget \
    perl \
    gzip \
    pigz \
    tar \
    coreutils \
    findutils \
    grep \
    sed \
    gawk \
    zlib1g-dev \
    libbz2-dev \
    liblzma-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libgsl-dev \
    && rm -rf /var/lib/apt/lists/*

ARG STACKS_VERSION=2.68

COPY stacks-${STACKS_VERSION}.tar.gz /tmp/

RUN cd /tmp \
    && tar -xzf "stacks-${STACKS_VERSION}.tar.gz" \
    && cd "stacks-${STACKS_VERSION}" \
    && ./configure \
    && make -j"$(nproc)" \
    && make install \
    && rm -rf \
        "/tmp/stacks-${STACKS_VERSION}" \
        "/tmp/stacks-${STACKS_VERSION}.tar.gz"

WORKDIR /data

RUN process_radtags --help

CMD ["/bin/bash"]
