TERMUX_PKG_HOMEPAGE=https://virgil3d.github.io/
TERMUX_PKG_DESCRIPTION="A virtual 3D GPU for use inside qemu virtual machines"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="1.3.0"
_LIBEPOXY_VERSION="1.5.10"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(
	https://gitlab.freedesktop.org/virgl/virglrenderer/-/archive/virglrenderer-${TERMUX_PKG_VERSION}/virglrenderer-virglrenderer-${TERMUX_PKG_VERSION}.tar.gz
	https://github.com/anholt/libepoxy/archive/refs/tags/${_LIBEPOXY_VERSION}.tar.gz
)
TERMUX_PKG_SHA256=(
	56170f8caa1bb642a2624b649e3bcca095ec2834814e5c308efc8a85a709e4ce
	a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15
)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libdrm, libglvnd, mesa, virglrenderer-bin"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="-Dplatforms=egl -Dlibexecdir=libexec/virglrenderer"

termux_step_post_get_source() {
	mv libepoxy-${_LIBEPOXY_VERSION} subprojects/libepoxy
}

termux_step_pre_configure() {
	CPPFLAGS+=" -DTERMUX_PREFIX=\"${TERMUX_PREFIX}\""

	# error: using an array subscript expression within 'offsetof' is a Clang extension [-Werror,-Wgnu-offsetof-extensions]
	# list_for_each_entry_safe(struct vrend_linked_shader_program, ent, &shader->programs, sl[shader->sel->type])
	CPPFLAGS+=" -Wno-error=gnu-offsetof-extensions"

	local origin_rpath='-Wl,-rpath=$ORIGIN'
	LDFLAGS="${LDFLAGS//-Wl,-rpath=${TERMUX_PREFIX}\/lib/${origin_rpath}}"

	if [[ $TERMUX_ARCH != "arm" ]]; then
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" -Dvenus=true"
	fi
}

termux_step_post_make_install() {
	mv "$TERMUX_PREFIX/bin/virgl_test_server" "$TERMUX_PREFIX/libexec/virglrenderer/virgl_test_server"
	ln -sf ../libexec/virglrenderer/virgl_test_server "$TERMUX_PREFIX/bin/virgl_test_server"
	ln -sf ../libexec/virglrenderer/virgl_test_server "$TERMUX_PREFIX/bin/virgl_test_server_android"

	# Move out of $PREFIX/lib so virgl_test_server's $ORIGIN rpath resolves it directly,
	# instead of picking up whatever else is installed to $PREFIX/lib.
	mv "$TERMUX_PREFIX/lib"/libvirglrenderer.so* "$TERMUX_PREFIX/libexec/virglrenderer/"
	# Lets other packages link against the usual $PREFIX/lib path.
	ln -sf ../libexec/virglrenderer/libvirglrenderer.so "$TERMUX_PREFIX/lib/libvirglrenderer.so"
}

termux_step_install_license() {
	mkdir -p "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME"
	cp "$TERMUX_PKG_SRCDIR/COPYING" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-virglrenderer"
	cp "$TERMUX_PKG_SRCDIR/subprojects/libepoxy/COPYING" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-libepoxy"
	cp "$TERMUX_PKG_BUILDER_DIR/COPYING-gl4es" "$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/COPYING-gl4es"
}
