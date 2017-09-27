FROM cherrypick/archlinux-base

#
# cherry-ci - archlinux base
#
# The 'archlinux-base' image is an Arch Linux OS image with just the 'bash' and
# 'pacman' packages installed. In other words, it contains the minimal amount
# of packages to be suitable to install any other Arch Linux package.
#
# Note that this Dockerfile is self-hosting. That is, it depends on a previous
# build of itself. If such an image is not available (e.g., bootstrapping a
# foreign architecture), you can use any other OS image with the 'pacman'
# package installed (don't forget to populate your keyring via 'pacman-key').
#
# Be aware that this Dockerfile does not create the final image! On the
# contrary, it bootstraps the 'archlinux-base' image into
# /usr/src/build/sysroot and provides a tarball of that directory as
# /usr/src/build/sysroot.tar. You should copy it out of there and import it
# into docker to get your new 'archlinux-base' image. For instance, the
# following commands use this Dockerfile to build 'myimage', and then import it
# as new base-image as 'cherrypick/archlinux-base'.
#
#       docker build \
#               -t myimage \
#               images/archlinux-base
#
#       docker run \
#               --rm \
#               --entrypoint cat \
#               myimage \
#               /usr/src/build/sysroot.tar | \
#                       docker import \
#                               - \
#                               cherrypick/archlinux-base
#

RUN pacman --noconfirm --needed -Syu \
        && pacman --noconfirm --needed -Su \
                tar

ADD . /usr/src/build
RUN mkdir -m 0755 -p /usr/src/build/sysroot
RUN mkdir -m 0755 -p /usr/src/build/sysroot/var/lib/pacman

RUN pacman \
        --noconfirm \
        --needed \
        --config /usr/src/build/pacman.conf \
        --root /usr/src/build/sysroot \
        -Sy \
                bash \
                coreutils \
                file \
                filesystem \
                findutils \
                gawk \
                grep \
                gzip \
                pacman \
                procps-ng \
                psmisc \
                sed \
                shadow \
                tar \
                util-linux \
                which

RUN pacman-key \
        --config /usr/src/build/sysroot/etc/pacman.conf \
        --gpgdir /usr/src/build/sysroot/etc/pacman.d/gnupg \
        --init
RUN pacman-key \
        --config /usr/src/build/sysroot/etc/pacman.conf \
        --gpgdir /usr/src/build/sysroot/etc/pacman.d/gnupg \
        --populate archlinux

RUN tar \
        --acls \
        --xattrs \
        --numeric-owner \
        -cf /usr/src/build/sysroot.tar \
        -C /usr/src/build/sysroot \
        .
