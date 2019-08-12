TERMUX_PKG_HOMEPAGE=https://www.oasis-open.org/docbook/
TERMUX_PKG_DESCRIPTION="A widely used XML scheme for writing documentation and help"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=4.5
TERMUX_PKG_REVISION=1
TERMUX_PKG_SKIP_SRC_EXTRACT=yes
TERMUX_PKG_DEPENDS="libxml2-utils"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_extract_package() {
	mkdir -p $TERMUX_PKG_SRCDIR

	cd $TERMUX_PKG_SRCDIR

	termux_download "https://docbook.org/xml/4.1.2/docbkx412.zip" \
		docbkx412.zip \
		30f0644064e0ea71751438251940b1431f46acada814a062870f486c772e7772

	unzip -d docbook-xml-4.1.2 docbkx412.zip

	termux_download "https://docbook.org/xml/4.2/docbook-xml-4.2.zip" \
		"docbook-xml-4.2.zip" \
		acc4601e4f97a196076b7e64b368d9248b07c7abf26b34a02cca40eeebe60fa2

	unzip -d docbook-xml-4.2 docbook-xml-4.2.zip

	termux_download "https://docbook.org/xml/4.3/docbook-xml-4.3.zip" \
		"docbook-xml-4.3.zip" \
		23068a94ea6fd484b004c5a73ec36a66aa47ea8f0d6b62cc1695931f5c143464

	unzip -d docbook-xml-4.3 docbook-xml-4.3.zip

	termux_download "https://docbook.org/xml/4.4/docbook-xml-4.4.zip" \
		"docbook-xml-4.4.zip" \
		02f159eb88c4254d95e831c51c144b1863b216d909b5ff45743a1ce6f5273090

	unzip -d docbook-xml-4.4 docbook-xml-4.4.zip

	termux_download "https://docbook.org/xml/4.5/docbook-xml-4.5.zip" \
		"docbook-xml-4.5.zip" \
		4e4e037a2b83c98c6c94818390d4bdd3f6e10f6ec62dd79188594e26190dc7b4

	unzip -d docbook-xml-4.5 docbook-xml-4.5.zip
}

termux_step_make_install() {
	mkdir -p $TERMUX_PREFIX/etc/xml
	xmlcatalog --noout --create "$TERMUX_PREFIX/etc/xml/docbook-xml"

	local ver
	for ver in 4.1.2 4.{2..5}; do
		pushd docbook-xml-$ver
		mkdir -p "$TERMUX_PREFIX/share/xml/docbook/xml-dtd-$ver"
		cp -dr docbook.cat *.dtd ent/ *.mod \
			"$TERMUX_PREFIX/share/xml/docbook/xml-dtd-$ver"
		popd

		xml=
		case $ver in
			4.1.2) xml=' XML' ;;&
			*)
				xmlcatalog --noout --add "public" \
					"-//OASIS//DTD DocBook XML V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/docbookx.dtd" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//DTD DocBook$xml CALS Table Model V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/calstblx.dtd" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/soextblx.dtd" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//ELEMENTS DocBook$xml Information Pool V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/dbpoolx.mod" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//ELEMENTS DocBook$xml Document Hierarchy V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/dbhierx.mod" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//ENTITIES DocBook$xml Additional General Entities V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/dbgenent.mod" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//ENTITIES DocBook$xml Notations V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/dbnotnx.mod" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "public" \
					"-//OASIS//ENTITIES DocBook$xml Character Entities V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/dbcentx.mod" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
			;;&
			4.[45])
				xmlcatalog --noout --add "public" \
					"-//OASIS//ELEMENTS DocBook XML HTML Tables V$ver//EN" \
					"http://www.oasis-open.org/docbook/xml/$ver/htmltblx.mod" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
			;;&
			*)
				xmlcatalog --noout --add "rewriteSystem" \
					"http://www.oasis-open.org/docbook/xml/$ver" \
					"$TERMUX_PREFIX/share/xml/docbook/xml-dtd-$ver" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
				xmlcatalog --noout --add "rewriteURI" \
					"http://www.oasis-open.org/docbook/xml/$ver" \
					"$TERMUX_PREFIX/share/xml/docbook/xml-dtd-$ver" \
					"$TERMUX_PREFIX/etc/xml/docbook-xml"
			;;&
		esac
	done
}

termux_step_create_debscripts() {
	cat <<- EOF > ./postinst
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "configure" ]; then
		if [ ! -e "$TERMUX_PREFIX/etc/xml/catalog" ]; then
			xmlcatalog --noout --create "$TERMUX_PREFIX/etc/xml/catalog"
		else
			xmlcatalog --noout --del "file://$TERMUX_PREFIX/etc/xml/docbook-xml" \
				$TERMUX_PREFIX/etc/xml/catalog
			xmlcatalog --noout --create "$TERMUX_PREFIX/etc/xml/catalog"
		fi
		xmlcatalog --noout --add "delegatePublic" \
			"-//OASIS//ENTITIES DocBook XML" \
			"file://$TERMUX_PREFIX/etc/xml/docbook-xml" \
			$TERMUX_PREFIX/etc/xml/catalog
		xmlcatalog --noout --add "delegatePublic" \
			"-//OASIS//DTD DocBook XML" \
			"file://$TERMUX_PREFIX/etc/xml/docbook-xml" \
			$TERMUX_PREFIX/etc/xml/catalog
		xmlcatalog --noout --add "delegateSystem" \
			"http://www.oasis-open.org/docbook/" \
			"file://$TERMUX_PREFIX/etc/xml/docbook-xml" \
			$TERMUX_PREFIX/etc/xml/catalog
		xmlcatalog --noout --add "delegateURI" \
			"http://www.oasis-open.org/docbook/" \
			"file://$TERMUX_PREFIX/etc/xml/docbook-xml" \
			$TERMUX_PREFIX/etc/xml/catalog
	fi
	EOF

	cat <<- EOF > ./prerm
	#!$TERMUX_PREFIX/bin/sh
	if [ "\$1" = "remove" ]; then
		xmlcatalog --noout --del "file://$TERMUX_PREFIX/etc/xml/docbook-xml" \
			$TERMUX_PREFIX/etc/xml/catalog
	fi
	EOF
}
