TERMUX_PKG_HOMEPAGE=https://libdatachannel.org/
TERMUX_PKG_DESCRIPTION="C/C++ WebRTC network library featuring Data Channels, Media Transport, and WebSockets"
TERMUX_PKG_LICENSE="MPL-2.0, MIT, BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=(
	"0.24.2"
	"1.1.11"
	"0.9.5.0"
	"1.7.1"
	"2.8.0"
)
TERMUX_PKG_SRCURL=(
	"https://github.com/paullouisageneau/libdatachannel/archive/refs/tags/v${TERMUX_PKG_VERSION[0]}.tar.gz"
	"https://github.com/SergiusTheBest/plog/archive/refs/tags/${TERMUX_PKG_VERSION[1]}.tar.gz"
	"https://github.com/sctplab/usrsctp/archive/refs/tags/${TERMUX_PKG_VERSION[2]}.tar.gz"
	"https://github.com/paullouisageneau/libjuice/archive/refs/tags/v${TERMUX_PKG_VERSION[3]}.tar.gz"
	"https://github.com/cisco/libsrtp/archive/refs/tags/v${TERMUX_PKG_VERSION[4]}.tar.gz"
)
TERMUX_PKG_SHA256=(
	91a4795c98e13e91935127ab7880109309bf35b5e5a96c8fcc08e08322576402
	d60b8b35f56c7c852b7f00f58cbe9c1c2e9e59566c5b200512d0cdbb6309a7c2
	260107caf318650a57a8caa593550e39bca6943e93f970c80d6c17e59d62cd92
	c127629ff42b9fffc06c65e94abb25fce03856160ce05d9fdfdad4ed80ea59bf
	d123dcff5c56d4f1a9006f2b311ea99a85016cbf3bb24b1007885d422237db85
)
TERMUX_PKG_DEPENDS="openssl"
TERMUX_PKG_BUILD_DEPENDS="nlohmann-json"
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DUSE_GNUTLS=OFF
-DUSE_NICE=OFF
-DNO_EXAMPLES=ON
-DNO_TESTS=ON
-DUSE_SYSTEM_JSON=ON
-DCMAKE_POLICY_VERSION_MINIMUM=3.5
"

termux_step_post_get_source() {
	# Remove the empty placeholder folders
	rm -rf deps/plog deps/usrsctp deps/libjuice deps/libsrtp

	# Move the extracted GitHub folders into their correct deps/ locations
	mv "plog-${TERMUX_PKG_VERSION[1]}" deps/plog
	mv "usrsctp-${TERMUX_PKG_VERSION[2]}" deps/usrsctp
	mv "libjuice-${TERMUX_PKG_VERSION[3]}" deps/libjuice
	mv "libsrtp-${TERMUX_PKG_VERSION[4]}" deps/libsrtp
}
