TERMUX_PKG_HOMEPAGE=https://6xq.net/pianobar/
TERMUX_PKG_DESCRIPTION="pianobar is a free/open-source, console-based client for the personalized online radio Pandora."
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.04.01
TERMUX_PKG_REVISION=2
TERMUX_PKG_SRCURL=https://github.com/PromyLOPh/pianobar/archive/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=2653c6659a141868625ab24ecf04210d20347d50e0bd03e670e2daefa9f4fb2d
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_TAG_TYPE="newest-tag"
TERMUX_PKG_DEPENDS="libao, ffmpeg, libgcrypt, libcurl, json-c"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	declare -a _commits=(
	8bf4c1bb
	)

	declare -a _checksums=(
	ab8f7539189a21064b1773551b393df16c34a371d23f38bf5394ca7b6e0ec411
	)

	for i in "${!_commits[@]}"; do
		PATCHFILE="${TERMUX_PKG_CACHEDIR}/pianobar_patch_${_commits[i]}.patch"
		termux_download \
			"https://github.com/PromyLOPh/pianobar/commit/${_commits[i]}.patch" \
			"$PATCHFILE" \
			"${_checksums[i]}"
		patch -p1 -i "$PATCHFILE"
	done
}

termux_step_post_make_install(){
	#install useful script
	install -Dm755 "$TERMUX_PKG_SRCDIR"/contrib/headless_pianobar "$TERMUX_PREFIX"/bin/pianoctl
}
