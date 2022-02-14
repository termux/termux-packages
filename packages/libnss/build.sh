TERMUX_PKG_HOMEPAGE=https://firefox-source-docs.mozilla.org/security/nss/
TERMUX_PKG_DESCRIPTION="Network Security Services (NSS)"
TERMUX_PKG_LICENSE="MPL-2.0"
TERMUX_PKG_LICENSE_FILE="nss/COPYING"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.75
TERMUX_PKG_SRCURL=https://archive.mozilla.org/pub/security/nss/releases/NSS_${TERMUX_PKG_VERSION//./_}_RTM/src/nss-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=fd571507827284644f4dd522a032acda2286835f6683ed22a1c2d3878cc58582
TERMUX_PKG_DEPENDS="libnspr, libsqlite, zlib"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_EXTRA_MAKE_ARGS="
CC_IS_CLANG=1
CROSS_COMPILE=1
NSPR_INCLUDE_DIR=$TERMUX_PREFIX/include/nspr
NSS_DISABLE_GTESTS=1
NSS_ENABLE_WERROR=0
NSS_SEED_ONLY_DEV_URANDOM=1
NSS_USE_SYSTEM_SQLITE=1
OS_TEST=$TERMUX_ARCH
"
TERMUX_MAKE_PROCESSES=1
TERMUX_PKG_HOSTBUILD=true

_LIBNSS_SIGN_LIBS="libfreebl3.so libnssdbm3.so libsoftokn3.so"

termux_step_host_build() {
	mkdir -p nsinstall
	cd nsinstall
	for f in nsinstall.c pathsub.c; do 
		gcc -c $TERMUX_PKG_SRCDIR/nss/coreconf/nsinstall/$f
	done
	gcc nsinstall.o pathsub.o -o nsinstall
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DANDROID"
	LDFLAGS+=" -llog"

	TERMUX_PKG_EXTRA_MAKE_ARGS+=" NSINSTALL=$TERMUX_PKG_HOSTBUILD_DIR/nsinstall/nsinstall"
	if [ $TERMUX_ARCH_BITS -eq 64 ]; then
		TERMUX_PKG_EXTRA_MAKE_ARGS+=" USE_64=1"
	fi
}

termux_step_make() {
	cd nss
	make -j $TERMUX_MAKE_PROCESSES \
		CCC="$CXX" \
		XCFLAGS="$CFLAGS $CPPFLAGS" \
		CPPFLAGS="$CPPFLAGS" \
		${TERMUX_PKG_EXTRA_MAKE_ARGS}
}

termux_step_make_install() {
	cd dist
	install -Dm600 -t $TERMUX_PREFIX/include/nss public/nss/*
	install -Dm600 -t $TERMUX_PREFIX/include/nss/private private/nss/*
	install -Dm600 -t $TERMUX_PREFIX/include/dbm public/dbm/*
	install -Dm600 -t $TERMUX_PREFIX/include/dbm/private private/dbm/*
	pushd *.OBJ
	install -Dm700 -t $TERMUX_PREFIX/bin bin/*
	install -Dm600 -t $TERMUX_PREFIX/lib lib/*
	for f in $_LIBNSS_SIGN_LIBS; do
		if [ ! -e lib/$f ]; then
			echo "ERROR: \"lib/$f\" not found."
			exit 1
		fi
	done
	popd
}

termux_step_create_debscripts() {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	for f in $_LIBNSS_SIGN_LIBS; do
		echo "$TERMUX_PREFIX/bin/shlibsign -i $TERMUX_PREFIX/lib/$f" >> postinst
	done
	echo "exit 0" >> postinst
	chmod 0755 postinst
}
