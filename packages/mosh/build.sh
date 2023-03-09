TERMUX_PKG_HOMEPAGE=https://mosh.org
TERMUX_PKG_DESCRIPTION="Mobile shell that supports roaming and intelligent local echo"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.4.0
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/mobile-shell/mosh/releases/download/mosh-${TERMUX_PKG_VERSION}/mosh-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=872e4b134e5df29c8933dff12350785054d2fd2839b5ae6b5587b14db1465ddd
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_DEPENDS="abseil-cpp, libandroid-support, libc++, libprotobuf, ncurses, openssl, openssh"
TERMUX_PKG_SUGGESTS="mosh-perl"

termux_step_pre_configure() {
	termux_setup_protobuf

	CXXFLAGS+=" -std=c++14"
	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/bin
	mv mosh mosh.pl
	$CXX $CXXFLAGS $LDFLAGS \
		-isystem $TERMUX_PREFIX/include \
		-DPACKAGE_VERSION=\"$TERMUX_PKG_VERSION\" \
		-std=c++11 -Wall -Wextra -Werror \
		$TERMUX_PKG_BUILDER_DIR/mosh.cc -o mosh-bin
	cat <<-EOF > mosh
		#!$TERMUX_PREFIX/bin/sh
		if [ -e "$TERMUX_PREFIX/bin/mosh.pl" ]; then
			exec "$TERMUX_PREFIX/bin/mosh.pl" "\$@"
		else
			exec "$TERMUX_PREFIX/bin/mosh-bin" "\$@"
		fi
	EOF
	chmod 0700 mosh
}
