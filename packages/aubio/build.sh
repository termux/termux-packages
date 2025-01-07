TERMUX_PKG_HOMEPAGE=https://aubio.org/
TERMUX_PKG_DESCRIPTION="A library to label music and sounds"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.9
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://aubio.org/pub/aubio-${TERMUX_PKG_VERSION}.tar.bz2
TERMUX_PKG_SHA256=d48282ae4dab83b3dc94c16cf011bcb63835c1c02b515490e1883049c3d1f3da
TERMUX_PKG_DEPENDS="ffmpeg, libsamplerate, libsndfile"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	declare -a _commits=(
	8a05420e
	cdfe9cef
	245deead
	0b947f96
	53bc55cd
	)

	declare -a _checksums=(
	33b730d1aa0562d5cb96341fce268acb8a42a0381e9dcd52caef0fc2737b8ad0
	025b6d0668601a17ce8312ad4930d7ba99715b754191208347df46b9a07b0a91
	ed8b8c76867884ff97e7df6d6992c9df6fd6396f002e103f7718ab978daff417
	1eb42cc2c51ca67ca6d54d2f223c3c3775041bf2743ccdddddd325e9365dc301
	e0d4ef1d61143130f919682b5288ad3030d9472f2c3b91d5c2703f9ec71e962d
	)

	for i in "${!_commits[@]}"; do
		PATCHFILE="${TERMUX_PKG_CACHEDIR}/aubio_patch_${_commits[i]}.patch"
		termux_download \
			"https://github.com/aubio/aubio/commit/${_commits[i]}.patch" \
			"$PATCHFILE" \
			"${_checksums[i]}"
		patch -p1 -i "$PATCHFILE"
	done

	patch -p1 -i "${TERMUX_PKG_BUILDER_DIR}"/src-io-source_avcodec.c.diff

	CPPFLAGS+=" -DFF_API_LAVF_AVCTX"
}

termux_step_configure() {
	./waf configure \
		--prefix=$TERMUX_PREFIX \
		LINKFLAGS="$LDFLAGS" \
		$TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	./waf
}

termux_step_make_install() {
	./waf install
}
