TERMUX_PKG_HOMEPAGE=https://odin-lang.org/
TERMUX_PKG_DESCRIPTION="The Odin programming language"
TERMUX_PKG_LICENSE="BSD 3-Clause"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2022.01
TERMUX_PKG_SRCURL=https://github.com/odin-lang/Odin/archive/refs/tags/dev-${TERMUX_PKG_VERSION//./-}.tar.gz
TERMUX_PKG_SHA256=44fcae303462f95b042423e93f08e096b14a55f2db1cfcf3d6b5a64f10621833
TERMUX_PKG_DEPENDS="libiconv, libllvm"

# ```
# [...]/src/gb/gb.h:6754:2: error: "gb_rdtsc not supported"
# #error "gb_rdtsc not supported"
#  ^
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	if [ "$TERMUX_PKG_API_LEVEL" -lt 28 ]; then
		CPPFLAGS+=" -Daligned_alloc=memalign"
	fi
	LDFLAGS+=" -lLLVM -liconv"
}

termux_step_make() {
	for s in src/main.cpp src/libtommath.cpp; do
		$CXX $CPPFLAGS $CXXFLAGS -c $TERMUX_PKG_SRCDIR/$s
	done
	$CXX $CXXFLAGS main.o libtommath.o -o odin $LDFLAGS
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin odin
}
