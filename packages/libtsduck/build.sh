TERMUX_PKG_HOMEPAGE=https://tsduck.io/
TERMUX_PKG_DESCRIPTION="An extensible toolkit for MPEG transport streams"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
_VERSION=3.29-2651
TERMUX_PKG_VERSION=${_VERSION//-/.}
TERMUX_PKG_SRCURL=https://github.com/tsduck/tsduck/archive/refs/tags/v${_VERSION}.tar.gz
TERMUX_PKG_SHA256=cab8f5838993aa1abd1a6a4c2ef7f2afba801da02a4001904f3f5ba5c5fe85a0
TERMUX_PKG_DEPENDS="libandroid-glob, libcurl, libedit"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
SYSPREFIX=$TERMUX_PREFIX
CROSS_TARGET=$TERMUX_ARCH
CROSS=1
NOTEST=1
NODEKTEC=1
NOCURL=
NOPCSC=1
NOSRT=1
NORIST=1
NOEDITLINE=
NOTELETEXT=1
NOGITHUB=1 
"
TERMUX_PKG_RM_AFTER_INSTALL="etc/security etc/udev"

termux_step_pre_configure() {
	local bin="$TERMUX_PKG_BUILDDIR/_wrapper/bin"
	local sh="$(command -v sh)"
	mkdir -p "$bin"
	for p in curl; do
		local conf="$bin/${p}-config"
		cat > "$conf" <<-EOF
			#!${sh}
			exec sh "$TERMUX_PREFIX/bin/${p}-config" "\$@"
		EOF
		chmod 0700 "$conf"
	done
	export PATH="$bin":$PATH

	CXXFLAGS+=" -fno-strict-aliasing"
	LDFLAGS+=" -landroid-glob"
}

termux_step_make() {
	make -j $TERMUX_MAKE_PROCESSES \
		CXX="$CXX" \
		GCC="$CC" \
		LD="$LD" \
		CXXFLAGS_CROSS="$CXXFLAGS $CPPFLAGS" \
		LDFLAGS_CROSS="$LDFLAGS" \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}
