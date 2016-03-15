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
  sudo \
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
RUN echo "[backup]\nrecipe = collective.recipe.backup\nbackup_blobs = false\n" >> /src/Zope/buildout.cfg
RUN echo "[repozo]\nrecipe = zc.recipe.egg\neggs = ZODB3\nscripts = repozo\n" >> /src/Zope/buildout.cfg
RUN cd /src/Zope \
    && python bootstrap.py \
    && python bin/buildout

RUN cd /src/Zope && python bin/buildout install repozo
RUN cd /src/Zope && python bin/buildout install backup

RUN ln -s /usr/lib/`uname -i`-linux-gnu/libjpeg.so /usr/lib
RUN ln -s /usr/lib/`uname -i`-linux-gnu/libfreetype.so /usr/lib
RUN ln -s /usr/lib/`uname -i`-linux-gnu/libz.so /usr/lib

COPY run /runzope
COPY entry.sh /entry.sh
COPY zope.conf /zope.conf

EXPOSE 8080
VOLUME /zope
ENV ZOPE_HOME /zope

ENTRYPOINT ["/entry.sh"]
CMD ["/runzope"]
