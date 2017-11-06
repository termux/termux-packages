local OCAML_MAJORVERSION=4.05
local OCAML_MINORVERSION=0
TERMUX_PKG_VERSION=$OCAML_MAJORVERSION.$OCAML_MINORVERSION
TERMUX_PKG_HOMEPAGE=https://ocaml.org
local TARNAME=ocaml-$TERMUX_PKG_VERSION.tar.xz
TERMUX_PKG_DESCRIPTION="OCaml is an industrial strength programming language supporting functional, imperative and object-oriented styles"
TERMUX_PKG_VERSION=$OCAML_MAJORVERSION.$OCAML_MINORVERSION
TERMUX_PKG_SRCURL="SRCURL=http://caml.inria.fr/pub/distrib/ocaml-${OCAML_MAJORVERSION}/${TARNAME}"
TERMUX_PKG_SHA256=04a527ba14b4d7d1b2ea7b2ae21aefecfa8d304399db94f35a96df1459e02ef9
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_KEEP_STATIC_LIBRARIES=true
TERMUX_PKG_DEPENDS=opam
termux_step_configure() {
	termux_setup_ocaml
	./configure -fPIC -cc "$TERMUX_HOST_PLATFORM-clang" -aspp "$CC -no-integrated-as -c"  --prefix "$TERMUX_PREFIX" \
	          -target-bindir $TERMUX_PREFIX/bin --target "$TERMUX_HOST_PLATFORM"

}
termux_step_make() {

	sed -i "s/-O2/${CFLAGS}/g" config/Makefile
       
	make world.opt -j $TERMUX_MAKE_PROCESSES  || true
	make world.opt
}
