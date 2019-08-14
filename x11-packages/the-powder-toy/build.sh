TERMUX_PKG_HOMEPAGE=https://powdertoy.co.uk/
TERMUX_PKG_DESCRIPTION="The Powder Toy is a free physics sandbox game"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="Leonid Plyushch <leonid.plyushch@gmail.com>"
TERMUX_PKG_VERSION=94.1
TERMUX_PKG_REVISION=3
TERMUX_PKG_SRCURL=https://github.com/ThePowderToy/The-Powder-Toy/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9770c0732c97e4e89a1e53330c969e9675595f78e6673c519c3724d6df591e72
TERMUX_PKG_DEPENDS="fftw, libbz2, libc++, liblua52, sdl2, libx11, zlib"
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
