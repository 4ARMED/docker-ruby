FROM ubuntu:14.04
MAINTAINER Marc Wickenden <marc@4armed.com>

# Update package repo
RUN apt-get -yqq update && apt-get install -yqq autoconf \
                         build-essential \
                         libreadline-dev \
                         libpq-dev \
                         libssl-dev \
                         libxml2-dev \
                         libyaml-dev \
                         libffi-dev \
                         zlib1g-dev \
                         git-core \
                         curl \
                         node \
                         libcurl4-openssl-dev \
                         bison \
                         ruby

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.3
ENV RUBY_SHA256 241408c8c555b258846368830a06146e4849a1d58dcaf6b14a3b6a73058115b7

RUN mkdir -p /usr/src/ruby
RUN cd /usr/src/ruby && \
    curl -OSL "http://cache.ruby-lang.org/pub/ruby/$RUBY_MAJOR/ruby-$RUBY_VERSION.tar.gz" && \
    $(test "$(sha256sum ruby-${RUBY_VERSION}.tar.gz |cut -d' ' -f1)" = "${RUBY_SHA256}" || \
    $(>&2 echo "[\!] Checksum error"; exit 1)) && \
    tar xzf ruby-${RUBY_VERSION}.tar.gz --strip-components=1 && \
    rm ruby-${RUBY_VERSION}.tar.gz && \
    autoconf && ./configure --disable-install-doc && make -j"$(nproc)" && \
    apt-get purge -y --auto-remove bison \
                                   ruby && \
    make install && \
    rm -rf /usr/src/ruby && \
    rm -rf /var/lib/apt/lists/* 
RUN gem install bundler
