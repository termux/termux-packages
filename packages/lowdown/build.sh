TERMUX_PKG_HOMEPAGE="https://kristaps.bsd.lv/lowdown"
TERMUX_PKG_DESCRIPTION="Markdown utilities and library (fork of hoedown -> sundown -> libsoldout)"
TERMUX_PKG_LICENSE="ISC"
TERMUX_PKG_LICENSE_FILE="LICENSE.md"
TERMUX_PKG_MAINTAINER="@flosnvjx"
TERMUX_PKG_VERSION="2.0.2"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://kristaps.bsd.lv/lowdown/snapshots/lowdown-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=d59f2ad82f981a63051bb61d8d04c02c8c49428ac29c435dff03a92e210b0004
#TERMUX_PKG_BUILD_DEPENDS="libseccomp" ## it is merely a checkdepends for now and we dont run check during build
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_MAKE_INSTALL_TARGET="install install_libs" ## add "regress" target if one wanna run check
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_METHOD=repology
TERMUX_PKG_ON_DEVICE_BUILD_NOT_SUPPORTED=true
TERMUX_PKG_HOSTBUILD=true

# Function to obtain the .deb URL
obtain_deb_url() {
	# Since we have ubuntu noble docker image we will use ubuntu repos
	local url="https://packages.ubuntu.com/noble/amd64/$1/download"
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

termux_step_host_build() {
	# We can not build bmake for host because it has bmake makefile. Classical chicken-n-egg problem.

	mkdir -p "${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin"
	local URL DEB_NAME
	for i in bmake; do
		URL="$(obtain_deb_url "$i")"
		DEB_NAME="${URL##*/}"
		termux_download "$URL" "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" SKIP_CHECKSUM

		mkdir -p "${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		ar x "${TERMUX_PKG_CACHEDIR}/${DEB_NAME}" --output="${TERMUX_PKG_TMPDIR}/${DEB_NAME}"
		tar xf "${TERMUX_PKG_TMPDIR}/${DEB_NAME}/data.tar.zst" -C "${TERMUX_PKG_HOSTBUILD_DIR}/prefix"
	done
	ln -s "${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin/bmake" "${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin/make"
}

termux_step_configure() {
	export MAKESYSPATH="${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/share/bmake/mk-bmake/"
	export PATH="${TERMUX_PKG_HOSTBUILD_DIR}/prefix/usr/bin:${PATH}"

	## avoid hard-linking during make
	sed -Ee 's%^([\t ]*ln) -f (lowdown lowdown-diff)$%\1 -srf \2%' -i Makefile

	## not an autoconf script
	./configure \
		LDFLAGS="$LDFLAGS" \
		CPPFLAGS="$CPPFLAGS" \
		PREFIX="$TERMUX_PREFIX" \
		MANDIR="$TERMUX_PREFIX/share/man"
}
