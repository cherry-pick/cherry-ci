FROM cherrypick/fedora-ci-base

#
# cherry-ci - fedora-ci-via-i686
#
# This builds our Fedora CI image for i686. It builds on top of the fedora-ci
# base image and simply bootstraps fedora-i686 on /ci/sysroot.
#

RUN /ci/build.sh "/ci/sysroot" "i686"
