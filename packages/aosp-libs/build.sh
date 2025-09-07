TERMUX_PKG_HOMEPAGE=https://source.android.com/
TERMUX_PKG_DESCRIPTION="bionic libc, libicuuc, liblzma, zlib, and boringssl for package builder and termux-docker"
TERMUX_PKG_LICENSE="BSD 3-Clause, Apache-2.0, ZLIB, Public Domain, BSD 2-Clause, OpenSSL, MirOS, BSD"
TERMUX_PKG_LICENSE_FILE="
bionic/libc/NOTICE
system/core/NOTICE
external/zlib/NOTICE
external/lzma/NOTICE
external/icu/NOTICE
external/boringssl/NOTICE
external/mksh/NOTICE
external/toybox/NOTICE
external/iputils/NOTICE
"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="9.0.0-r76"
TERMUX_PKG_REVISION=1
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_SKIP_SRC_EXTRACT=true
# Should be handled by AOSP build system so I am disable it here.
TERMUX_PKG_UNDEF_SYMBOLS_FILES="all"
TERMUX_PKG_BREAKS="bionic-host"
TERMUX_PKG_REPLACES="bionic-host"

# Function to obtain the .deb URL
obtain_deb_url() {
	# jammy is last known Ubuntu distro which contains `libncurses.so.5` in packages
	local url="https://packages.ubuntu.com/jammy/amd64/$1/download"
	local attempt retries=5 wait=5
	local PAGE deb_url

	for ((attempt=1; attempt<=retries; attempt++)); do
		PAGE="$(curl -s "$url")"
		>&2 echo page
		>&2 echo "$PAGE"
		deb_url="$(grep -oE 'https?://.*\.deb' <<< "$PAGE" | head -n1)"
		if [[ -n "$deb_url" ]]; then
				echo "$deb_url"
				return 0
		else
			>&2 echo "Attempt $attempt: Failed to obtain URL. Retrying in $wait seconds..."
		fi
		sleep "$wait"
	done

	termux_error_exit "Failed to obtain URL after $retries attempts."
}

termux_step_get_source() {
	if $TERMUX_ON_DEVICE_BUILD; then
		termux_error_exit "Package '$TERMUX_PKG_NAME' is not safe for on-device builds."
	fi

	case "${TERMUX_ARCH}" in
		i686) _ARCH=x86 ;;
		aarch64) _ARCH=arm64 ;;
		*) _ARCH=${TERMUX_ARCH} ;;
	esac

	export LD_LIBRARY_PATH="${TERMUX_PKG_SRCDIR}/prefix/lib/x86_64-linux-gnu:${TERMUX_PKG_SRCDIR}/prefix/usr/lib/x86_64-linux-gnu"
	export PATH="${TERMUX_PKG_SRCDIR}/prefix/usr/bin:${PATH//$HOME\/.cargo\/bin/}"

	mkdir -p "${TERMUX_PKG_SRCDIR}/prefix"
	cd "${TERMUX_PKG_SRCDIR}" || termux_error_exit "Couldn't enter source code directory: ${TERMUX_PKG_SRCDIR}"

	local URL DEB_NAME
	for i in libtinfo5 libncurses5 openssh-client; do
		URL="$(obtain_deb_url "$i")"
		DEB_NAME="${URL##*/}"
		termux_download "$URL" "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" SKIP_CHECKSUM

		mkdir -p "${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		ar x "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" --output="${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		tar xf "${TERMUX_PKG_TMPDIR}/${DEB_NAME}/data.tar.zst" -C "${TERMUX_PKG_SRCDIR}/prefix"
	done

	termux_download https://storage.googleapis.com/git-repo-downloads/repo "${TERMUX_PKG_CACHEDIR}/repo" SKIP_CHECKSUM
	chmod +x "${TERMUX_PKG_CACHEDIR}/repo"

	# Repo requires us to have a Git user name and email set.
	# The GitHub workflow does this, but the local build container doesn't
	[[ "$(git config --get user.name)" != '' ]] || git config --global user.name "Termux Github Actions"
	[[ "$(git config --get user.email)" != '' ]] || git config --global user.email "contact@termux.dev"
	"${TERMUX_PKG_CACHEDIR}"/repo init \
		-u https://android.googlesource.com/platform/manifest \
		-b main -m "${TERMUX_PKG_BUILDER_DIR}/default.xml" <<< 'n'
	"${TERMUX_PKG_CACHEDIR}"/repo sync -c -j32
}

termux_step_host_build() {
	# Correctly-functioning Python 2 seems to be a mandatory build dependency,
	# but using the prebuilt Python 2 from AOSP seemed to result in this error,
	# in AOSP 9.0.0 but not in AOSP 8.0.0 or 8.1.0:
	# /home/builder/.termux-build/termux-aosp/src/prebuilts/python/linux-x86/2.7.5/bin/python2:
	# can't decompress data; zlib not available
	# which only went away when I recompiled Python 2.
	PYTHON2_WORKDIR="${TERMUX_PKG_TMPDIR}/python2"
	PYTHON2_INSTALLDIR="${TERMUX_PKG_HOSTBUILD_DIR}/python2"
	mkdir -p "${PYTHON2_WORKDIR}" "${PYTHON2_INSTALLDIR}"
	termux_download https://www.python.org/ftp/python/2.7.18/Python-2.7.18.tar.xz \
		"${TERMUX_PKG_CACHEDIR}/python2.tar.xz" \
		b62c0e7937551d0cc02b8fd5cb0f544f9405bafc9a54d3808ed4594812edef43
	tar xf "${TERMUX_PKG_CACHEDIR}/python2.tar.xz" --strip-components=1 -C "${PYTHON2_WORKDIR}"
	pushd "${PYTHON2_WORKDIR}"
	./configure --prefix="${PYTHON2_INSTALLDIR}"
	make install
	popd
	export PATH="${PYTHON2_INSTALLDIR}/bin:${PATH}"
	python2 -m ensurepip
	pip2 install --upgrade setuptools pip
}

termux_step_configure() {
	# for adding python 2 to $PATH on subsequent builds when termux_step_host_build() has already run
	export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/python2/bin:${PATH}"
}

termux_step_make() {
	env -i LD_LIBRARY_PATH="$LD_LIBRARY_PATH" PATH="$PATH" bash -c "
		set -e;
		cd ${TERMUX_PKG_SRCDIR}
		source build/envsetup.sh;
		lunch aosp_${_ARCH}-eng;
		export ALLOW_MISSING_DEPENDENCIES=true
		make linker libc libm libdl libicuuc debuggerd crash_dump
		make toybox sh mkshrc ping ping6 tracepath tracepath6 traceroute6 arping
	"
}

termux_step_make_install() {
	mkdir -p "${TERMUX_PREFIX}/opt/aosp/"
	cp -r "${TERMUX_PKG_SRCDIR}"/out/target/product/generic*/system/* "${TERMUX_PREFIX}/opt/aosp/"
}
