TERMUX_PKG_HOMEPAGE=http://site.icu-project.org/home
TERMUX_PKG_DESCRIPTION='International Components for Unicode library'
TERMUX_PKG_VERSION=58.2
TERMUX_PKG_SRCURL=http://download.icu-project.org/files/icu4c/${TERMUX_PKG_VERSION/_/}/icu4c-${TERMUX_PKG_VERSION//./_}-src.tgz
TERMUX_PKG_SHA256=2b0a4410153a9b20de0e20c7d8b66049a72aef244b53683d0d7521371683da0c
TERMUX_PKG_FOLDERNAME="icu/source"
TERMUX_PKG_INCLUDE_IN_DEVPACKAGE="bin/icu-config share/man/man1/icu-config.1 lib/icu share/icu"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="--disable-samples --disable-tests"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--disable-samples --disable-tests --with-cross-build=$TERMUX_PKG_HOSTBUILD_DIR"
TERMUX_PKG_MAINTAINER='Vishal Biswas @vishalbiswas'

termux_step_post_extract_package () {
	# LICENSE resides outside of actual src
        mv "$TERMUX_PKG_TMPDIR/icu/LICENSE" "$TERMUX_PKG_SRCDIR/../"
}

termux_step_post_make_install () {
	rm "$TERMUX_PKG_SRCDIR/../LICENSE"
}

