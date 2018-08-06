FROM debian:stretch
MAINTAINER Jani Hast <jani.hast@viidakko.fi>

# Install packages
RUN apt-get -yy update && \
	apt-get -yy upgrade && \
	apt-get -yy install curl vim perl php7.0-cli git gnupg sudo golang-1.8 golang-1.8-doc golang-1.8-go golang-1.8-src

# Install Postgresql
RUN curl -sL https://apt.postgresql.org/pub/repos/apt/ACCC4CF8.asc | apt-key add - && echo "deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main" > /etc/apt/sources.list.d/pgdg.list
RUN apt-get -yy update && \
	apt-get -yy upgrade && \
	apt-get -yy install postgresql-10 postgresql-client-10 postgresql-contrib

# Setup system timezone
RUN cp /usr/share/zoneinfo/Europe/Helsinki /etc/localtime && \
	echo "Europe/Helsinki" > /etc/timezone && \
	dpkg-reconfigure --frontend noninteractive tzdata

# Setup system locales
RUN apt-get -qq -y install locales && \
	sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
	echo 'LANG="en_US.UTF-8"'>/etc/default/locale && \
	dpkg-reconfigure --frontend=noninteractive locales && \
	update-locale LANG=en_US.UTF-8

COPY setup/* /setup/
COPY vimrc /root/.vimrc
COPY bashrc /root/.bashrc
COPY vim /root/.vim

ENV GOPATH /go
#RUN vim -c 'GoUpdateBinaries' -c 'q'
RUN vim -c 'helptags ALL' -c 'q'

ENV LANG en_US.UTF-8 

EXPOSE 80
