#!/bin/bash

for FILE in $(ls -1d /usr/share/locale/*|grep -v en);do rm -rf $FILE;done
for FILE in $(ls -1R /usr/share/i18n/locales/* | grep -v en_GB | grep -v en_US);do rm -rf $FILE;done
/bin/rm -rf /usr/lib/jvm/java-7-openjdk-amd64/jre/man/* /usr/lib/jvm/java-7-openjdk-amd64/man/*
find /usr/share/doc -type f -exec rm -f {} \;
find /usr/share/man -type f -exec rm -f {} \;
/usr/bin/apt-get -y autoremove
/usr/bin/apt-get clean
/bin/rm -rf /var/lib/apt/lists/*
/bin/rm -f /var/lib/dpkg/info/*
/bin/rm -f /var/cache/debconf/*
/bin/rm -rf /tmp/*
#/usr/bin/dpkg --purge --force-remove-essential --force-depends libpulse0 dmsetup util-linux libmount1 libcryptsetup4 util-linux libblkid1 e2fsprogs libsm6 libuuid1 adduser passwd 
#/usr/bin/dpkg --purge --force-remove-essential --force-depends inetutils-ping netbase ncurses-bin ncurses-base login iproute2 
#/usr/bin/dpkg --purge --force-remove-essential --force-depends e2fsprogs startpar gcc-4.8-base gnupg gpgv inetutils-ping init-system-helpers insserv fontconfig-config fonts-dejavu-core e2fslibs dmsetup diffutils debianutils debian-archive-keyring debconf-i18n debconf
#/usr/bin/dpkg --purge apt libapt-pkg4.12 debian-archive-keyring gnupg
#/usr/bin/dpkg --purge --force-remove-essential --force-depends udev procps init systemd-sysv systemd sysv-rc sysvinit-utils initscripts startpar init-system-helpers
#/usr/bin/dpkg --purge --force-remove-essential --force-depends coreutils bsdutils base-passwd apt adduser acl grep findutils
