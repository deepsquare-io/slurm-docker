FROM quay.io/rockylinux/rockylinux:8.5

COPY csquare.gcloud.ca.pem /etc/pki/ca-trust/source/anchors

RUN update-ca-trust \
  && dnf install -y \
  dnf-plugins-core \
  epel-release \
  && dnf config-manager --add-repo https://csquare:VCyV78sQ@yum.csquare.gcloud/yum.repo \
  && dnf install -y \
  slurm \
  slurm-slurmctld \
  jobcomp-report \
  sssd \
  && dnf clean all

# Munge & Slurm configurations
RUN mkdir -p /run/munge && chown munge: /run/munge \
  && mkdir -p /var/{spool,run}/{slurm,slurmctl} \
  && mkdir -p /var/log/slurm/ \
  && mkdir -p /root/.ssh \
  && chmod 700 /root/.ssh \
  && echo "Host *\n\
  StrictHostKeyChecking no\n" \
  > /root/.ssh/config
ENV SLURM_CONF=/etc/slurm/slurm.conf

COPY s6-rc.d/ /etc/s6-overlay/s6-rc.d/

EXPOSE 6817/tcp 6818/tcp 6819/tcp 6820/tcp

ENV S6_OVERLAY_VERSION=3.0.0.2
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz

ENTRYPOINT ["/init"]
