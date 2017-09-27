#!/bin/bash

#
# cherry-ci - build fedora-ci
#
# This script is provided by the fedora-ci-base image and invoked by its
# dependent images. It bootstraps an entire fedora-ci image into a
# file-image, and takes a file-system prefix and target architecture as
# arguments.
#

set -e

#
# stderr/stdout helpers
out() { printf "$1 $2\n" "${@:3}"; }
error() { out "==> ERROR:" "$@"; } >&2
die() { error "$@"; exit 1; }

#
# Shift command-line arguments.
(( $# )) ||  die 'Missing arguments.'
FEDORA_PATH="$1"; shift
(( $# )) ||  die 'Missing arguments.'
FEDORA_ARCH="$1"; shift

#
# Configuration
FEDORA_VERSION="26"
FEDORA_SIZE=$((8 * 1024))
FEDORA_SYSROOT="${FEDORA_PATH}/sysroot"
FEDORA_IMG="${FEDORA_SYSROOT}.img"
FEDORA_QCOW="${FEDORA_SYSROOT}.qcow2"
FEDORA_LOOP=
FEDORA_KVER=
FEDORA_MID=

#
# Verify the sysroot is non-existant, and then create it.
[[ ! -d "$FEDORA_PATH" ]] || die "Sysroot already exists: %s" "$FEDORA_PATH"
mkdir -p "$FEDORA_PATH"

#
# Create and mount a fresh xfs image
dd if=/dev/null of="$FEDORA_IMG" bs=1MiB seek="$FEDORA_SIZE" count=0
FEDORA_LOOP=$(losetup --show -f -P "$FEDORA_IMG")
mkfs.xfs "$FEDORA_LOOP"
mkdir -p "$FEDORA_SYSROOT"
mount "$FEDORA_LOOP" "$FEDORA_SYSROOT"

#
# We need the boot cmdline early since the posttrans scripts use it to
# generate the initrd and friends.
mkdir -m 0755 -p "${FEDORA_SYSROOT}/"{etc,etc/kernel}
echo "dummy.cmdline" >"${FEDORA_SYSROOT}/etc/kernel/cmdline"

#
# Bootstrap an entire Fedora release into $FEDORA_DIR, using $FEDORA_ARCH as
# architecture. This list contains the base-packages, followed by our
# ci-packages. Extend them to add more packages to all of our CI images.
dnf -y --nodocs update \
        && dnf \
                -y \
                --nodocs \
                --repo=fedora \
                --repo=updates \
                --releasever="$FEDORA_VERSION" \
                --installroot="$FEDORA_SYSROOT" \
                --setopt=install_weak_deps=False \
                --forcearch="$FEDORA_ARCH" \
                install \
                        bash \
                        dnf \
                        fedora-release \
                        kernel \
                        passwd \
                        systemd \
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
        && dnf clean all

#
# Extract kernel and initrd
FEDORA_KVER=$(rpm -r "$FEDORA_SYSROOT" -q --qf "%{version}-%{release}.%{arch}" kernel)
FEDORA_MID=$(cat "${FEDORA_SYSROOT}/etc/machine-id")
cp "${FEDORA_SYSROOT}/boot/${FEDORA_MID}/${FEDORA_KVER}/linux" "$FEDORA_PATH"
cp "${FEDORA_SYSROOT}/boot/${FEDORA_MID}/${FEDORA_KVER}/initrd" "$FEDORA_PATH"

#
# Cleanup mounts and loopback
umount "$FEDORA_SYSROOT"
losetup -d "$FEDORA_LOOP"

#
# Turn into compressed qcow2 to save disk-space
qemu-img convert -c -f raw -O qcow2 "$FEDORA_IMG" "$FEDORA_QCOW"
rm -- "$FEDORA_IMG"
