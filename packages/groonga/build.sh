TERMUX_PKG_HOMEPAGE=https://github.com/groonga/groonga/
TERMUX_PKG_DESCRIPTION="An embeddable fulltext search engine"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="15.2.3"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://github.com/groonga/groonga/releases/download/v${TERMUX_PKG_VERSION}/groonga-${TERMUX_PKG_VERSION}.tar.gz"
TERMUX_PKG_SHA256=0f02cd5e1abf69dada8d7d875f40a9afa5014fcc8c0d645f6bfb180e718ea672
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_FORCE_CMAKE=true
TERMUX_PKG_DEPENDS="libandroid-execinfo, libarrow-cpp, libc++, liblz4, libstemmer, onigmo, simdjson, xxhash, zlib, zstd"
TERMUX_PKG_BUILD_DEPEPNDS="rapidjson"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DGRN_WITH_APACHE_ARROW=ON
-DGRN_WITH_LIBSTEMMER=system
-DGRN_WITH_LZ4=system
-DGRN_WITH_ONIGMO=ON
-DGRN_WITH_BUNDLED_ONIGMO=OFF
-DGRN_WITH_RAPIDJSON=system
-DGRN_WITH_SIMDJSON=system
-DGRN_WITH_XXHASH=system
-DGRN_WITH_ZLIB=system
-DGRN_WITH_ZSTD=system
-DGRN_WITH_OPENZL=no
"

termux_step_pre_configure() {
	# llama.cpp fails to build for 32 bit targets
	if [ "$TERMUX_ARCH" = i686 ] || [ "$TERMUX_ARCH" = arm ]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -DGRN_WITH_LLAMA_CPP=no"
	fi

	LDFLAGS+=" -fopenmp -static-openmp"
}
