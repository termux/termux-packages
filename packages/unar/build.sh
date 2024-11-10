TERMUX_PKG_HOMEPAGE=https://theunarchiver.com/command-line
TERMUX_PKG_DESCRIPTION="Command line tools for archive and file unarchiving and extraction"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=()
TERMUX_PKG_REVISION=9
TERMUX_PKG_VERSION+=(1.10.7)
TERMUX_PKG_VERSION+=(1.1)
TERMUX_PKG_SRCURL=(https://github.com/MacPaw/XADMaster/archive/v${TERMUX_PKG_VERSION}/XADMaster-${TERMUX_PKG_VERSION}.tar.gz
                   https://github.com/MacPaw/universal-detector/archive/${TERMUX_PKG_VERSION[1]}/universal-detector-${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(3d766dc1856d04a8fb6de9942a6220d754d0fa7eae635d5287e7b1cf794c4f45
                   8e8532111d0163628eb828a60d67b53133afad3f710b1967e69d3b8eee28a811)
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="libandroid-utimes, libbz2, libc++, libgnustep-base, libicu, libwavpack, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="-e -f Makefile.linux"

termux_step_post_get_source() {
	mv universal-detector-${TERMUX_PKG_VERSION[1]} UniversalDetector
}

termux_step_pre_configure() {
	CFLAGS+=" $CPPFLAGS -D__USE_BSD=1"
	CXXFLAGS+=" $CPPFLAGS"
	export OBJCC="$CC"
	export OBJCFLAGS="$CFLAGS -fobjc-nonfragile-abi"
	export LDFLAGS+=" -landroid-utimes"
	LD="$CXX"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin lsar unar
	install -Dm600 -t $TERMUX_PREFIX/share/man/man1 Extra/*.1
	mkdir -p $TERMUX_PREFIX/share/bash-completion/completions
	for c in lsar unar; do
		install -Dm600 Extra/${c}.bash_completion \
			$TERMUX_PREFIX/share/bash-completion/completions/${c}
	done
}
