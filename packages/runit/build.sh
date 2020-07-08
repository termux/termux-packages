TERMUX_PKG_HOMEPAGE=http://smarden.org/runit
TERMUX_PKG_DESCRIPTION="Tools to provide service supervision and to manage services"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_LICENSE_FILE="runit-2.1.2/package/COPYING"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=http://smarden.org/runit/runit-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=6fd0160cb0cf1207de4e66754b6d39750cff14bb0aa66ab49490992c0c47ba18
TERMUX_PKG_EXTRA_MAKE_ARGS="-C runit-${TERMUX_PKG_VERSION}/src"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make_install() {
	install -Dm755 runit-${TERMUX_PKG_VERSION}/src/{chpst,runit,runsv,runsvchdir,runsvdir,sv,svlogd,utmpset} $TERMUX_PREFIX/bin/
	mkdir -p $TERMUX_PREFIX/share/man/man8
	install -Dm644 runit-${TERMUX_PKG_VERSION}/man/{chpst,runit,runsv,runsvchdir,runsvdir,sv,svlogd,utmpset}.8 $TERMUX_PREFIX/share/man/man8/
}
