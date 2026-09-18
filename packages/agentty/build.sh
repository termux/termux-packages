TERMUX_PKG_HOMEPAGE=https://github.com/1ay1/agentty
TERMUX_PKG_DESCRIPTION="AI pair programming in your terminal — one binary, any model"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_LICENSE_FILE="LICENSE"
TERMUX_PKG_MAINTAINER="@1ay1"
TERMUX_PKG_VERSION="0.9.2"

# The RELEASE tarball, not a GitHub source archive and not a git clone.
#
# agentty vendors maya / acp-cpp / mcp-cpp / rag-cpp as git submodules, so
# `archive/refs/tags/…` is unbuildable — it contains four empty directories.
# The release artifact is assembled with submodules included, which means
# this recipe needs no network after the source step: no `git submodule
# update`, no configure-time clone.
TERMUX_PKG_SRCURL=https://github.com/1ay1/agentty/releases/download/v${TERMUX_PKG_VERSION}/agentty-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=9dadc6130fba3a5a13ee3728d2e200b063f54fb273cadaa99e33e9439bced6c3
TERMUX_PKG_AUTO_UPDATE=true

TERMUX_PKG_DEPENDS="libc++, libnghttp2, openssl"
# nlohmann-json and simdjson are header/static deps resolved by find_package.
# agentty's CMake declares both with FIND_PACKAGE_ARGS, so a system copy is
# used when present and nothing is downloaded at configure time.
TERMUX_PKG_BUILD_DEPENDS="nlohmann-json, simdjson"

# C++26; Termux's clang handles it. Two flags are load-bearing for packaging:
#
#   AGENTTY_USE_MIMALLOC=OFF — mimalloc is the only dependency with no Termux
#   package and no find_package fallback, so leaving it on would fetch at
#   configure time. Bionic's allocator is fine; the mimalloc win is a
#   desktop-workload optimisation.
#
#   AGENTTY_STANDALONE=OFF — upstream's release binaries are fully static for
#   generic Linux. Termux wants an ordinary dynamically-linked PIE against its
#   own openssl/nghttp2, which is what OFF produces.
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DAGENTTY_AUTO_PULL_SUBMODULES=OFF
-DAGENTTY_BUILD_TESTS=OFF
-DAGENTTY_COMPILER_CACHE=OFF
-DAGENTTY_STANDALONE=OFF
-DAGENTTY_USE_MIMALLOC=OFF
"

termux_step_make_install() {
	install -Dm755 "$TERMUX_PKG_BUILDDIR/agentty" \
		"$TERMUX_PREFIX/bin/agentty"
}
