FROM  gitlab-registry.internal.sanger.ac.uk/sanger-pathogens/docker-images/pathogens-base:0.2
ARG   DEBIAN_FRONTEND=noninteractive

# miniconda version must provide python version required by PopPUNK (2.4.0 requires python 3.9)
ARG   MINICONDA_VERSION='py39_4.9.2'
ARG   MINICONDA_URL="https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh"
ARG   MINICONDA_DIR='/opt/miniconda3'

RUN   apt-get update -qq -y \
      && apt-get install -qq -y wget unzip

# remove python as we need the conda-installed version to satisfy PopPUNK dependencies
RUN   apt-get remove -y python python3

# miniconda, with required python version
RUN   MINICONDA_INSTALL_SCRIPT='/tmp/miniconda.sh'                                                                                     && \
      apt-get install -y curl                                                                                                          && \
      curl -fsSL "https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" > "${MINICONDA_INSTALL_SCRIPT}" && \
      chmod +x "${MINICONDA_INSTALL_SCRIPT}"                                                                                           && \
      "${MINICONDA_INSTALL_SCRIPT}" -b -p "${MINICONDA_DIR}"                                                                           && \
      rm "${MINICONDA_INSTALL_SCRIPT}"

ENV   PATH "${MINICONDA_DIR}/bin:${PATH}"

# PopPUNK and pp-sketchlib
ARG   TAG='2.4.0'
ARG   PP_SKETCHLIB_VERSION='1.7.4'
RUN   conda config --add channels defaults      && \
      conda config --add channels bioconda      && \
      conda config --add channels conda-forge   && \
      conda install poppunk=="${TAG}" pp-sketchlib="${PP_SKETCHLIB_VERSION}"
