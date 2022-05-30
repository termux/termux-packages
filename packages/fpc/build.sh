TERMUX_PKG_HOMEPAGE=https://www.freepascal.org
TERMUX_PKG_DESCRIPTION="The Free Pascal Compiler (Turbo Pascal 7.0 and Delphi compatible)"
TERMUX_PKG_LICENSE="GPL-2.0, LGPL-2.0"
TERMUX_PKG_LICENSE_FILE="rtl/COPYING.FPC, rtl/COPYING.txt"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.2.2
TERMUX_PKG_SRCURL=https://sourceforge.net/projects/freepascal/files/Source/${TERMUX_PKG_VERSION}/fpc-${TERMUX_PKG_VERSION}.source.tar.gz
TERMUX_PKG_SHA256=d542e349de246843d4f164829953d1f5b864126c5b62fd17c9b45b33e23d2f44
TERMUX_PKG_BUILD_IN_SRC=true

# TODO: Move it to `termux_setup_fpc(or fpcmake)` if ever any package requires fpc.
termux_step_post_get_source() {
	local FPCMAKE_BIN="${TERMUX_PKG_TMPDIR}/fpcmake"
	mkdir -p "${FPCMAKE_BIN}"

	termux_download https://sourceforge.net/projects/freepascal/files/Linux/"${TERMUX_PKG_VERSION}"/fpc-"${TERMUX_PKG_VERSION}".x86_64-linux.tar \
		"${FPCMAKE_BIN}.tar" \
		5adac308a5534b6a76446d8311fc340747cbb7edeaacfe6b651493ff3fe31e83

	local tmpdir
	tmpdir=$(mktemp -d)
	tar xf "${FPCMAKE_BIN}.tar" -C "${tmpdir}" --strip-components=1

	tar xf "${tmpdir}"/binary.x86_64-linux.tar -C "${tmpdir}"
	tar xf "${tmpdir}"/utils-fpcm.x86_64-linux.tar.gz -C "${FPCMAKE_BIN}" --strip-components=1

	rm -rf "${tmpdir}"

	export PATH="${FPCMAKE_BIN}:${PATH}"
}

termux_step_pre_configure() {
	fpcmake -T"${TERMUX_ARCH}"-android
}
