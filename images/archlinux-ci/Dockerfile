FROM cherrypick/archlinux-systemd

#
# cherry-ci - archlinux-ci
#
# This builds the ArchLinux base-image for CI systems. It uses the ArchLinux
# systemd base image and adds required compilers and build essentials.
#

RUN pacman -Sy \
        --noconfirm \
        --needed \
                base \
                base-devel \
                clang \
                dbus \
                expat \
                git \
                glib2 \
                libsystemd \
                meson \
                ninja \
                python-docutils \
                valgrind
