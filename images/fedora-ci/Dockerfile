FROM fedora

#
# cherry-ci - fedora-ci
#
# This builds the Fedora base-image for CI systems. It uses the official Fedora
# bootstrap image and adds required compilers and build essentials.
#

RUN dnf -y --nodocs update \
        && dnf -y --nodocs install \
                autoconf \
                automake \
                binutils-devel \
                bison-devel \
                clang \
                dbus-devel \
                expat-devel \
                flex-devel \
                gawk \
                gcc \
                gdb \
                gettext \
                git \
                glib2-devel \
                glibc-devel \
                grep \
                groff \
                gzip \
                libtool \
                m4 \
                make \
                meson \
                ninja-build \
                patch \
                pkgconf \
                python2-docutils \
                sed \
                sudo \
                systemd-devel \
                texinfo \
                util-linux \
                which \
                valgrind \
        && dnf clean all
