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
RUN mkdir -p /run/munge && chown munge: /run/munge
ENV SLURM_CONF=/etc/slurm/slurm.conf

EXPOSE 6817/tcp 6818/tcp 6819/tcp 6820/tcp

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Set up entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
