FROM cherrypick/fedora-base

#
# cherry-ci - fedora-ci-base
#
# This builds our Fedora base-image for CI systems. It uses the minimal base
# bootstrap image and initializes it for our CI images that are built on top of
# this. Since we want to keep images small, this only contains the bits and
# pieces that are shared by most of our other CI images, or considered crucial
# enough.
#

RUN dnf -y --nodocs update \
        && dnf \
                -y \
                --nodocs \
                --setopt=install_weak_deps=False \
                install \
                        qemu-img \
                        xfsprogs \
        && dnf clean all

RUN mkdir -p /ci
COPY build.sh /ci
