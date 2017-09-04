FROM cherrypick/archlinux-base

#
# cherry-ci - archlinux base
#
# The archlinux-base image cannot be built via Dockerfiles, since it requires
# privileged execution to mount file-systems. This Dockerfile merely serves as
# self-hosted bootstrapping base. That is, it fetches a previously built
# archlinux-base image and installs required packages to run the bootstrap
# process. It can be used like this:
#
#     docker build -t mybase .
#     CID=`docker run --privileged --rm -dit mybase /bin/bash`
#     docker exec -t --privileged "$CID" make -C /usr/src/build/ build
#     docker exec -t --privileged "$CID" make -C /usr/src/build/ rootfs.tar
#     docker cp "$CID":/usr/src/build/rootfs.tar .
#     docker stop "$CID"
#
# That is, you first build an image via this Dockerfile, then spawn a detached
# privileged container to run `make build` and `make rootfs.tar`, and copy out
# the result.
#
# For details on the pure bootstrap process, please look into the Makefile.
#

RUN pacman -Sy \
        --noconfirm \
        --needed \
                coreutils \
                util-linux \
                grep \
                tar \
                make \
                git

ADD . /usr/src/build

#
# populate possible /dev/shm symlink
#
# The devtmpfs filesystem is a singleton, and as such always shared with the
# host. In case this is Debian, we must be prepared to mount over it. Make sure
# the directory exists.
RUN mkdir -m 0777 -p /run/shm
