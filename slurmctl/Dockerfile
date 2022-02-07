FROM quay.io/rockylinux/rockylinux:8.5

COPY csquare.gcloud.ca.pem /etc/pki/ca-trust/source/anchors

# Install dependencies
RUN update-ca-trust \
  && dnf install -y \
  dnf-plugins-core \
  epel-release \
  && dnf config-manager --add-repo https://csquare:VCyV78sQ@yum.csquare.gcloud/yum.repo \
  && dnf install -y \
  slurm \
  slurm-slurmctld \
  sssd \
  xz \
  && dnf clean all

# Munge & Slurm configurations
RUN mkdir -p /run/munge && chown munge:munge /run/munge \
  && mkdir -p /var/run/munge && chown munge:munge /var/run/munge \
  && mkdir -p /var/{spool,run}/slurmctl \
  && mkdir -p /var/log/slurmctl/
ENV SLURM_CONF=/etc/slurm/slurm.conf

EXPOSE 6817/tcp

ENV S6_OVERLAY_VERSION=3.0.0.2
COPY s6-rc.d/ /etc/s6-overlay/s6-rc.d/
RUN curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz -o /tmp/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz -o /tmp/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz \
  && rm -rf /tmp/*

ENTRYPOINT ["/init"]
