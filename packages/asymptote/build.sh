TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(2.84)
TERMUX_PKG_VERSION+=(0.9.9.8)
TERMUX_PKG_SRCURL=(https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz
                   https://github.com/g-truc/glm/archive/${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(6765702d04b8121ca4e49f4b0d23244e623c904981f3588bc4210f0d696dccdb
                   7d508ab72cb5d43227a3711420f06ff99b0a0cb63ee2f93631b162bfe1fe9592)
TERMUX_PKG_DEPENDS="fftw, libc++, libtirpc, zlib"
TERMUX_PKG_BUILD_DEPENDS="ncurses-static, readline-static"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-gc
"

termux_step_post_get_source() {
	mv glm-${TERMUX_PKG_VERSION[1]} glm
}

termux_step_pre_configure() {
	touch GL/glu.h

	local glm_inc=$TERMUX_PKG_BUILDDIR/_glm/include
	mkdir -p $glm_inc
	cp -r glm/glm $glm_inc/
	CPPFLAGS+=" -I${glm_inc}"
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin asy
	cp -rT base $TERMUX_PREFIX/share/asymptote
}
