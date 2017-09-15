#!/bin/bash

#
# cherry-ci - build fedora-ci
#
# This script is provided by the fedora-ci-base image and invoked by its
# dependent images. It bootstraps an entire fedora-ci image into a
# subdirectory, and takes the target architecture and path as arguments.
#

set -e

#
# Configuration
FEDORA_VERSION="26"
FEDORA_DIR=
FEDORA_ARCH=

#
# stderr/stdout helpers
out() { printf "$1 $2\n" "${@:3}"; }
error() { out "==> ERROR:" "$@"; } >&2
die() { error "$@"; exit 1; }

#
# Shift command-line arguments.
(( $# )) ||  die 'Missing arguments.'
FEDORA_DIR="$1"; shift
(( $# )) ||  die 'Missing arguments.'
FEDORA_ARCH="$1"; shift

#
# Always update all packages to make sure we fetch the most recent packages via
# the Fedora mirrors. Otherwise, we might get 404's if our build is delayed.
dnf -y --nodocs update

#
# Verify the sysroot is non-existant, and then create it.
[[ ! -d "$FEDORA_DIR" ]] || die "Sysroot already exists: %s" "$FEDORA_DIR"
mkdir -p "$FEDORA_DIR"

#
# Bootstrap an entire Fedora release into $FEDORA_DIR, using $FEDORA_ARCH as
# architecture. This list contains the base-packages, followed by our
# ci-packages. Extend them to add more packages to all of our CI images.
dnf \
        -y \
        --nodocs \
        --releasever="$FEDORA_VERSION" \
        --installroot="$FEDORA_DIR" \
        --repo=fedora \
        --repo=updates \
        --forcearch="$FEDORA_ARCH" \
        install \
                systemd \
                passwd \
                dnf \
                fedora-release \
                vim-minimal \
                \
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
                sed \
                sudo \
                systemd-devel \
                texinfo \
                util-linux \
                which \
                valgrind \

#
# Clean caches to strip images from non-needed data.
dnf clean all
