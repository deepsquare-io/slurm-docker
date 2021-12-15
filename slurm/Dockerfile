FROM ubuntu:18.04

# Install dependencies
RUN apt update && apt install -y \
  gnupg \
  sssd \
  libnuma-dev \
  libhwloc-dev \
  libhttp-parser-dev \
  libyaml-dev \
  libreadline-dev \
  libpam-sss \
  libnss-sss \
  munge \
  curl \
  bsdmainutils \
  libmysqlclient-dev \
  libcurl3-gnutls \
  netcat \
  ssh \
  jq \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O- http://apt.csquare.gcloud:8080/gpg.key | tee -a /usr/share/keyrings/csquare-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/csquare-keyring.gpg] http://apt.csquare.gcloud:8080 unstable main contrib non-free" | tee -a /etc/apt/sources.list.d/csquare.list
RUN apt-get update && apt install -y hpc-essentials && rm -rf /var/lib/apt/lists/*

COPY configure_libjwt_path.sh /
RUN bash /configure_libjwt_path.sh && ldconfig && rm -f /configure_libjwt_path.sh

COPY lib/jobcomp/ /usr/local/lib/slurm

# Munge & Slurm configurations
RUN mkdir /run/munge && chown munge: /run/munge
ENV SLURM_CONF=/etc/slurm/slurm.conf

EXPOSE 6817/tcp 6818/tcp 6819/tcp 6820/tcp

# Set up entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]
