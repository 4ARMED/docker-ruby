FROM ubuntu:16.04
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
                         nodejs \
                         npm \
                         libcurl4-openssl-dev \
                         bison \
                         ruby

ENV RUBY_MAJOR 2.3
ENV RUBY_VERSION 2.3.4
ENV RUBY_SHA256 98e18f17c933318d0e32fed3aea67e304f174d03170a38fd920c4fbe49fec0c3

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
