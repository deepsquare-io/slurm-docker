# ----------------------------------------------------
FROM quay.io/rockylinux/rockylinux:8.5 AS slurm-base
# ----------------------------------------------------

COPY csquare.gcloud.ca.pem /etc/pki/ca-trust/source/anchors

# Install dependencies
RUN update-ca-trust \
  && dnf install -y \
  dnf-plugins-core \
  epel-release \
  && dnf config-manager --add-repo https://csquare:VCyV78sQ@yum.csquare.gcloud/yum.repo \
  && dnf install -y \
  slurm \
  sssd \
  xz \
  && dnf clean all

# Munge & Slurm configurations
RUN mkdir -p /run/munge && chown munge:munge /run/munge \
  && mkdir -p /var/run/munge && chown munge:munge /var/run/munge \
  && mkdir -p /var/{spool,run}/{slurmd,slurmctl,slurmdb}/ \
  && mkdir -p /var/log/{slurm,slurmctl,slurmdb}/
ENV SLURM_CONF=/etc/slurm/slurm.conf

ENV S6_OVERLAY_VERSION=3.0.0.2

COPY s6-rc.d/munge/ /etc/s6-overlay/s6-rc.d/munge/
COPY s6-rc.d/sss/ /etc/s6-overlay/s6-rc.d/sss/
COPY s6-rc.d/user/contents.d/munge s6-rc.d/user/contents.d/sss /etc/s6-overlay/s6-rc.d/user/contents.d/

VOLUME [ "/secrets/munge", "/secrets/sssd" ]

RUN curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz -o /tmp/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch-${S6_OVERLAY_VERSION}.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz -o /tmp/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-x86_64-${S6_OVERLAY_VERSION}.tar.xz \
  && rm -rf /tmp/*

# ----------------------------------------------------
FROM slurm-base AS slurm-head
# ----------------------------------------------------

# Install dependencies
RUN dnf install -y \
  zsh \
  nvslurm-plugin-pyxis \
  slurm-contribs \
  slurm-libpmi \
  slurm-pam_slurm \
  s3cmd \
  screen \
  tmux \
  oddjob \
  oddjob-mkhomedir \
  git \
  openssh-server \
  openssh-clients \
  wget \
  vim \
  && dnf clean all

COPY s6-rc.d/ssh/ /etc/s6-overlay/s6-rc.d/ssh/
COPY s6-rc.d/user/contents.d/slurm s6-rc.d/user/contents.d/ssh /etc/s6-overlay/s6-rc.d/user/contents.d/

EXPOSE 22/tcp

VOLUME [ "/secrets/ssh", "/secrets/slurm" ]

ENTRYPOINT ["/init"]

# -------------------------------------------------------
FROM slurm-base AS slurm-slurmctld
# -------------------------------------------------------

RUN dnf install -y \
  slurm-slurmctld \
  && dnf clean all

COPY s6-rc.d/slurmctl/ /etc/s6-overlay/s6-rc.d/slurmctl/
COPY s6-rc.d/user/contents.d/slurmctl /etc/s6-overlay/s6-rc.d/user/contents.d/

EXPOSE 6817/tcp

VOLUME [ "/secrets/slurm" ]

ENTRYPOINT ["/init"]
