TERMUX_PKG_HOMEPAGE=https://www.codeblocks.org/
TERMUX_PKG_DESCRIPTION="Code::Blocks is the Integrated Development Environment (IDE)"
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="25.03"
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL="https://sourceforge.net/projects/codeblocks/files/Sources/${TERMUX_PKG_VERSION}/codeblocks_${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=b0f6aa5908d336d7f41f9576b2418ac7d27efbc59282aa8c9171d88cea74049e
TERMUX_PKG_DEPENDS="aterm, codeblocks-data, glib, gtk3, hunspell, libc++, wxwidgets, zip"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_HOSTBUILD=true

termux_step_host_build() {
	"${TERMUX_PKG_SRCDIR}/configure"
	make -j "$TERMUX_PKG_MAKE_PROCESSES" -C src/base
	make -j "$TERMUX_PKG_MAKE_PROCESSES" -C src/build_tools
}

termux_step_pre_configure() {
	local _libgcc_file="$($CC -print-libgcc-file-name)"
	local _libgcc_path="$(dirname "$_libgcc_file")"
	local _libgcc_name="$(basename "$_libgcc_file")"
	LDFLAGS+=" -L$_libgcc_path -l:$_libgcc_name"

	LDFLAGS+=" -Wl,-rpath=$TERMUX_PREFIX/lib/codeblocks/wxContribItems"

	find "$TERMUX_PKG_SRCDIR/src" -type f -print0 | \
		xargs -0 sed -i \
		-e "s|/usr|$TERMUX_PREFIX|g"

	autoreconf -fi

	# make sure that when this file no longer exists, this block is removed.
	# (context: the Ubuntu 24.04 builder image has autoconf-archive 20220903-3,
	# and this conflicts with the use of 'autoreconf -fi'
	# in packages which are being built against boost 1.89 or newer)
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local file=/usr/share/aclocal/ax_boost_system.m4
		if [[ ! -f "$file" ]]; then
			termux_error_exit "$file no longer exists. Please edit $TERMUX_PKG_NAME's build.sh to remove this block."
		fi
		# remove this line too after the above check fails
		# (it willl no longer be necessary when the above check fails):
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" ax_cv_boost_system=yes --without-boost-system"
	fi

	local plugins=''
	plugins+="AutoVersioning,"
	plugins+="BrowseTracker,"
	plugins+="byogames,"
	plugins+="cbkoders,"
	plugins+="Cccc,"
	plugins+="clangd_client,"
	plugins+="codesnippets,"
	plugins+="codestat,"
	plugins+="copystrings,"
	plugins+="CppCheck,"
	plugins+="Cscope,"
	plugins+="DoxyBlocks,"
	plugins+="dragscroll,"
	plugins+="EditorConfig,"
	plugins+="EditorTweaks,"
	plugins+="envvars,"
	plugins+="exporter,"
	# Arch Linux disables FileManager because it has an issue involving wxwidgets
	#plugins+="FileManager,"
	plugins+="headerfixup,"
	plugins+="help,"
	plugins+="hexeditor,"
	plugins+="incsearch,"
	plugins+="keybinder,"
	plugins+="libfinder,"
	plugins+="MouseSap,"
	plugins+="NassiShneiderman,"
	plugins+="profiler,"
	plugins+="ProjectOptionsManipulator,"
	plugins+="regex,"
	plugins+="ReopenEditor,"
	plugins+="rndgen,"
	plugins+="smartindent,"
	plugins+="spellchecker,"
	plugins+="symtab,"
	plugins+="ThreadSearch,"
	plugins+="ToolsPlus,"
	plugins+="Valgrind"
	# plugins+="wxcontrib,"
	# plugins+="wxsmith,"
	# plugins+="wxsmithaui,"
	# plugins+="wxsmithcontrib"
	TERMUX_PKG_EXTRA_CONFIGURE_ARGS+=" --with-contrib-plugins=$plugins"
}

termux_step_post_configure() {
	sed -i 's/ -shared / -Wl,-O1,--as-needed\0/g' ./libtool
	cp -r "$TERMUX_PKG_HOSTBUILD_DIR/src/build_tools" ./src/

	# We need to make sure the files are edited (or have their last modified date)
	# in a specific order to avoid accidentally triggering a recompilation.
	for file in ./src/build_tools/autorevision/{Makefile,autorevision.o,auto_revision}; do
		touch "${file}"
		sleep 0.1
	done
}
