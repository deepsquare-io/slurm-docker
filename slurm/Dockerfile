FROM ubuntu:18.04 as jobcomp-builder

ENV DEBIAN_FRONTEND=noninteractive

WORKDIR /build

RUN apt update \
  && apt install -y \
  ninja-build \
  build-essential \
  libcurl4-openssl-dev \
  wget \
  git \
  && rm -rf /var/lib/apt/lists/*

RUN wget https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.sh -qO /tmp/cmake-install.sh \
  && chmod u+x /tmp/cmake-install.sh \
  && /tmp/cmake-install.sh --skip-license --prefix=/usr/local \
  && rm /tmp/cmake-install.sh

RUN git clone --recurse-submodules --depth 1 https://github.com/csquare-ai/jobcomp_report . \
  && mkdir build \
  && cd build \
  && mkdir /artifacts \
  && cmake .. -G "Ninja" -DCMAKE_INSTALL_PREFIX=/artifacts \
  && ninja -j$(nproc) \
  && ninja install

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
  libcurl4-openssl-dev \
  netcat \
  ssh \
  jq \
  pdsh \
  sudo \
  && rm -rf /var/lib/apt/lists/*

RUN wget -O- http://apt.csquare.gcloud:8080/gpg.key | tee -a /usr/share/keyrings/csquare-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/csquare-keyring.gpg] http://apt.csquare.gcloud:8080 unstable main contrib non-free" | tee -a /etc/apt/sources.list.d/csquare.list
RUN apt update && apt install -y hpc-essentials && rm -rf /var/lib/apt/lists/*

RUN wget -O- https://www.beegfs.io/release/beegfs_7.2.5/gpg/DEB-GPG-KEY-beegfs | gpg --dearmor | tee -a /usr/share/keyrings/beeond-keyring.gpg
RUN echo "deb [arch=amd64 signed-by=/usr/share/keyrings/beeond-keyring.gpg] https://www.beegfs.io/release/beegfs_7.2.5 bionic non-free" | tee -a /etc/apt/sources.list.d/beegfs.list
RUN apt update && apt install -y beeond && rm -rf /var/lib/apt/lists/*

RUN echo "slurm	ALL=(root) NOPASSWD:/usr/bin/beeond" >> /etc/sudoers

COPY configure_libjwt_path.sh /
RUN bash /configure_libjwt_path.sh && ldconfig && rm -f /configure_libjwt_path.sh

COPY --from=jobcomp-builder /artifacts/jobcomp_report.so /usr/local/lib/slurm/jobcomp_report.so
COPY --from=jobcomp-builder /artifacts/jobcomp_report.a /usr/local/lib/slurm/jobcomp_report.a

# Munge & Slurm configurations
RUN mkdir /run/munge && chown munge: /run/munge
ENV SLURM_CONF=/etc/slurm/slurm.conf

EXPOSE 6817/tcp 6818/tcp 6819/tcp 6820/tcp

ENV TINI_VERSION v0.19.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini

# Set up entrypoint
COPY entrypoint.sh /
ENTRYPOINT ["/tini", "--", "/entrypoint.sh"]
