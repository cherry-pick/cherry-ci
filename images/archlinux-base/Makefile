#
# cherry-ci - archlinux bootstrap
#
# This Makefile provides targets to bootstrap an ArchLinux installation
# consisting of just pacman and its dependencies. The result will be an image
# ready to be populated with native packages.
#
# The intention is to create a clean, vanilla ArchLinux image without any
# modifications, usable as base image for others.
#
# The following API targets are available:
#
#     help:
#         Print a short help text and usage information. This is the default
#         target.
#
#     populate-keys:
#         The pacman package manager requires a keyring to be initialized to
#         validate packages. If the host is not a native ArchLinux system, you
#         can use this target to populate your pacman keyring.
#
#         If the keyring is already populated, this will re-populate it
#         (usually a no-op).
#
#     build:
#         This builds the directory tree for the image. If the directory tree
#         is already available, the build is skipped. To force a rebuild, you
#         have to remove the tree first.
#
#         This target requires `pacman` and `pacman-key` to be available on the
#         host system. The new directory tree is populated via native pacman
#         commands. Furthermore, you must be root to run this target.
#
#         The `populate-keys` target can be used to initialize pacman on the
#         host system, if not already done.
#
#     unbuild:
#         This reverts any previous build. That is, regardless whether a
#         previous build succeeded or failed, this will remove all files
#         created by it.
#
#         Note that you need to be root to undo the build operations (which are
#         also run as root).
#
#     rebuild:
#         This is a simple convenience target that runs `make unbuild` followed
#         by `make build`.
#
#     *.tar{,.gz,.xz}:
#         This target creates a tarball (optionally compressed with the
#         specified algorithm) of the directory tree. Note that the tarball
#         will not contain any prefix directory. Hence, it is suitable to be
#         used to populate a container without specifying `--strip-components`.
#

C1_ROOTDIR = rootfs
C1_TARARGS = --numeric-owner --xattrs --acls

_default help:
	@echo "cherry-ci - archlinux bootstrap"
	@echo ""
	@echo "Makefile to bootstrap an ArchLinux image containing only the"
	@echo "pacman package and its dependencies. For further details,"
	@echo "look for comments and instructions in the Makefile itself."
	@echo ""
	@echo "Targets:"
	@echo "              help: Print this help"
	@echo "     populate-keys: (Re-)populate the pacman keyring"
	@echo "             build: Build ArchLinux directory tree"
	@echo "           unbuild: Clean leftovers from \`build'"
	@echo "           rebuild: Run \`unbuild' followed by \`build'"
	@echo "   *.tar{,.gz,.xz}: Build (compressed) tarballs"
.PHONY: _default help

_privileged:
	@if [[ `id -u` != 0 ]] ; then echo "You need to be root." ; exit 1 ; fi
.PHONY: _privileged

_build-it:
	#
	# create top-level directories with appropriate permissions
	mkdir -p "$(C1_ROOTDIR)"
	mkdir -m 0755 -p "$(C1_ROOTDIR)"/{dev,etc,run,var}
	mkdir -m 0555 -p "$(C1_ROOTDIR)"/{proc,sys}
	mkdir -m 1777 -p "$(C1_ROOTDIR)"/tmp
	#
	# create sub-level directories
	mkdir -m 0777 -p "$(C1_ROOTDIR)"/run/shm
	mkdir -m 0755 -p "$(C1_ROOTDIR)"/var/{cache/pacman/pkg,lib/pacman,log}
	#
	# setup mounts
	mount --bind "$(C1_ROOTDIR)" "$(C1_ROOTDIR)"
	mount devtmpfs  "$(C1_ROOTDIR)/dev"     -t devtmpfs     -o nosuid,mode=0755
	mount devpts    "$(C1_ROOTDIR)/dev/pts" -t devpts       -o nosuid,noexec,mode=0620,gid=5
	mount tmpfs     "$(C1_ROOTDIR)/dev/shm" -t tmpfs        -o nosuid,nodev
	mount proc      "$(C1_ROOTDIR)/proc"    -t proc         -o nosuid,nodev,noexec
	mount tmpfs     "$(C1_ROOTDIR)/run"     -t tmpfs        -o nosuid,nodev,mode=0755
	mount sys       "$(C1_ROOTDIR)/sys"     -t sysfs        -o nosuid,nodev,noexec,ro
	mount tmpfs     "$(C1_ROOTDIR)/tmp"     -t tmpfs        -o nosuid,nodev
	#
	# install packages
	pacman \
		--config pacman.conf \
		--root "$(C1_ROOTDIR)" \
		--noconfirm \
		-Sy \
			filesystem \
			bash \
			pacman
	#
	# post-install fixes and default configuration
	cp "mirrorlist" "$(C1_ROOTDIR)"/etc/pacman.d/
	unshare --fork --pid chroot "$(C1_ROOTDIR)" /bin/bash -c \
		'pacman-key --init && pacman-key --populate archlinux'
	#
	# teardown mounts
	umount -R "$(C1_ROOTDIR)"
.PHONY: _build-it

populate-keys: | _privileged
	pacman-key --init
	pacman-key --populate archlinux
.PHONY: populate-keys

build: | _privileged
	@if [[ -d "$(C1_ROOTDIR)" ]] ; then \
		echo "Rootfs is already built." ; \
	else \
		$(MAKE) --no-print-directory _build-it ; \
	fi
.PHONY: build

unbuild: | _privileged
	if mountpoint -q "$(C1_ROOTDIR)" ; then umount -R "$(C1_ROOTDIR)" ; fi
	rm -Rf "$(C1_ROOTDIR)"
.PHONY: unbuild

rebuild: | _privileged
	@$(MAKE) --no-print-directory unbuild
	@$(MAKE) --no-print-directory build
.PHONY: rebuild

%.tar: $(C1_ROOTDIR) | _privileged
	tar $(C1_TARARGS) -cf "$@" -C "$(C1_ROOTDIR)" .

%.tar.gz: $(C1_ROOTDIR) | _privileged
	tar $(C1_TARARGS) -czf "$@" -C "$(C1_ROOTDIR)" .

%.tar.xz: $(C1_ROOTDIR) | _privileged
	tar $(C1_TARARGS) -cJf "$@" -C "$(C1_ROOTDIR)" .
