FROM ubuntu:latest

ENV DEBIAN_FRONTEND "noninteractive"

# https://jdftx.org/Dependencies.html
RUN apt update \
    && apt install -y \
        g++ \
        cmake \
        build-essential \
        git \
        vim \
        curl \
        unzip \
        gnuplot \
        octave \
        libgsl0-dev \
        libopenmpi-dev \
        openmpi-bin \
        openmpi-doc \
        libfftw3-dev \
        libatlas-base-dev \
        liblapack-dev \
        openssl \
        libssl-dev \
        libreadline-dev \
        ncurses-dev \
        bzip2 \
        zlib1g-dev \
        libbz2-dev \
        libffi-dev \
        libopenblas-dev \
        liblapack-dev \
        libsqlite3-dev \
        liblzma-dev \
        libpng-dev \
        libfreetype6-dev

WORKDIR /usr/local/src

## jdftx installation
RUN curl https://github.com/shankar1729/jdftx/archive/refs/tags/v1.6.0.zip -O -L
RUN unzip v1.6.0.zip \
    && rm -rf v1.6.0.zip
RUN mkdir build \
    && cd build \
    && cmake ../jdftx-1.6.0/jdftx/ \
    && make -j4 \
    && make install

RUN curl https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tgz -O -L \
    && tar zxf Python-3.9.4.tgz \
    && rm -rf Python-3.9.4.tgz \
    && cd Python-3.9.4 \
    && ./configure \
    && make \
    && make altinstall \
    && ln -s /usr/local/bin/python3.9 /usr/local/bin/python \
    && ln -s /usr/local/bin/pip3.9 /usr/local/bin/pip
ENV PYTHONIOENCODING "utf-8"
RUN pip install pip -U \
    && pip install \
        numpy \
        scipy \
        matplotlib \
        sympy \
        pandas \
        tqdm \
        Pillow \
        ase \
        joblib \
        Cython \
        fire

ENV PATH "/usr/local/src/jdftx-1.6.0/jdftx/scripts:$PATH"
ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1

COPY ./pslibrary.1.0.0/pbe /usr/local/src/build/pseudopotentials/pbe
COPY ./pslibrary.1.0.0/rel-pbe /usr/local/src/build/pseudopotentials/rel-pbe

WORKDIR /root
