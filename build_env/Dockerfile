FROM ubuntu

# Install dependencies
RUN apt update && apt install -y gnupg sssd libpam-sss libnss-sss munge curl bsdmainutils libmysqlclient-dev libcurl3-gnutls 
# libjwt-dev installed below through custom package provided in the build environment to make sure it's the same version everywhere in the cluster
# curl is used by the Slurm's Elasticsearch job completion plugin
# bsdmainutils and libmysqlclient-dev required by slurm package definition
# libcurl4-gnutls-dev not necessary and avoided because of possible confusions

RUN curl -L http://apt.csquare.gcloud:8080/gpg.key | apt-key add -
RUN echo "deb http://apt.csquare.gcloud:8080 unstable main contrib non-free" >> /etc/apt/sources.list
RUN apt-get update && apt install -y hpc-essentials && rm -rf /var/lib/apt/lists/*

COPY configure_libjwt_path.sh /
RUN bash /configure_libjwt_path.sh && ldconfig && rm -f /configure_libjwt_path.sh

# Munge & Slurm configurations
RUN mkdir /run/munge && chown munge: /run/munge
ENV SLURM_CONF=/etc/slurm/slurm.conf
RUN cd /usr/lib/x86_64-linux-gnu && ln -s libreadline.so.8 libreadline.so.7
# temp "hack" to force the slurm client utilities like scontrol to use the right version of libreadline distributed w Ubuntu 20

# Set up entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]
