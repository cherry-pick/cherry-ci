FROM cherrypick/archlinux-base

#
# cherry-ci - archlinux systemd
#
# This builds on archlinux-base and installs systemd plus dependencies.
# Furthermore, it initializes the image to the default setup and prepares it
# for container boots via nspawn, docker, rocket, and friends.
#

RUN pacman -Sy --noconfirm \
        sed \
        gzip \
        systemd

RUN echo -n >/etc/machine-id
RUN ln -s ../../../etc/machine-id /var/lib/dbus/machine-id

RUN echo "LANG=en_US.UTF-8" >/etc/locale.conf
RUN echo "en_US.UTF-8 UTF-8" >/etc/locale.gen
RUN locale-gen
