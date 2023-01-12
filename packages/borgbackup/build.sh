TERMUX_PKG_HOMEPAGE=https://www.borgbackup.org/
TERMUX_PKG_DESCRIPTION="Deduplicating and compressing backup program"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.1.17
TERMUX_PKG_REVISION=10
TERMUX_PKG_SRCURL=https://github.com/borgbackup/borg/releases/download/${TERMUX_PKG_VERSION}/borgbackup-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=7ab924fc017b24929bedceba0dcce16d56f9868bf9b5050d2aae2eb080671674
# Cannot be updated to 1.2.0 (or newer) as it requires external python package
#TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libacl, liblz4, openssl, python, xxhash, zstd"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PYTHON_COMMON_DEPS="Cython, wheel"
