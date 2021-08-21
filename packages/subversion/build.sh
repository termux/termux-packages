TERMUX_PKG_HOMEPAGE=https://subversion.apache.org
TERMUX_PKG_DESCRIPTION="Centralized version control system characterized by its simplicity"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.14.1
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://www.apache.org/dist/subversion/subversion-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=2c5da93c255d2e5569fa91d92457fdb65396b0666fad4fd59b22e154d986e1a9
TERMUX_PKG_DEPENDS="apr, apr-util, serf, libexpat, libsqlite, liblz4, utf8proc, zlib"
TERMUX_PKG_BREAKS="subversion-dev"
TERMUX_PKG_REPLACES="subversion-dev"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
svn_cv_pycfmt_apr_int64_t=UNUSED_REMOVE_AFTER_NEXT_UPDATE
--without-sasl
--without-libmagic
"

termux_step_handle_hostbuild() {
	# TODO: maybe split off into a termux_setup_perl
	# to simplify cross-compiling other packages?
	[ "$TERMUX_ON_DEVICE_BUILD" = "true" ] && return
	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	PATH=$TERMUX_PKG_HOSTBUILD_DIR/bin:$PATH
	[ "$(perl -e 'printf "%vd\n", $^V;')" = "$perl_version" ] && return
	echo "Building perl v$perl_version for host build..."
	mkdir ~/perl_build && cd ~/perl_build
	termux_download http://www.cpan.org/src/5.0/perl-${perl_version}.tar.gz \
		perl-${perl_version}.tar.gz \
		$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_SHA256)
	tar -xf perl-${perl_version}.tar.gz
	cd perl-${perl_version}
	./Configure -de -Dprefix="'$TERMUX_PKG_HOSTBUILD_DIR'" -Dman{1,3}dir=none
	make -j $TERMUX_MAKE_PROCESSES install
}

termux_step_pre_configure() {
	export PERL5LIB="$TERMUX_PREFIX/lib/perl5/"
	CFLAGS+=" -std=c11 -I$TERMUX_PREFIX/include/perl"
	LDFLAGS+=" -lm -Wl,--as-needed"
}

termux_step_post_make_install() {
	make -j $TERMUX_MAKE_PROCESSES install-swig-pl-lib

	pushd subversion/bindings/swig/perl/native
	# it's probably not needed to pass all flags to both perl and make
	# but it works
	PERL_MM_USE_DEFAULT=1 INSTALLDIRS=site CC="$CC" LD="$CC" \
		OPTIMIZE="$CFLAGS" CFLAGS="$CFLAGS" CCFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS -lperl" LDDLFLAGS="-shared $CFLAGS $LDFLAGS" \
		perl Makefile.PL PREFIX="$TERMUX_PREFIX"
	popd

	make -j $TERMUX_MAKE_PROCESSES PREFIX="$TERMUX_PREFIX" \
		PERL_MM_USE_DEFAULT=1 INSTALLDIRS=site CC="$CC" LD="$CC" \
		OPTIMIZE="$CFLAGS" CFLAGS="$CFLAGS" CCFLAGS="$CFLAGS" \
		LDFLAGS="$LDFLAGS -lperl" LDDLFLAGS="-shared $CFLAGS $LDFLAGS" \
		install-swig-pl

	local perl_version=$(. $TERMUX_SCRIPTDIR/packages/perl/build.sh; echo $TERMUX_PKG_VERSION)
	cd "$TERMUX_PREFIX/lib/perl5/site_perl/$perl_version"
	mkdir -p "${TERMUX_ARCH}-android/"{auto,SVN}
	mv x86_64-linux/auto/* "${TERMUX_ARCH}-android/auto/"
	mv x86_64-linux/SVN/* "${TERMUX_ARCH}-android/SVN/"
	rm ../../$perl_version/x86_64-linux/perllocal.pod
	rmdir ../../$perl_version/x86_64-linux x86_64-linux{/auto,/SVN,}
}
