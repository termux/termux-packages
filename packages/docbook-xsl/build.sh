TERMUX_PKG_HOMEPAGE=https://docbook.org/
TERMUX_PKG_DESCRIPTION="XML stylesheets for Docbook-xml transformations"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=1.79.2
TERMUX_PKG_DEPENDS="docbook-xml, libxml2-utils, xsltproc"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_extract_package() {
	mkdir -p $TERMUX_PKG_SRCDIR

	cd $TERMUX_PKG_SRCDIR

	termux_download "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F${TERMUX_PKG_VERSION}/docbook-xsl-$TERMUX_PKG_VERSION.tar.gz" \
		$TERMUX_PKG_CACHEDIR/docbook-xsl-$TERMUX_PKG_VERSION.tar.gz \
		966188d7c05fc76eaca115a55893e643dd01a3486f6368733c9ad974fcee7a26

	tar xf $TERMUX_PKG_CACHEDIR/docbook-xsl-$TERMUX_PKG_VERSION.tar.gz

	termux_download "https://github.com/docbook/xslt10-stylesheets/releases/download/release%2F${TERMUX_PKG_VERSION}/docbook-xsl-nons-$TERMUX_PKG_VERSION.tar.gz" \
		$TERMUX_PKG_CACHEDIR/docbook-xsl-nons-$TERMUX_PKG_VERSION.tar.gz \
		f89425b44e48aad24319a2f0d38e0cb6059fdc7dbaf31787c8346c748175ca8e

	tar xf $TERMUX_PKG_CACHEDIR/docbook-xsl-nons-$TERMUX_PKG_VERSION.tar.gz
}

termux_step_patch_package() {
	cd $TERMUX_PKG_SRCDIR/docbook-xsl-$TERMUX_PKG_VERSION
	patch -Np2 -i $TERMUX_PKG_BUILDER_DIR/765567_non-recursive_string_subst.patch

	cd $TERMUX_PKG_SRCDIR/docbook-xsl-nons-$TERMUX_PKG_VERSION
	patch -Np2 -i $TERMUX_PKG_BUILDER_DIR/765567_non-recursive_string_subst.patch
}

termux_step_make_install() {
	local pkgroot ns dir

	for ns in -nons ''; do
		pkgroot="$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-${TERMUX_PKG_VERSION}${ns}"
		dir=docbook-xsl${ns}-${TERMUX_PKG_VERSION}

		install -Dt "$pkgroot" -m600 $dir/VERSION{,.xsl}

		(
			shopt -s nullglob  # ignore missing files
			for fn in assembly common eclipse epub epub3 fo highlighting html \
				htmlhelp javahelp lib manpages params profiling roundtrip template \
				website xhtml xhtml-1_1 xhtml5
			do
				install -Dt "${pkgroot}/${fn}" -m600 ${dir}/${fn}/*.{xml,xsl,dtd,ent}
			done
		)
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ]; then
		if [ ! -e "$TERMUX_PREFIX/etc/xml/catalog" ]; then
			xmlcatalog --noout --create "$TERMUX_PREFIX/etc/xml/catalog"
		else
			xmlcatalog --noout --del "$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-$TERMUX_PKG_VERSION" \
				"$TERMUX_PREFIX/etc/xml/catalog"
		fi

		for ver in $TERMUX_PKG_VERSION current; do
			for x in rewriteSystem rewriteURI; do
				xmlcatalog --noout --add \$x http://cdn.docbook.org/release/xsl/\$ver \
					"$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-$TERMUX_PKG_VERSION" \
					"$TERMUX_PREFIX/etc/xml/catalog"

				xmlcatalog --noout --add \$x http://docbook.sourceforge.net/release/xsl-ns/\$ver \
					"$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-$TERMUX_PKG_VERSION" \
					"$TERMUX_PREFIX/etc/xml/catalog"

				xmlcatalog --noout --add \$x http://docbook.sourceforge.net/release/xsl/\$ver \
					"$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-${TERMUX_PKG_VERSION}-nons" \
					"$TERMUX_PREFIX/etc/xml/catalog"
			done
		done
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ]; then
		xmlcatalog --noout --del "$TERMUX_PREFIX/share/xml/docbook/xsl-stylesheets-$TERMUX_PKG_VERSION" \
			"$TERMUX_PREFIX/etc/xml/catalog"
	fi
	EOF
}
