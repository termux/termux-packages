TERMUX_PKG_HOMEPAGE=http://www.gnu.org/software/guile/
TERMUX_PKG_DESCRIPTION="Portable, embeddable Scheme implementation written in C"
TERMUX_PKG_LICENSE="LGPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.10
TERMUX_PKG_REVISION=2
# Tip: Guile official source code contains hardlinks and cannot be built by default if "$TERMUX_ON_DEVICE_BUILD" == "true".
# To build if "$TERMUX_ON_DEVICE_BUILD" == "true", follow a guide like this to prepare for it:
# https://unix.stackexchange.com/questions/265024/unpacking-tarball-with-hard-links-on-a-file-system-that-doesnt-support-hard-lin
TERMUX_PKG_SRCURL=https://mirrors.kernel.org/gnu/guile/guile-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2dbdbc97598b2faf31013564efb48e4fed44131d28e996c26abe8a5b23b56c2a
TERMUX_PKG_DEPENDS="libandroid-spawn, libandroid-support, libffi, libgc, libgmp, libiconv, libunistring, ncurses, readline"
TERMUX_PKG_BUILD_DEPENDS="libtool"
TERMUX_PKG_BREAKS="guile-dev"
TERMUX_PKG_REPLACES="guile-dev"
TERMUX_PKG_CONFLICTS="guile18"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_BUILD_IN_SRC=true

# https://github.com/termux/termux-packages/issues/14806
TERMUX_PKG_NO_STRIP=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
LIBS=-landroid-spawn
ac_cv_func_posix_spawn=yes
ac_cv_func_posix_spawnp=yes
gl_cv_func_posix_spawn_works=yes
gl_cv_func_posix_spawnp_secure_exec=yes
ac_cv_type_complex_double=no
ac_cv_search_clock_getcpuclockid=false
ac_cv_func_GC_move_disappearing_link=yes
ac_cv_func_GC_is_heap_ptr=yes
"

_load_ubuntu_packages() {
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		export HOSTBUILD_ARCH="i386"
		export HOSTBUILD_ARCH_LIBDIR="/usr/lib/i386-linux-gnu"
		export HOSTBUILD_ARCH_INCLUDEDIR="/usr/include/i386-linux-gnu"
	else
		export HOSTBUILD_ARCH="amd64"
		export HOSTBUILD_ARCH_LIBDIR="/usr/lib/x86_64-linux-gnu"
		export HOSTBUILD_ARCH_INCLUDEDIR="/usr/include/x86_64-linux-gnu"
	fi
	export LD_LIBRARY_PATH="${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}"
	LD_LIBRARY_PATH+=":${HOSTBUILD_ROOTFS}/usr/lib"
}

# Function to obtain the .deb URL
obtain_deb_url() {
	local url attempt retries wait PAGE deb_url
	url="https://packages.ubuntu.com/noble/$HOSTBUILD_ARCH/$1/download"
	retries=50
	wait=50
	>&2 echo "url: $url"
	for ((attempt=1; attempt<=retries; attempt++)); do
		PAGE="$(curl -s "$url")"
		deb_url="$(grep -oE 'https?://.*\.deb' <<< "$PAGE" | head -n1)"
		if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
		else
			>&2 echo "Attempt $attempt: Failed to obtain deb URL. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done
	termux_error_exit "Failed to obtain URL after $retries attempts."
}

_install_ubuntu_packages() {
	# install Ubuntu packages, like in the aosp-libs build.sh
	export HOSTBUILD_ROOTFS="${TERMUX_PKG_HOSTBUILD_DIR}/ubuntu_packages"
	mkdir -p "${HOSTBUILD_ROOTFS}"
	local URL DEB_NAME DEB_LIST
	DEB_LIST="$@"
	for i in $DEB_LIST; do
		echo "deb: $i"
		URL="$(obtain_deb_url "$i")"
		DEB_NAME="${URL##*/}"
		termux_download "$URL" "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" SKIP_CHECKSUM
		mkdir -p "${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		ar x "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" --output="${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		tar xf "${TERMUX_PKG_TMPDIR}/${DEB_NAME}"/data.tar.* \
			-C "${HOSTBUILD_ROOTFS}"
	done
	find "${HOSTBUILD_ROOTFS}" -type f -name '*.pc' | \
		xargs -n 1 sed -i -e "s|/usr|${HOSTBUILD_ROOTFS}/usr|g"
}

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	_load_ubuntu_packages
	_install_ubuntu_packages libffi8 \
							libffi-dev \
							libgc1 \
							libgc-dev \
							libgmp10 \
							libgmp-dev \
							libreadline8t64 \
							libreadline-dev \
							libgpm2 \
							libtinfo6 \
							libncurses6 \
							libncursesw6 \
							libncurses-dev \
							libunistring5 \
							libunistring-dev

	export CFLAGS="-I${HOSTBUILD_ARCH_INCLUDEDIR} -I${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_INCLUDEDIR}"
	export LDFLAGS="-L${HOSTBUILD_ARCH_LIBDIR} -L${HOSTBUILD_ROOTFS}${HOSTBUILD_ARCH_LIBDIR}"

	local HOSTBUILD_EXTRA_CONFIGURE_ARGS_32=""
	if [[ "$TERMUX_ARCH_BITS" == "32" ]]; then
		export CFLAGS+=" -m32"
		HOSTBUILD_EXTRA_CONFIGURE_ARGS_32="--host=i386-linux-gnu"
	fi

	../src/configure --prefix="$HOSTBUILD_ROOTFS/usr" $HOSTBUILD_EXTRA_CONFIGURE_ARGS_32
	make -j "$TERMUX_PKG_MAKE_PROCESSES"
	make install
}

termux_step_pre_configure() {
	# Value of PKG_CONFIG becomes hardcoded in bin/*-config
	export PKG_CONFIG=pkg-config

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	# always remove this because the hostbuild may be for a different architecture
	rm -rf "$TERMUX_HOSTBUILD_MARKER"

	_load_ubuntu_packages

	export GUILE_FOR_BUILD="$HOSTBUILD_ROOTFS/usr/bin/guile"

	export CC_FOR_BUILD="gcc -m${TERMUX_ARCH_BITS}"
}

termux_step_post_configure() {
	cp "$TERMUX_PKG_BUILDER_DIR/malloc.h" "$TERMUX_PKG_BUILDDIR/lib/"
}
