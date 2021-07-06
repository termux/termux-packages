TERMUX_PKG_HOMEPAGE=http://smarden.org/runit
TERMUX_PKG_DESCRIPTION="Tools to provide service supervision and to manage services"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="Henrik Grimler @Grimler91"
TERMUX_PKG_VERSION=2.1.2
TERMUX_PKG_REVISION=2
_COMMIT=d24ac1333e34a73c5349030aef1c64c5cc1318cc
TERMUX_PKG_SRCURL=https://git.sr.ht/~grimler/runit/archive/$_COMMIT.tar.gz
TERMUX_PKG_SHA256=f6d14f4107ba106bbfef15fd9f71ea3b70c1154169fc7efadd868cceb376b35f
TERMUX_PKG_RM_AFTER_INSTALL="bin/runit-init share/man/man8/runit-init.8"

termux_step_pre_configure() {
	autoreconf -vfi
}
