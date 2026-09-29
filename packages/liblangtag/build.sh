TERMUX_PKG_HOMEPAGE=https://gitlab.com/tagoh/liblangtag
TERMUX_PKG_DESCRIPTION="interface library to access/deal with tags for identifying languages"
TERMUX_PKG_LICENSE="LGPL-3.0-or-later, MPL-2.0, custom"
TERMUX_PKG_LICENSE_FILE="COPYING, COPYING.MPL, COPYING.Unicode"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.6.8"
TERMUX_PKG_SRCURL=https://gitlab.com/tagoh/liblangtag/-/releases/${TERMUX_PKG_VERSION}/downloads/liblangtag-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=f98d15a2039a523e6ad7796bba0fb003f214db57cc4ad2e12e2f8ab12d309694
TERMUX_PKG_DEPENDS="libxml2"
# --disable-introspection avoids LangTag-0.6: cannot execute binary file: Exec format error
# if gobject-introspection was installed in the same container before cross-compiling
# another workaround is probably to set gobject-introspection as a dependency,
# then generate and apply a gir-folder to the package,
# then use termux_setup_gir during termux_step_pre_configure, but currently the package was not written
# with gobject-introspection in mind, so consider it unnecessary until someone needs that in this package.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-introspection
"

termux_step_pre_configure() {
	export ac_cv_va_copy=C99

	declare -A LICENSE_CHECKSUMS

	LICENSE_CHECKSUMS[COPYING.MPL]=fab3dd6bdab226f1c08630b1dd917e11fcb4ec5e1e020e2c16f83a0a13863e85
	LICENSE_CHECKSUMS[COPYING.Unicode]=ecab49b0a28761bedcd38bc5a237a81acdfaacb655afea02c72ca1c120267749

	for LICENSE in ${!LICENSE_CHECKSUMS[@]}; do
		termux_download \
			"https://gitlab.com/tagoh/liblangtag/-/raw/${TERMUX_PKG_VERSION}/${LICENSE}" \
			"${TERMUX_PKG_SRCDIR}/${LICENSE}" \
			"${LICENSE_CHECKSUMS[${LICENSE}]}"
	done
}

termux_step_post_configure() {
	# Avoid overlinking
	sed -i 's/ -shared / -Wl,--as-needed\0/g' ./libtool
}
