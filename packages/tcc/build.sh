_COMMIT=9fb89c23d0f1c25528cb83161d16a846b6cda69c
_COMMIT_DATE=20241022
_COMMIT_SHA256=2e48f1fb7b0b30ba74be78a533fc6eb3b565984a695eb7c03d1c934c701a50d3

TERMUX_PKG_HOMEPAGE=https://bellard.org/tcc/
TERMUX_PKG_DESCRIPTION="Tiny C Compiler"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1:0.9.28~p${_COMMIT_DATE}
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=git+https://repo.or.cz/tinycc.git
TERMUX_PKG_SHA256=$_COMMIT_SHA256
TERMUX_PKG_GIT_BRANCH=mob
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_NO_STATICSPLIT=true
TERMUX_PKG_DEPENDS="ndk-sysroot"

termux_step_post_get_source() {
	git fetch --unshallow
	# tcc likes to have a real branch name in its version string
	git reset --hard $_COMMIT

	local pdate="p$(git log -1 --format=%cs | sed 's/-//g')"
	if [[ "$TERMUX_PKG_VERSION" != *"${pdate}" ]]; then
		echo -n "ERROR: The version string \"$TERMUX_PKG_VERSION\" is"
		echo -n " different from what is expected to be; should end"
		echo " with \"${pdate}\"."
		return 1
	fi

	local s=$(find . -type f ! -path '*/.git/*' -print0 | xargs -0 sha256sum | LC_ALL=C sort | sha256sum)
	if [[ "${s}" != "${TERMUX_PKG_SHA256}  "* ]]; then
		termux_error_exit "Checksum mismatch for source files."
	fi
}

termux_step_configure() {
	# override default step
	true
}

termux_step_make() {
	(
		unset CC CFLAGS LDFLAGS
		# make a cross-tcc and use it to compile the runtime
		./configure --targetos="Termux" --cpu="$TERMUX_ARCH" \
			--sysroot="${TERMUX_STANDALONE_TOOLCHAIN}/sysroot/usr"
		make -j $TERMUX_PKG_MAKE_PROCESSES tcc libtcc1.a
	)

	# now cross-compile tcc for target
	./configure --targetos=Termux --cpu="$TERMUX_ARCH"
	make -j $TERMUX_PKG_MAKE_PROCESSES tcc
	make doc
}
