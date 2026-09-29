TERMUX_PKG_HOMEPAGE=https://github.com/openstreetmap/OSM-binary/
TERMUX_PKG_DESCRIPTION="osmpbf is a Java/C library to read and write OpenStreetMap PBF files"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.8.0"
TERMUX_PKG_SRCURL="https://github.com/openstreetmap/OSM-binary/archive/refs/tags/v${TERMUX_PKG_VERSION}.zip"
TERMUX_PKG_SHA256=72d4a6abe7d98bd02febea5459477988862164d861b8c0163ba87f88cc034bf0
TERMUX_PKG_DEPENDS="libc++, libprotobuf"
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_GROUPS="science"

termux_step_pre_configure() {
	termux_setup_protobuf

	CPPFLAGS+=" -DPROTOBUF_USE_DLLS"

	# the error for 32-bit targets if this is not used looks like this:
	# ld.lld: error: undefined symbol: char const*
	# absl::lts_20250127::log_internal::MakeCheckOpString<long
	# long, long long>(long long, long long, char const*)
	# >>> referenced by osmformat.pb.cc
	# >>>               osmformat.pb.cc.o:(google::protobuf::RepeatedField<int>::GrowNoAnnotate(bool,
	# int, int)) in archive osmpbf/libosmpbf.a
	LDFLAGS+=" $($TERMUX_SCRIPTDIR/packages/libprotobuf/interface_link_libraries.sh)"
}
