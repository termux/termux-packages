TERMUX_PKG_HOMEPAGE=https://docs.docker.com/engine/
TERMUX_PKG_DESCRIPTION="Server daemon process for building and containerizing applications."
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
# remember to update DOCKER_GITCOMMIT inside termux_step_make()
# bellow when upgrading to a new version
TERMUX_PKG_VERSION=20.10.2
TERMUX_PKG_SRCURL=https://github.com/moby/moby/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=dc4818f0cba2ded2f6f7420a1fda027ddbf6c6c9fe319f84d1311bfe610447ca
TERMUX_PKG_DEPENDS="containerd"
TERMUX_PKG_CONFFILES="etc/docker/daemon.json"
TERMUX_PKG_BLACKLISTED_ARCHES="x86_64"

termux_step_make() {
	# setup go build environment
	termux_setup_golang

	# apply some patches in a batch
	xargs sed -i "s_\(/etc/docker\)_$PREFIX\1_g" < <(grep -R /etc/docker | cut -d':' -f1 | sort | uniq)
	xargs sed -i 's/[a-zA-Z0-9]*\.GOOS/"linux"/g' < <(grep -R '[a-zA-Z0-9]*\.GOOS' | cut -d':' -f1 | sort | uniq)


	# issue the build command
	export DOCKER_GITCOMMIT=8891c58a43
	export DOCKER_BUILDTAGS='exclude_graphdriver_btrfs exclude_graphdriver_devicemapper exclude_graphdriver_quota selinux exclude_graphdriver_aufs'
	# horrible but effective way to apply patches on the fly while compiling
	(while ! IFS='' files=$(AUTO_GOPATH=1 PREFIX='' hack/make.sh dynbinary 2>&1 1>/dev/null); do if ! xargs sed -i 's/\("runtime"\)/_ \1/' < <(echo $files | grep runtime | cut -d':' -f1 | cut -c38-); then echo $files; exit 1; fi; done)
}

termux_step_make_install() {
	install -Dm 0700 bundles/dynbinary-daemon/dockerd-dev ${TERMUX_PREFIX}/bin/dockerd-dev
	install -Dm 0700 ${TERMUX_PKG_BUILDER_DIR}/dockerd ${TERMUX_PREFIX}/bin/dockerd
	install -Dm 0700 ${TERMUX_PKG_BUILDER_DIR}/daemon.json ${TERMUX_PREFIX}/etc/docker/daemon.json
}
