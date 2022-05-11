# ----------------------------------------------------
FROM quay.io/rockylinux/rockylinux:8.5 AS slurm-base
# ----------------------------------------------------

# Install dependencies
RUN dnf install -y \
  dnf-plugins-core \
  epel-release \
  && dnf config-manager --add-repo https://csquare:VCyV78sQ@yum.csquare.run/yum.repo \
  && dnf install -y \
  slurm \
  sssd \
  xz \
  authselect \
  && dnf clean all

# Munge & Slurm configurations
RUN mkdir -p /run/munge && chown munge:munge /run/munge \
  && mkdir -p /var/run/munge && chown munge:munge /var/run/munge \
  && mkdir -p /var/{spool,run}/{slurmd,slurmctl,slurmdb}/ \
  && mkdir -p /var/log/{slurm,slurmctl,slurmdb}/
ENV SLURM_CONF=/etc/slurm/slurm.conf

RUN authselect select sssd --force

COPY s6-rc.d/munge/ /etc/s6-overlay/s6-rc.d/munge/
COPY s6-rc.d/sss/ /etc/s6-overlay/s6-rc.d/sss/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/munge \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/sss

ENV S6_OVERLAY_VERSION=3.1.0.1

RUN curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz -o /tmp/s6-overlay-noarch.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz \
  && curl -fsSL https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz -o /tmp/s6-overlay-x86_64.tar.xz \
  && tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz \
  && rm -rf /tmp/*

# ----------------------------------------------------
FROM slurm-base AS slurm-login
# ----------------------------------------------------

# Install dependencies
RUN dnf config-manager --set-enabled powertools \
  && dnf install -y \
  zsh \
  nvslurm-plugin-pyxis \
  slurm-contribs \
  slurm-libpmi \
  slurm-pam_slurm \
  pam_mkslurmuser \
  s3cmd \
  pmix2 \
  pmix3 \
  pmix4 \
  hwloc \
  hwloc-libs \
  hwloc-devel \
  screen \
  tmux \
  git \
  openssh-server \
  openssh-clients \
  openldap-clients \
  wget \
  vim \
  sudo \
  htop \
  procps \
  net-tools \
  bind-utils \
  iproute \
  netcat \
  rsync \
  && dnf clean all

RUN sed -Ei 's|UMASK\t+[0-9]+|UMASK\t\t077|g' /etc/login.defs \
  && authselect enable-feature with-sudo \
  && echo 'session     optional      pam_mkslurmuser.so' >> /etc/pam.d/system-auth \
  && echo 'session     optional      pam_mkhomedir.so skel=/etc/skel/ umask=0077' >> /etc/pam.d/system-auth \
  && echo 'session     optional      pam_mkslurmuser.so' >> /etc/pam.d/password-auth \
  && echo 'session     optional      pam_mkhomedir.so skel=/etc/skel/ umask=0077' >> /etc/pam.d/password-auth \
  && setcap cap_net_admin,cap_net_raw+p /usr/bin/ping \
  && echo 'umask 0027' >> /etc/profile

COPY s6-rc.d/ssh/ /etc/s6-overlay/s6-rc.d/ssh/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/ssh

EXPOSE 22/tcp

ENTRYPOINT ["/init"]

# -------------------------------------------------------
FROM slurm-base AS slurm-controller
# -------------------------------------------------------

RUN dnf config-manager --add-repo https://www.beegfs.io/release/beegfs_7.2.6/dists/beegfs-rhel8.repo \
  && dnf config-manager --set-enabled powertools \
  && dnf install -y \
  slurm-slurmctld \
  nvslurm-plugin-pyxis \
  slurm-contribs \
  slurm-libpmi \
  slurm-pam_slurm \
  jobcomp-report \
  pmix2 \
  pmix3 \
  pmix4 \
  hwloc \
  hwloc-libs \
  hwloc-devel \
  pdsh \
  pdsh-rcmd-ssh \
  sudo \
  beeond \
  jq \
  openssh-clients \
  net-tools \
  bind-utils \
  iproute \
  which \
  procps \
  screen \
  && dnf clean all

# Beeond configuration
RUN echo "slurm ALL=(root) NOPASSWD:/usr/bin/beeond" >> /etc/sudoers \
  && mkdir -p /root/.ssh \
  && chmod 700 /root/.ssh \
  && echo -e "Host *\n\
  StrictHostKeyChecking no\n" \
  > /root/.ssh/config \
  && chmod 600 /root/.ssh/config \
  && mkdir -p /etc/pdsh \
  && echo "ssh" > /etc/pdsh/rcmd_default

COPY s6-rc.d/slurmctl/ /etc/s6-overlay/s6-rc.d/slurmctl/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/slurmctl

EXPOSE 6817/tcp

VOLUME [ "/var/spool/slurmctl" ]

ENTRYPOINT ["/init"]

# -------------------------------------------------------
FROM slurm-base AS slurm-rest
# -------------------------------------------------------

RUN dnf install -y \
  slurm-slurmrestd \
  && dnf clean all

# API user
RUN groupadd -r api && useradd --no-log-init -r -g api api

COPY s6-rc.d/slurmrest/ /etc/s6-overlay/s6-rc.d/slurmrest/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/slurmrest

EXPOSE 6820/tcp

ENTRYPOINT ["/init"]

# -------------------------------------------------------
FROM slurm-base AS slurm-db
# -------------------------------------------------------

RUN dnf install -y \
  slurm-slurmdbd \
  && dnf clean all

COPY s6-rc.d/slurmdb/ /etc/s6-overlay/s6-rc.d/slurmdb/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/slurmdb

EXPOSE 6819/tcp

ENTRYPOINT ["/init"]

# ----------------------------------------------------
FROM slurm-base AS slurm-compute
# ----------------------------------------------------

# Install dependencies
RUN dnf install -y \
  slurm-slurmd \
  && dnf clean all

EXPOSE 6818/tcp 6820/tcp

COPY s6-rc.d/slurm/ /etc/s6-overlay/s6-rc.d/slurm/
RUN mkdir -p /etc/s6-overlay/s6-rc.d/user/contents.d/ \
  && touch /etc/s6-overlay/s6-rc.d/user/contents.d/slurm

ENTRYPOINT ["/init"]
