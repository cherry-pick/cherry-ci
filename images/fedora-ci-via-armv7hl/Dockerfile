FROM cherrypick/fedora-ci-base

#
# cherry-ci - fedora-ci-via-armv7hl
#
# This builds our Fedora CI image for armv7hl. It builds on top of the
# fedora-ci base image and simply bootstraps fedora-armv7hl on /ci/sysroot.
#

RUN /ci/build.sh "/ci/sysroot" "armv7hl"
