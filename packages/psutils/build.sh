TERMUX_PKG_HOMEPAGE=https://github.com/rrthomas/psutils
TERMUX_PKG_DESCRIPTION="A set of postscript utilities"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.09"
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL="https://github.com/rrthomas/psutils/releases/download/v${TERMUX_PKG_VERSION}/psutils-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=e31ab570e24478ce777b63b300ff428aedc916131cd7b077094311761604b7da
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="ghostscript, perl, libpaper"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="ac_cv_path_PAPER=${TERMUX_PREFIX}/bin/paper"

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
