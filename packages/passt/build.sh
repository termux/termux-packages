TERMUX_PKG_HOMEPAGE=https://passt.top/
TERMUX_PKG_DESCRIPTION="Plug A Simple Socket Transport"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_LICENSE_FILE="LICENSES/GPL-2.0-or-later.txt"
TERMUX_PKG_MAINTAINER="JesusChapman <developer@jesuschapman.me>"
TERMUX_PKG_VERSION=2026.10.02
TERMUX_PKG_SRCURL=https://passt.top/passt/snapshot/passt-2026_10_02.cba3570.tar.xz
TERMUX_PKG_SHA256=aa75616cc43925f0bd6c05bcfbbaecd77397c03d7bd23591b34ef535be5dfcdc
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_BUILD_IN_SRC=true

# NOTE: patches 0010-0013 relax startup isolation for sandboxes without
# namespaces/capabilities (Android app): uid_map ENOENT, unprivileged
# early-return, unboundable netlink tolerated with explicit -a/-g/-D/-i,
# prefork isolation skipped. Verified on-device against UML user-mode
# networking (umnet + vec0 fd transport): DHCP, ping and HTTP all OK.

termux_step_make() {
	# The Makefile has no configure step and defaults CC to host cc;
	# point it at the NDK wrapper (also drives TARGET_ARCH detection).
	make CC="$CC" VERSION="$TERMUX_PKG_VERSION" -j"$TERMUX_PKG_MAKE_PROCESSES"
}

termux_step_make_install() {
	local f
	for f in passt pasta pesto passt-repair passt.avx2 pasta.avx2; do
		[ -x "$f" ] && install -Dm700 "$f" "$TERMUX_PREFIX/bin/$f"
	done
	for f in passt pasta pesto passt-repair; do
		[ -f "$f.1" ] && install -Dm600 "$f.1" "$TERMUX_PREFIX/share/man/man1/$f.1"
	done
}
