FROM ubuntu:18.04

# Install dependencies
RUN apt update && apt install -y \
  gnupg \
  sssd \
  libyaml-dev \
  libreadline-dev \
  libpam-sss \
  libnss-sss \
  munge \
  curl \
  bsdmainutils \
  libmysqlclient-dev \
  libcurl3-gnutls \
  && rm -rf /var/lib/apt/lists/*

RUN curl -L http://apt.csquare.gcloud:8080/gpg.key | apt-key add -
RUN echo "deb http://apt.csquare.gcloud:8080 unstable main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && apt install -y hpc-essentials && rm -rf /var/lib/apt/lists/*

COPY configure_libjwt_path.sh /
RUN bash /configure_libjwt_path.sh && ldconfig && rm -f /configure_libjwt_path.sh

# Munge & Slurm configurations
RUN mkdir /run/munge && chown munge: /run/munge
ENV SLURM_CONF=/etc/slurm/slurm.conf

EXPOSE 6817/tcp 6820/tcp

# Set up entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]
