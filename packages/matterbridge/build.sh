TERMUX_PKG_HOMEPAGE=https://github.com/42wim/matterbridge
TERMUX_PKG_DESCRIPTION="A simple chat bridge"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=1.24.0
TERMUX_PKG_SRCURL=https://github.com/42wim/matterbridge/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=65ee39770b4799ebbe6676206cae3d067b4c7ea29773a1e7fb26c657d4b151a6
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_IN_SRC=true

# ```
# # github.com/Benau/go_rlottie
# <instantiation>:1:1: error: unknown directive
# .func fname
# ^
# <instantiation>:2:5: note: while in macro instantiation
#     pixman_asm_function fname
#     ^
# vector_pixman_pixman-arm-neon-asm.S:337:1: note: while in macro instantiation
# generate_composite_function pixman_composite_over_8888_8888_asm_neon, 32, 0, 32, FLAG_DST_READWRITE | FLAG_DEINTERLEAVE_32BPP, 8, 5, default_init, default_cleanup, pixman_composite_over_8888_8888_process_pixblock_head, pixman_composite_over_8888_8888_process_pixblock_tail, pixman_composite_over_8888_8888_process_pixblock_tail_head
# ^
# ```
TERMUX_PKG_BLACKLISTED_ARCHES="arm"

termux_step_pre_configure() {
	termux_setup_golang

	go mod init || :
	go mod tidy
}

termux_step_make() {
	go build
}

termux_step_make_install() {
	install -Dm700 -t $TERMUX_PREFIX/bin matterbridge
}
