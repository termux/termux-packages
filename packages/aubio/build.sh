TERMUX_PKG_HOMEPAGE=https://aubio.org/
TERMUX_PKG_DESCRIPTION="A library to label music and sounds"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.4.9
TERMUX_PKG_REVISION=7
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
	27549019034d13d76a9b8588749767e645dfabfcab1b693754cb973665cc215a
	025b6d0668601a17ce8312ad4930d7ba99715b754191208347df46b9a07b0a91
	49e9cf8dd312a1aa7b8b0c7a2cd76ff5fe9f8067ed6d487fa3576952e268914b
	75ebc45a8b961d3ee136fc8a87076d90f88ce15636d187d35fc09350d24448dc
	b6146996d45a9e6726f36b2a65f4e270d69a09da76cba82c17427be91c5c80c7
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
	sed -i 's#AV_INPUT_BUFFER_MIN_SIZE#16384#' src/io/source_avcodec.c
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
