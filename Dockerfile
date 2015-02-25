FROM phusion/baseimage:0.9.16

MAINTAINER andrea@parro.it

ENV COUCHDB_VERSION 1.5.0-0ubuntu1



# download dependencies && install
RUN apt-get update -y && apt-get install -y couchdb-bin=1.5.0-0ubuntu1

# create couchdb run directory
RUN mkdir /var/run/couchdb 
RUN mkdir /var/log/couchdb 
RUN mkdir /var/lib/couchdb 

# create user
RUN groupadd -r couchdb && useradd -d /var/run/couchdb -g couchdb couchdb

# copy configuration file
ADD local.ini /etc/couchdb/local.ini

# prepare init daemon script
# run as unprivileged user
RUN mkdir /etc/service/couchdb
RUN echo "#!/bin/sh" > /etc/service/couchdb/run
RUN echo "exec /sbin/setuser couchdb couchdb" >> /etc/service/couchdb/run
RUN chmod +x /etc/service/couchdb/run

# set permission for couchdb user
RUN chown -R couchdb:couchdb /var/run/couchdb
RUN chown -R couchdb:couchdb /var/log/couchdb
RUN chown -R couchdb:couchdb /var/lib/couchdb
RUN chown -R couchdb:couchdb /etc/couchdb/


# folder for data
VOLUME /var/lib/couchdb

EXPOSE 5984

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*