TERMUX_PKG_HOMEPAGE=https://github.com/rrthomas/psutils
TERMUX_PKG_DESCRIPTION="A set of postscript utilities"
TERMUX_PKG_LICENSE="GPL-3.0, LGPL-3.0" # LGPL-3.0 for rrthomas's libpaper.
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.09"
TERMUX_PKG_SRCURL="https://github.com/rrthomas/psutils/releases/download/v${TERMUX_PKG_VERSION}/psutils-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e31ab570e24478ce777b63b300ff428aedc916131cd7b077094311761604b7da
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ghostscript, perl"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_PAPER=${TERMUX_PREFIX}/bin/paper"
TERMUX_PKG_PLATFORM_INDEPENDENT=true

# @rrthomas's libpaper is fork of debian's libpaper, but it isn't compatible with its upstream any more.
_RRTHOMAS_LIBPAPER_VERSION="1.2.0"
_RRTHOMAS_LIBPAPER_DIR="${TERMUX_PKG_TMPDIR}/libpaper-${_RRTHOMAS_LIBPAPER_VERSION}"

termux_step_post_get_source() {
	mkdir -p "${_RRTHOMAS_LIBPAPER_DIR}"

	termux_download "https://github.com/rrthomas/libpaper/releases/download/v${_RRTHOMAS_LIBPAPER_VERSION}/libpaper-${_RRTHOMAS_LIBPAPER_VERSION}.tar.gz" \
		"${_RRTHOMAS_LIBPAPER_DIR}.tar.gz" \
		faa3c1d4b24a345ed10dbb5c2382582e0dab6ef5f79c270db631d2bc46770a5a

	tar -xf "${_RRTHOMAS_LIBPAPER_DIR}.tar.gz" -C "${_RRTHOMAS_LIBPAPER_DIR}" --strip-components 1
}

termux_step_pre_configure() {
	# Compile rrthomas's libpaper:
	cd "${_RRTHOMAS_LIBPAPER_DIR}" || exit 1

	CFLAGS="${CFLAGS} -static" ./configure \
		--prefix="${TERMUX_PREFIX}" \
		--host="${TERMUX_HOST_PLATFORM}"

	# 210x297 is A4 size. Hard code as default.
	sed -i \
		-e "s|NL_PAPER_GET(_NL_PAPER_WIDTH)|210|g" \
		-e "s|NL_PAPER_GET(_NL_PAPER_HEIGHT)|297|g" \
		./lib/libpaper.c.in

	# Do not build man. No need of it. Also it fails for i686 and x86_64.
	printf "%s\n%s\n" "all:;" "install:;" >./man/Makefile

	make && make install
}

termux_step_post_massage() {
	local perl_version
	perl_version=$(
		. "${TERMUX_SCRIPTDIR}"/packages/perl/build.sh
		echo "${TERMUX_PKG_VERSION[0]}"
	)

	# Make sure that perl can find PSUtils module.
	mkdir -p "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib/perl5/${perl_version}"
	mv -f "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/psutils/PSUtils.pm \
		"${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}/lib/perl5/${perl_version}"/
	rmdir "${TERMUX_PKG_MASSAGEDIR}/${TERMUX_PREFIX}"/share/psutils
}
