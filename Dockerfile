FROM hotio/base

ARG DEBIAN_FRONTEND="noninteractive"

ENV APP="Bazarr"
EXPOSE 6767
HEALTHCHECK --interval=60s CMD curl -fsSL http://localhost:6767 || exit 1

# install packages
RUN apt update && \
    apt install -y --no-install-recommends --no-install-suggests \
        python-pip && \
    pip install gevent && \
# clean up
    apt autoremove -y && \
    apt clean && \
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

# install app
# https://github.com/morpheus65535/bazarr/releases
RUN curl -fsSL "https://github.com/morpheus65535/bazarr/archive/v0.7.1.tar.gz" | tar xzf - -C "${APP_DIR}" --strip-components=1 && \
    chmod -R u=rwX,go=rX "${APP_DIR}"

COPY root/ /