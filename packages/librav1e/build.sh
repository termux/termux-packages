TERMUX_PKG_HOMEPAGE=https://github.com/xiph/rav1e/
TERMUX_PKG_DESCRIPTION="An AV1 encoder library focused on speed and safety"
TERMUX_PKG_LICENSE="BSD 2-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="0.7.1"
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/xiph/rav1e/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=da7ae0df2b608e539de5d443c096e109442cdfa6c5e9b4014361211cf61d030c
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+\.\d+\.\d+"
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_RM_AFTER_INSTALL="
lib/libz.a
lib/libz.so
"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after SOVERSION is changed.
	local _SOVERSION=0

	local v=$(echo ${TERMUX_PKG_VERSION#*:} | cut -d . -f 1)
	if [ "${v}" != "${_SOVERSION}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	termux_setup_rust
	termux_setup_cargo_c

	# https://github.com/termux/termux-packages/issues/20100
	mv ${TERMUX_PREFIX}/lib/libz.a{,.tmp} || :
	mv ${TERMUX_PREFIX}/lib/libz.so{,.tmp} || :

	export CARGO_BUILD_TARGET=$CARGO_TARGET_NAME
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "false" ]]; then
		export PKG_CONFIG_x86_64_unknown_linux_gnu=/usr/bin/pkg-config
		export PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig
	fi

	# clash with rust host build
	unset CFLAGS

	cargo fetch \
		--target $CARGO_TARGET_NAME
}

termux_step_make_install() {
	cargo install \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--path . \
		--force \
		--locked \
		--no-track \
		--target $CARGO_TARGET_NAME \
		--root $TERMUX_PREFIX

	# `cargo cinstall` refuses to work with Android
	cargo cbuild \
		--release \
		--prefix $TERMUX_PREFIX \
		--jobs $TERMUX_PKG_MAKE_PROCESSES \
		--frozen \
		--target $CARGO_TARGET_NAME

	cd target/$CARGO_TARGET_NAME/release/
	install -Dm644 -t $TERMUX_PREFIX/include/rav1e/ rav1e.h
	install -Dm644 -t $TERMUX_PREFIX/lib/pkgconfig/ rav1e.pc
	install -Dm644 -t $TERMUX_PREFIX/lib/ librav1e.a
	install -Dm644 librav1e.so $TERMUX_PREFIX/lib/librav1e.so.$TERMUX_PKG_VERSION
	ln -fs librav1e.so.$TERMUX_PKG_VERSION \
		$TERMUX_PREFIX/lib/librav1e.so.${TERMUX_PKG_VERSION%%.*}
	ln -fs librav1e.so.$TERMUX_PKG_VERSION $TERMUX_PREFIX/lib/librav1e.so
}

termux_step_post_make_install() {
	mv ${TERMUX_PREFIX}/lib/libz.a{.tmp,} || :
	mv ${TERMUX_PREFIX}/lib/libz.so{.tmp,} || :
}
