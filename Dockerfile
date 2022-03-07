## Based on PRP RStudio, modified by Youngsu Kim youngsu.kim@csusb
ARG OWNER=jupyter
ARG BASE_CONTAINER=$OWNER/minimal-notebook
FROM $BASE_CONTAINER

# LABEL maintainer="PRP"

USER root

## From https://cloud.r-project.org/bin/linux/ubuntu/ modified for Dockerfile
# update indices
# RUN apt update -qq --yes && \
# install two helper packages we need
    # apt install --no-install-recommends software-properties-common dirmngr --yes && \
# add the signing key (by Michael Rutter) for these repos
# To verify key, run gpg --show-keys /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc 
# Fingerprint: 298A3A825C0D65DFD57CBB651716619E084DAB9
    # wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
# add the R 4.0 repo from CRAN -- adjust 'focal' to 'groovy' or 'bionic' as needed
    # add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/"

# R pre-requisites
RUN apt-get update --yes && \
    apt install --yes \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    r-cran-irkernel && \
    apt install --no-install-recommends software-properties-common dirmngr --yes && \
    wget -qO- https://cloud.r-project.org/bin/linux/ubuntu/marutter_pubkey.asc | tee -a /etc/apt/trusted.gpg.d/cran_ubuntu_key.asc && \
    add-apt-repository "deb https://cloud.r-project.org/bin/linux/ubuntu $(lsb_release -cs)-cran40/" && \
    apt install --yes \
    r-base && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    apt-get update --yes && \
    pip install git+https://github.com/jupyterhub/jupyter-rsession-proxy.git jupyter-server-proxy && \
    jupyter labextension install @jupyterlab/server-proxy

RUN wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.02.0-443-amd64.deb && \
    apt install -y ./rstudio-server-*.deb && \
    rm -f rstudio-server-*.deb

USER ${NB_UID}

