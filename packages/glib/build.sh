TERMUX_PKG_HOMEPAGE=https://developer.gnome.org/glib/
TERMUX_PKG_DESCRIPTION="Library providing core building blocks for libraries and applications written in C"
TERMUX_PKG_LICENSE="LGPL-2.1"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.80.4"
_gi_version=1.80.1
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=(https://download.gnome.org/sources/glib/${TERMUX_PKG_VERSION%.*}/glib-${TERMUX_PKG_VERSION}.tar.xz
			https://download.gnome.org/sources/gobject-introspection/${_gi_version%.*}/gobject-introspection-${_gi_version}.tar.xz)
TERMUX_PKG_SHA256=(24e029c5dfc9b44e4573697adf33078a9827c48938555004b3b9096fa4ea034f
			a1df7c424e15bda1ab639c00e9051b9adf5cea1a9e512f8a603b53cd199bc6d8)
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libandroid-support, libffi, libiconv, pcre2, resolv-conf, zlib"
TERMUX_PKG_BREAKS="glib-dev"
TERMUX_PKG_REPLACES="glib-dev"
TERMUX_PKG_DISABLE_GIR=false
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-Dintrospection=enabled
-Druntime_dir=$TERMUX_PREFIX/var/run
-Dlibmount=disabled
-Dman-pages=enabled
-Dtests=false
--pkg-config-path=$TERMUX_PKG_BUILDDIR/_prefix/lib/pkgconfig \
"
TERMUX_PKG_RM_AFTER_INSTALL="
bin/glib-gettextize
bin/gtester-report
lib/locale
share/gdb/auto-load
share/glib-2.0/gdb
share/glib-2.0/gettext
share/gtk-doc
"
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS="
-Ddefault_library=static
-Dintrospection=disabled
-Dlibmount=disabled
-Dtests=false
--prefix ${TERMUX_PREFIX}/opt/${TERMUX_PKG_NAME}/cross
"
TERMUX_PKG_NO_SHEBANG_FIX_FILES="
opt/glib/cross/bin/gdbus-codegen
opt/glib/cross/bin/glib-genmarshal
opt/glib/cross/bin/glib-gettextize
opt/glib/cross/bin/glib-mkenums
opt/glib/cross/bin/gtester-report
"

termux_step_host_build() {
	if [[ "${TERMUX_ON_DEVICE_BUILD}" == "true" ]]; then return; fi

	# XXX: termux_setup_meson is not expected to be called in host build
	AR=;CC=;CFLAGS=;CPPFLAGS=;CXX=;CXXFLAGS=;LD=;LDFLAGS=;PKG_CONFIG=;STRIP=
	termux_setup_meson
	unset AR CC CFLAGS CPPFLAGS CXX CXXFLAGS LD LDFLAGS PKG_CONFIG STRIP

	${TERMUX_MESON} setup ${TERMUX_PKG_SRCDIR} . \
		${TERMUX_PKG_EXTRA_HOSTBUILD_CONFIGURE_ARGS}
	ninja -j "${TERMUX_PKG_MAKE_PROCESSES}" install

	# termux_step_massage strip does not cover opt dir
	find "${TERMUX_PREFIX}/opt" \
		-path "*/glib/cross/bin/*" \
		-type f -print0 | \
		xargs -0 -r file | grep -E "ELF .+ (executable|shared object)" | \
		cut -d":" -f1 | xargs -r strip --strip-unneeded --preserve-dates
}

termux_step_pre_configure() {
	# glib checks for __BIONIC__ instead of __ANDROID__:
	CFLAGS+=" -D__BIONIC__=1"

	TERMUX_PKG_VERSION=. termux_setup_gir
	termux_setup_meson

	# Set up bootstrap glib
	echo "Building bootstrap glib"
	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $TERMUX_MESON \
		setup $TERMUX_PKG_SRCDIR \
		$TERMUX_PKG_BUILDDIR \
		--cross-file $TERMUX_MESON_CROSSFILE \
		--prefix $TERMUX_PKG_BUILDDIR/_prefix/ \
		-Dintrospection=disabled \
		-Dman-pages=disabled \
		--buildtype minsize \
		--strip
	ninja -j $TERMUX_PKG_MAKE_PROCESSES -C $TERMUX_PKG_BUILDDIR
	ninja -j $TERMUX_PKG_MAKE_PROCESSES -C $TERMUX_PKG_BUILDDIR install

	echo "Building bootstrap gobject-introspection"
	# Set up bootstrap gobject-introspection
	cd gobject-introspection-${_gi_version}
	sed "s%@PYTHON_VERSION@%$TERMUX_PYTHON_VERSION%g" \
		$TERMUX_PKG_BUILDER_DIR/../gobject-introspection/meson-python.diff | patch --silent -p1

	CPPFLAGS+="
		-I$TERMUX_PREFIX/include/python${TERMUX_PYTHON_VERSION}
		-I$TERMUX_PREFIX/include/python${TERMUX_PYTHON_VERSION}/cpython
		"

	CC=gcc CXX=g++ CFLAGS= CXXFLAGS= CPPFLAGS= LDFLAGS= $TERMUX_MESON \
		setup $TERMUX_PKG_SRCDIR/gobject-introspection-${_gi_version} \
		$TERMUX_PKG_BUILDDIR/gobject-introspection-${_gi_version} \
		--prefix $TERMUX_PKG_BUILDDIR/_prefix/ \
		--cross-file $TERMUX_MESON_CROSSFILE \
		--pkg-config-path=$TERMUX_PKG_BUILDDIR/_prefix/lib/pkgconfig \
		-Dgi_cross_use_prebuilt_gi=true \
		-Dgi_cross_ldd_wrapper=$(command -v ldd) \
		-Dbuild_introspection_data=false \
		-Dcairo=disabled \
		-Ddoctool=disabled \
		-Dpython=python \
		-Dgi_cross_binary_wrapper=$GI_CROSS_LAUNCHER \
		--buildtype minsize \
		--strip
	ninja -j $TERMUX_PKG_MAKE_PROCESSES -C $TERMUX_PKG_BUILDDIR/gobject-introspection-${_gi_version}
	ninja -j $TERMUX_PKG_MAKE_PROCESSES -C $TERMUX_PKG_BUILDDIR/gobject-introspection-${_gi_version} install

	export LD_LIBRARY_PATH=$TERMUX_PKG_BUILDDIR/_prefix/lib
	export PATH=$TERMUX_PKG_BUILDDIR/_prefix/bin:$PATH
}

termux_step_post_make_install() {
	local pc_files=$(ls "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig")
	for pc in ${pc_files}; do
		echo "INFO: Patching cross pkgconfig ${pc}"
		sed "s|\${bindir}|${TERMUX_PREFIX}/opt/glib/cross/bin|g" \
			"${TERMUX_PREFIX}/lib/pkgconfig/${pc}" \
			> "${TERMUX_PREFIX}/opt/glib/cross/lib/x86_64-linux-gnu/pkgconfig/${pc}"
	done
}

termux_step_create_debscripts() {
	for i in postinst postrm triggers; do
		sed \
			"s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
			"${TERMUX_PKG_BUILDER_DIR}/hooks/${i}.in" > ./${i}
		chmod 755 ./${i}
	done
	unset i
	chmod 644 ./triggers
}
