FROM fedora

#
# cherry-ci - fedora-ci-base
#
# This builds our Fedora base-image for CI systems. It uses the official Fedora
# bootstrap image and initializes it for our CI images that are built on top of
# this. Since we want to keep images small, this only contains the bits and
# pieces that are shared by most of our other CI images, or considered crucial
# enough.
#

RUN dnf -y --nodocs update \
        && dnf -y --nodocs install \
                qemu-user-static \
        && dnf clean all

RUN mkdir -p /ci

COPY build.sh /ci
