TERMUX_PKG_HOMEPAGE=https://virgil3d.github.io/
TERMUX_PKG_DESCRIPTION="A virtual 3D GPU for use inside qemu virtual machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.2.0"
TERMUX_PKG_SRCURL=https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-${TERMUX_PKG_VERSION}/virglrenderer-virglrenderer-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=b181b668afae817953c84635fac2dc4c2e5786c710b7d225ae215d15674a15c7
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libdrm, libepoxy, libglvnd, libx11, mesa"
TERMUX_PKG_BUILD_DEPENDS="xorgproto"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dplatforms=egl,glx"

termux_step_pre_configure() {
	# error: using an array subscript expression within 'offsetof' is a Clang extension [-Werror,-Wgnu-offsetof-extensions]
	# list_for_each_entry_safe(struct vrend_linked_shader_program, ent, &shader->programs, sl[shader->sel->type])
	CPPFLAGS+=" -Wno-error=gnu-offsetof-extensions"
}
