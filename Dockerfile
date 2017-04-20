FROM jbfavre/minideb:jessie
MAINTAINER Jean Baptiste Favre <docker@jbfavre.org>

ENV SHELL "/bin/bash"
ENV DEBIAN_FRONTEND noninteractive
ENV TERM 1
ENV VERSION=4.0.3

ADD scripts /tmp/

RUN /usr/bin/apt-get update -yqq \
 && /usr/bin/apt-get upgrade --no-install-recommends -yqq \
 && /usr/bin/apt-get install --no-install-recommends -yqq locales \
 && /usr/bin/apt-get install --no-install-recommends -yqq acl curl git \
    libexpat1 zip unzip nginx default-jre-headless python2.7 libpython2.7 \
    libfreetype6 libgfortran3 libgomp1 \
 && /usr/bin/chsh -s /bin/bash root \
 && /bin/rm /bin/sh && ln -s /bin/bash /bin/sh \
 && /usr/sbin/groupadd -r dataiku \
 && /usr/sbin/useradd -r -m -s /bin/bash -g dataiku dataiku \
 && /bin/echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
 && /usr/sbin/locale-gen \
 && /usr/bin/curl -SL -o /tmp/dataiku-dss.tar.gz \
    https://downloads.dataiku.com/public/studio/${VERSION}/dataiku-dss-${VERSION}.tar.gz \
 && /bin/su - dataiku -c '/bin/tar xzf /tmp/dataiku-dss.tar.gz -C /home/dataiku --strip-components=1' \
 && /bin/rm /tmp/dataiku-dss.tar.gz \
 && /bin/mkdir -p /var/lib/dataiku \
 && /bin/mkdir -p /etc/dataiku \
 && /bin/mkdir -p /var/cache/dataiku \
 && /bin/chown -R dataiku: /var/lib/dataiku \
 && /bin/bash /tmp/debian_cleaner.sh

ENTRYPOINT ['/bin/bash']
