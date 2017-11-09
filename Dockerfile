FROM ubuntu:xenial

MAINTAINER  Andrej Antas <andrej@antas.cz>

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

ENV DEBIAN_FRONTEND noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Set the locale
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen en_US.UTF-8
RUN export LANGUAGE=en_US.UTF-8
RUN export LANG=en_US.UTF-8
RUN export LC_ALL=en_US.UTF-8
RUN locale-gen en_US.UTF-8
RUN dpkg-reconfigure locales

ENV TZ=Europe/Prague
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

## Default Packages
RUN apt-get install -y build-essential
RUN apt-get install -y wget links curl rsync bc git git-core apt-transport-https libxml2 libxml2-dev libcurl4-openssl-dev openssl
RUN apt-get install -y gawk libreadline6-dev libyaml-dev autoconf libgdbm-dev libncurses5-dev automake libtool bison libffi-dev
RUN apt-get install -y libpq-dev xvfb imagemagick libldap2-dev libsasl2-dev wkhtmltopdf pdftk libmysqlclient-dev zip libgmp-dev
RUN apt-get install -y openssh-client qt5-default libqt5webkit5-dev

# Chromedriver
RUN apt-get install -y chromium-chromedriver

## Latest version of Postgres from their repos
RUN echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update
RUN apt-get -y install postgresql-client

## Nodejs engine
RUN curl -sL https://deb.nodesource.com/setup_7.x | bash -
RUN apt-get install -y nodejs

## YARN
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install -y yarn

RUN apt-get install -y software-properties-common
RUN apt-add-repository ppa:brightbox/ruby-ng
RUN apt-get update

RUN yarn global add phantomjs-prebuilt

RUN apt-get install -y ruby2.3 ruby2.3-dev

RUN apt-get install -y gstreamer1.0-plugins-base gstreamer1.0-tools gstreamer1.0-x

RUN apt-get autoremove -y

RUN gem install bundler

CMD ["bash"]
