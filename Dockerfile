FROM ubuntu:15.10
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apt-get update && apt-get install -y \
  bzr \
  build-essential \
  curl \
  git \
  libfreetype6 \
  libfreetype6-dev \
  libjpeg-dev \
  locales \
  mercurial \
  wget \
  python \
  python-dev \
  python-imaging \
  python-pip \
  zip \
  zlib1g-dev \
  --no-install-recommends \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/* 

ENV LC_ALL C.UTF-8

RUN mkdir /src

ENV ZOPEVER 2.13.24
RUN curl -sSL https://github.com/zopefoundation/Zope/archive/$ZOPEVER.tar.gz \
    | tar xzC /src \
    && mv /src/Zope-$ZOPEVER /src/Zope
RUN cd /src/Zope \
    && python bootstrap.py \
    && python bin/buildout 

RUN ln -s /usr/lib/`uname -i`-linux-gnu/libjpeg.so /usr/lib
RUN ln -s /usr/lib/`uname -i`-linux-gnu/libfreetype.so /usr/lib
RUN ln -s /usr/lib/`uname -i`-linux-gnu/libz.so /usr/lib

RUN useradd zope
RUN echo "zope:zope" | chpasswd

COPY run /src/run
COPY zope.conf /src/zope.conf

EXPOSE 8080
VOLUME /zope
CMD /src/run
