FROM ubuntu

# Install dependencies
RUN apt update && apt install -y sssd libpam-sss libnss-sss munge libjwt-dev

# Add and install Slurm
COPY slurm.deb /
RUN dpkg -i /slurm.deb && rm -f /slurm.deb

# Munge & Slurm configurations
RUN mkdir /run/munge && chown munge: /run/munge
ENV SLURM_CONF=/etc/slurm/slurm.conf

# Set up entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["bash", "/entrypoint.sh"]