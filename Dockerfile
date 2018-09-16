FROM ubuntu:18.04
MAINTAINER Ulrich Schreiner <ulrich.schreiner@gmail.com>

RUN apt-get update && apt-get install -y \
  build-essential \
  curl \
  git \
  libfreetype6 \
  libfreetype6-dev \
  libjpeg-dev \
  libxml2-dev \
  libxslt1-dev \
  locales \
  wget \
  python \
  python-dev \
  python-pil \
  python-pip \
  python-wheel \
  sudo \
  zip \
  zlib1g-dev \
  --no-install-recommends \
  && pip2 install -U setuptools pip \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LC_ALL C.UTF-8

ENV ZOPEVERSION 2.13.28
RUN curl -sSL https://github.com/zopefoundation/Zope/archive/$ZOPEVERSION.tar.gz \
      | tar xzC / \
    && mv /Zope-$ZOPEVERSION /Zope \
    && pip2 install -r /Zope/requirements.txt \
    && pip2 install Zope2==$ZOPEVERSION \
    && rm -rf /Zope* \
    && ln -s /usr/lib/`uname -i`-linux-gnu/libjpeg.so /usr/lib \
    && ln -s /usr/lib/`uname -i`-linux-gnu/libfreetype.so /usr/lib \
    && ln -s /usr/lib/`uname -i`-linux-gnu/libz.so /usr/lib \
    && mkdir /zope

COPY run /runzope
COPY entry.sh /entry.sh
COPY zope.conf /zope.conf

EXPOSE 8080
VOLUME /zope
ENV ZOPE_HOME /zope

ENTRYPOINT ["/entry.sh"]
CMD ["/runzope"]
