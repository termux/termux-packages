TERMUX_PKG_HOMEPAGE=https://hledger.org/
TERMUX_PKG_DESCRIPTION="Robust, friendly, fast plain text accounting software"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@erplsf"
TERMUX_PKG_VERSION=1.43.2
TERMUX_PKG_SRCURL=https://github.com/simonmichael/hledger/archive/refs/tags/${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=60b74c70ddfc6b84ca87debd2ac302aac754da3c0d9089821182e56796cb841e
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, libffi, libiconv, libgmp, zlib"

termux_step_pre_configure() {
	termux_setup_ghc
	termux_setup_cabal
}

termux_step_post_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == false ]]; then # We do not need iserv for on device builds.
		termux_setup_ghc_iserv
		cat <<-EOF >>cabal.project.local
			package *
			    ghc-options: -fexternal-interpreter -pgmi=$(command -v termux-ghc-iserv)
                       
			source-repository-package
			    type: git
			    location: https://github.com/erplsf/splitmix
			    tag: aa5bb94be0d6a3e94584ac0714b2f50237d558db 
		EOF
	fi
}
