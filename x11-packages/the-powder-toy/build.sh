TERMUX_PKG_HOMEPAGE=https://powdertoy.co.uk/
TERMUX_PKG_DESCRIPTION="The Powder Toy is a free physics sandbox game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Pliushch <leonid.pliushch@gmail.com>"
TERMUX_PKG_VERSION=95.0
TERMUX_PKG_REVISION=15
TERMUX_PKG_SRCURL=https://github.com/ThePowderToy/The-Powder-Toy/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f60c3dc93e4ceddeda92b768e75a2d218f8df3da4a569b7d7cb57fff5515e15b
TERMUX_PKG_DEPENDS="fftw, libbz2, libc++, libcurl, liblua52, sdl2, libx11, zlib"
TERMUX_PKG_FOLDERNAME=The-Powder-Toy-${TERMUX_PKG_VERSION}
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_make() {
	export CFLAGS="${CFLAGS} -I${TERMUX_PREFIX}/include"
	export CXXFLAGS="${CFLAGS}"
	export LINKFLAGS="${LDFLAGS}"
	scons -j4 --lin --64bit --no-sse --lua52
}

termux_step_make_install() {
	install -Dm755 "${TERMUX_PKG_SRCDIR}/build/powder64-legacy" "${TERMUX_PREFIX}/bin/the-powder-toy"
	ln -sfr "${TERMUX_PREFIX}/bin/the-powder-toy" "${TERMUX_PREFIX}/bin/powder"
	${TERMUX_ELF_CLEANER} "${TERMUX_PREFIX}/bin/the-powder-toy"
}
