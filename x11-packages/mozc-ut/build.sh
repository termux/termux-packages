TERMUX_PKG_HOMEPAGE=https://github.com/fcitx/mozc
TERMUX_PKG_DESCRIPTION="Mozc is a Japanese Input Method Editor (IME) designed for multi-platform with UT dictionary"
TERMUX_PKG_LICENSE="custom"
_MOZC_VERSION=2.29.5374.102
_UT_VERSION=20240705
_GIT_COMMIT=c687b82fccd443917359a5c2a7b9b1c5fd3737c9
TERMUX_PKG_VERSION=$_MOZC_VERSION.$_UT_VERSION
TERMUX_PKG_MAINTAINER="MURAMATSU Atsushi @amuramatsu"
TERMUX_PKG_SRCURL=git+https://github.com/fcitx/mozc
TERMUX_PKG_GIT_BRANCH=fcitx
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_DEPENDS="libc++, libandroid-posix-semaphore, libandroid-execinfo, libiconv, qt5-qtbase"

_MERGE_UT_REPO=https://github.com/utuhiro78/merge-ut-dictionaries.git
_MERGE_UT_COMMIT=dbf3e9ccd711be39749cbf38baee99adbb2bad6f
_MOZC_CONFIG_REPO=https://github.com/hidegit/mozc-config.git
_MOZC_CONFIG_COMMIT=79bd032431320dbb79d3e16d41686e5a58f22218
_MOZCTOROKU_REPO=https://github.com/amuramatsu/mozctoroku.git
_MOZCTOROKU_COMMIT=fb2f064c3a8e36df3f4a9115434d5564c9b551d8

termux_step_post_get_source() {
	git fetch --unshallow
	git reset --hard $_GIT_COMMIT
	git submodule update --recursive
	grep -r -w -l __ANDROID__ | while read line; do
		sed -i.bak 's/__ANDROID__/XXX__ANDROID__XXX/g' "$line"
	done
	
	git clone $_MERGE_UT_REPO merge-ut
	(cd merge-ut && \
	 git reset --hard $_MERGE_UT_COMMIT && \
	 cd src && \
	 sh "$TERMUX_PKG_BUILDER_DIR/merge-ut-dict.sh" $_UT_VERSION)
	cat merge-ut/src/mozcdic-ut.txt \
		>> src/data/dictionary_oss/dictionary00.txt

	git clone $_MOZC_CONFIG_REPO mozc-config
	(cd mozc-config && git reset --hard $_MOZC_CONFIG_COMMIT)
	git clone $_MOZCTOROKU_REPO mozctoroku
	(cd mozctoroku && git reset --hard $_MOZCTOROKU_COMMIT)
}

termux_step_configure () {
        LDFLAGS="${LDFLAGS/-static-openmp/}"
        LDFLAGS="${LDFLAGS/-fopenmp/}"
        LDFLAGS+=" -landroid-posix-semaphore -landroid-execinfo"
	termux_setup_cmake
	termux_setup_ninja
	
	cd "$TERMUX_PKG_SRCDIR/src"
	GYP_DEFINES="include_dirs=$TERMUX_PREFIX/include, library_dirs=$TERMUX_PREFIX/lib" \
	  python build_mozc.py gyp \
		--gypdir=$TERMUX_PKG_SRCDIR/src/third_party/gyp \
		--target_platform=Linux \
		--server_dir=$TERMUX_PREFIX/lib/mozc
}

termux_step_make () {
        LDFLAGS="${LDFLAGS/-static-openmp/}"
        LDFLAGS="${LDFLAGS/-fopenmp/}"
        LDFLAGS+=" -landroid-posix-semaphore -landroid-execinfo"
	cd "$TERMUX_PKG_SRCDIR/src"
	python build_mozc.py build -c Release package || true
	python build_mozc.py build -c Release unixemacs/emacs.gyp:mozc_emacs_helper || true
	python build_mozc.py build -c Release unixfcitx5/fcitx5.gyp:fcitx5-mozc || true
	cd "$TERMUX_PKG_SRCDIR/mozc-config"
	make mozc-config mozc-dict
}

termux_step_make_install () {
	local _release_dir=src/out_linux/Release
        local _doc_destdir="${TERMUX_PREFIX}/share/doc/mozc-ut"
        local _elisp_destdir="${TERMUX_PREFIX}/share/emacs/site-lisp/mozc-emacs"
	local _fcitx5_destdir="${TERMUX_PREFIX}/lib/fcitx5"
	local _icons_destdir="${TERMUX_PREFIX}/share/icons/hicolor"
	
	cd "$TERMUX_PKG_SRCDIR"

	# mozc
	install -d -m 755 "${TERMUX_PREFIX}/lib/mozc"
	install -c -m 755 \
		"${_release_dir}/mozc_server" "${TERMUX_PREFIX}/lib/mozc"
	${STRIP} -g "${TERMUX_PREFIX}/lib/mozc/mozc_server"
	install -c -m 755 \
		"${_release_dir}/mozc_tool" "${TERMUX_PREFIX}/lib/mozc"
	${STRIP} -g "${TERMUX_PREFIX}/lib/mozc/mozc_tool"
	install -d -m 755 "$_doc_destdir"
	install -c -m 644 src/data/installer/*.html "$_doc_destdir"

	# fcitx5-mozc
	install -d -m 755 "$_fcitx5_destdir"
	install -c -m 755 "${_release_dir}/fcitx5-mozc.so" "$_fcitx5_destdir"
	${STRIP} -g "$_fcitx5_destdir/fcitx5-mozc.so"
	for pofile in src/unix/fcitx5/po/*.po; do
		filename="$(basename "$pofile")"
		lang=${filename/.po/}
		mofile=${filename/.po/.mo}
		msgfmt $pofile -o "$TERMUX_PKG_TMPDIR/$mofile"
		install -d -m 755 "${TERMUX_PREFIX}/share/locale/$lang/LC_MESSAGES"
		install -c -m 644 "$TERMUX_PKG_TMPDIR/$mofile" \
			"${TERMUX_PREFIX}/share/locale/$lang/LC_MESSAGES/fcitx5-mozc.mo"
		rm -f "$TERMUX_PKG_TMPDIR/$mofile"
	done
	install -d -m 755 "${TERMUX_PREFIX}/share/fcitx5/addon"
	install -c -m 644 src/unix/fcitx5/mozc-addon.conf \
		"${TERMUX_PREFIX}/share/fcitx5/addon/mozc.conf"
	install -d -m 755 "${TERMUX_PREFIX}/share/fcitx5/inputmethod"
	install -c -m 644 src/unix/fcitx5/mozc.conf \
		"${TERMUX_PREFIX}/share/fcitx5/inputmethod/mozc.conf"
	for d in "$_icons_destdir/128x128/apps" "$_icons_destdir/32x32/apps" "$_icons_destdir/48x48/apps"; do
		install -d -m 755 "$d"
	done
	install -c -m 644 src/data/images/product_icon_32bpp-128.png \
		"$_icons_destdir/128x128/apps/org.fcitx.Fcitx5.fcitx-mozc.png"
	install -c -m 644 src/data/images/unix/ime_product_icon_opensource-32.png \
		"$_icons_destdir/32x32/apps/org.fcitx.Fcitx5.fcitx-mozc.png"
	for f in scripts/icons/ui-*.png; do
		filename="$(basename "$f")"
	    	iconname=$(echo $filename|sed -e 's/^ui-/org.fcitx.Fcitx5.fcitx-mozc-/' -e 's/_/-/g')
		install -c -m 644 "$f" \
			"$_icons_destdir/48x48/apps/$iconname"
	done
	install -d -m 755 "${TERMUX_PREFIX}/share/metainfo"
	msgfmt --xml -d src/unix/fcitx5/po/ \
		--template src/unix/fcitx5/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml.in \
		-o "$TERMUX_PKG_TMPDIR/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml"
	install -c -m 644 "$TERMUX_PKG_TMPDIR/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml" \
		"${TERMUX_PREFIX}/share/metainfo/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml"
	rm -f "$TERMUX_PKG_TMPDIR/org.fcitx.Fcitx5.Addon.Mozc.metainfo.xml"
	
	# emacs-mozc
	install -c -m 755 \
		"${_release_dir}/mozc_emacs_helper" "${TERMUX_PREFIX}/bin"
	${STRIP} -g "${TERMUX_PREFIX}/bin/mozc_emacs_helper"
	install -d -m 755 "$_elisp_destdir"
	install -c -m 644 \
		src/unix/emacs/mozc.el "$_elisp_destdir"
	
	# mozc-config
	install -c -m 755 \
		mozc-config/mozc-config "${TERMUX_PREFIX}/bin"
	${STRIP} -g "${TERMUX_PREFIX}/bin/mozc-config"
	install -c -m 755 \
		mozc-config/mozc-dict "${TERMUX_PREFIX}/bin"
	${STRIP} -g "${TERMUX_PREFIX}/bin/mozc-dict"
	install -c -m 644 \
		mozc-config/README "$_doc_destdir/README.mozc-config"

	# mozctoroku
	install -d -m 755 "$_elisp_destdir"
	install -c -m 644 \
		mozctoroku/*.el "$_elisp_destdir"
	install -d -m 755 "$_doc_destdir/mozctoroku"
	install -c -m 644 \
		mozctoroku/README* "$_doc_destdir/mozctoroku"
	install -c -m 644 \
		mozctoroku/HISTORY* "$_doc_destdir/mozctoroku"
	install -c -m 644 \
		mozctoroku/COPYING "$_doc_destdir/mozctoroku"
}

termux_step_install_license () {
	install -d -m 755 "${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}"
	install -m 644 \
		"${TERMUX_PKG_SRCDIR}/LICENSE" \
		"${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/LICENSE.mozc"
	install -m 644 \
		"${TERMUX_PKG_SRCDIR}/merge-ut/LICENSE" \
		"${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/LICENSE.mozcdic-ut"
	install -m 644 \
		"${TERMUX_PKG_SRCDIR}/mozc-config/README" \
		"${TERMUX_PREFIX}/share/doc/${TERMUX_PKG_NAME}/README.mozc-config"
}
