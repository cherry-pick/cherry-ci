FROM cherrypick/fedora-base

#
# cherry-ci - fedora base
#
# The 'fedora-base' image is a Fedora OS image with just the 'bash' and 'dnf'
# packages installed. In other words, it contains the minimal amount of
# packages to be suitable to install any other Fedora package.
#
# Note that this Dockerfile is self-hosting. That is, it depends on a previous
# build of itself. If such an image is not available (e.g., bootstrapping a
# foreign architecture), you should use an existing image with
# 'dnf --forcearch ...' to get your base image.
#
# Be aware that this Dockerfile does not create the final image! On the
# contrary, it bootstraps the 'fedora-base' image into /usr/src/build/sysroot
# and provides a tarball of that directory as /usr/src/build/sysroot.tar. You
# should copy it out of there and import it into docker to get your new
# 'fedora-base' image. For instance, the following commands use this Dockerfile
# to build 'myimage', and then import it as new base-image as
# 'cherrypick/fedora-base'.
#
#       docker build \
#               -t myimage \
#               images/fedora-base
#
#       docker run \
#               --rm \
#               --entrypoint cat \
#               myimage \
#               /usr/src/build/sysroot.tar | \
#                       docker import \
#                               - \
#                               cherrypick/fedora-base
#

RUN dnf -y --nodocs update \
        && dnf -y --nodocs install \
                coreutils \
                tar \
        && dnf clean all

RUN mkdir -p /usr/src/build/sysroot

RUN dnf -y --nodocs update \
        && dnf \
                -y \
                --nodocs \
                --repo=fedora \
                --repo=updates \
                --releasever=26 \
                --installroot=/usr/src/build/sysroot \
                --setopt=install_weak_deps=False \
                install \
                        bash \
                        dnf \
                        fedora-release \
        && dnf clean all

RUN tar \
        --acls \
        --xattrs \
        --numeric-owner \
        -cf /usr/src/build/sysroot.tar \
        -C /usr/src/build/sysroot \
        .
