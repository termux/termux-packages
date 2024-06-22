TERMUX_PKG_HOMEPAGE=https://asymptote.sourceforge.io/
TERMUX_PKG_DESCRIPTION="A powerful descriptive vector graphics language for technical drawing"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(2.89)
TERMUX_PKG_VERSION+=(1.0.1)
TERMUX_PKG_SRCURL=(https://downloads.sourceforge.net/asymptote/asymptote-${TERMUX_PKG_VERSION}.src.tgz
                   https://github.com/g-truc/glm/archive/${TERMUX_PKG_VERSION[1]}.tar.gz)
TERMUX_PKG_SHA256=(f64e62b4ee4f85f1a78640c4f1e8a6f98e91f54edacab19727c7cabe94a57f5b
                   9f3174561fd26904b23f0db5e560971cbf9b3cbda0b280f04d5c379d03bf234c)
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="fftw, libc++, libtirpc, zlib, ncurses, readline"
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
