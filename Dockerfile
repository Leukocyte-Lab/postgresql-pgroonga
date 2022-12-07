FROM bitnami/postgresql:15.1.0-debian-11-r0

ENV DEBIAN_FRONTEND=noninteractive

# Switch to root user
USER root

# Change working directory
RUN mkdir -p /tmp/pgroonga
WORKDIR /tmp/pgroonga

# Install dependencies packages
RUN install_packages wget build-essential

# Install PGroonga dependencies
RUN wget https://packages.groonga.org/debian/groonga-apt-source-latest-bullseye.deb && \
    install_packages ./groonga-apt-source-latest-bullseye.deb
RUN install_packages libgroonga-dev

# Build PGroonga
ENV PGROONGA_VERSION=2.4.2
RUN wget https://packages.groonga.org/source/pgroonga/pgroonga-${PGROONGA_VERSION}.tar.gz && \
  tar xvf pgroonga-${PGROONGA_VERSION}.tar.gz && \
  cd pgroonga-${PGROONGA_VERSION} && \
  make && \
  make install

# Clean up
RUN apt-get remove -y wget build-essential && \
    apt-get autoremove -y wget build-essential && \
    apt-get update && apt-get upgrade -y && \
    apt-get clean && rm -rf /var/lib/apt/lists /var/cache/apt/archives
WORKDIR /
RUN rm -rf /tmp/pgroonga

# Switch back to non-root user
USER 1001
