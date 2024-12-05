TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.14.4"
TERMUX_PKG_SRCURL=https://downloads.apache.org/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=44ead116e72e480f10f123c914bb6f9f8c041711c041ed7abff1b8634a199e3c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite, liblz4, utf8proc, zlib"
TERMUX_PKG_BREAKS="subversion-dev"
TERMUX_PKG_REPLACES="subversion-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
svn_cv_pycfmt_apr_int64_t=UNUSED_REMOVE_AFTER_NEXT_UPDATE
--without-sasl
--without-libmagic
"

termux_step_pre_configure() {
	CFLAGS+=" -std=c11 -I$TERMUX_PREFIX/include/perl"
	LDFLAGS+=" -lm -Wl,--as-needed -L$TERMUX_PREFIX/include/perl"
}

termux_step_post_make_install() {
	make -j $TERMUX_PKG_MAKE_PROCESSES install-swig-pl-lib

	pushd subversion/bindings/swig/perl/native
	# it's probably not needed to pass all flags to both perl and make
	# but it works
	PERL_MM_USE_DEFAULT=1 INSTALLDIRS=site CC="$CC" LD="$CC" \
		OPTIMIZE="$CFLAGS" CFLAGS="$CFLAGS" CCFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS -lperl" LDDLFLAGS="-shared $CFLAGS $LDFLAGS -lperl" \
		INSTALLSITEMAN3DIR="$TERMUX_PREFIX/share/man/man3" \
		perl Makefile.PL PREFIX="$TERMUX_PREFIX"
	popd

	make -j $TERMUX_PKG_MAKE_PROCESSES PREFIX="$TERMUX_PREFIX" \
		PERL_MM_USE_DEFAULT=1 INSTALLDIRS=site CC="$CC" LD="$CC" \
		OPTIMIZE="$CFLAGS" CFLAGS="$CFLAGS" CCFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS -lperl" LDDLFLAGS="-shared $CFLAGS $LDFLAGS -lperl" \
		INSTALLSITEMAN3DIR="$TERMUX_PREFIX/share/man/man3" \
		install-swig-pl

	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	local host_perl_version=$(perl -e 'printf "%vd\n", $^V;')
	cd "$TERMUX_PREFIX/lib"
	rm "x86_64-linux-gnu/perl/$host_perl_version/perllocal.pod"
	mkdir -p "perl5/site_perl/$perl_version/${TERMUX_ARCH}-android"
	mv "x86_64-linux-gnu/perl/$host_perl_version/"* \
		"perl5/site_perl/$perl_version/${TERMUX_ARCH}-android"
	rmdir x86_64-linux-gnu/{perl/{"$host_perl_version/",},}
}
