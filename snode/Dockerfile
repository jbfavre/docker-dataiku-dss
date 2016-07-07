FROM jbfavre/dataiku-dss-core:latest
MAINTAINER Jean Baptiste Favre <docker@jbfavre.org>

ADD config /etc/dataiku/
ADD apiservices /var/cache/dataiku/
ADD docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

VOLUME /var/lib/dataiku

EXPOSE 12000
