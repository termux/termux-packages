TERMUX_PKG_HOMEPAGE=https://github.com/kcleal/gw
TERMUX_PKG_DESCRIPTION="Genome browser"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="clealk@cardiff.ac.uk"
TERMUX_PKG_VERSION=0.7.0
TERMUX_PKG_SRCURL=https://github.com/kcleal/gw/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=92599d100755a5a20dc15ebfb86fdf0818ccc87c6e0a2cc0a7c3061661ed3d25
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS=glfw
TERMUX_PKG_DEPENDS=x11-repo
TERMUX_PKG_BUILD_DEPENDS="make, autotools, git, fontconfig, freetype-dev"
TERMUX_PKG_DEPENDS="mesa"
TERMUX_PKG_BLACKLISTED_ARCHES="arm, i686"


termux_step_make_install() {

	git clone https://github.com/kcleal/gw
	cd gw
	git clone https://github.com/samtools/htslib.git
	cd htslib && autoreconf -i && ./configure && make && make install
	cd .. 
	#export LD_LIBRARY_PATH="$(pwd)/htslib)"
	export CPPFLAGS="${CPPFLAGS} -I./htslib -I./lib/skia/include"
	export LDLIBS="${LDLIBS} -lEGL"
	export LDFLAGS="${LDFLAGS} -l./htslib"
	sed -i 's/Release-x64/Release-arm64/g' Makefile
	make prep
	ls
	ls ./lib
	ls ./lib/skia/out
	make
	#cp ./gw /bin
	#cp ./.gw.ini /bin
	install -D -m755 "${TERMUX_PREFIX}/gw" "target/${CARGO_TARGET_NAME}/gw"
	install -D -m644 "${TERMUX_PREFIX}/.gw.ini" "target/${CARGO_TARGET_NAME}/.gw.ini"

}
