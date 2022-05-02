TERMUX_PKG_HOMEPAGE=https://www.abisource.com/
TERMUX_PKG_DESCRIPTION="A free word processing program"
TERMUX_PKG_LICENSE="GPL-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=3.0.5
TERMUX_PKG_SRCURL=https://www.abisource.com/downloads/abiword/${TERMUX_PKG_VERSION}/source/abiword-${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_SHA256=1257247e9970508d6d1456d3e330cd1909c4b42b25e0f0a1bc32526d6f3a21b4
TERMUX_PKG_DEPENDS="enchant, fribidi, glib, goffice, gtk3, libc++, libcairo, libgcrypt, libgsf, libical, libjpeg-turbo, libpng, librsvg, libwv, libxml2, libxslt, readline"
TERMUX_PKG_BUILD_DEPENDS="boost, boost-headers"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--disable-default-plugins
--enable-plugins=applix,babelfish,bmp,clarisworks,command,docbook,eml,epub,freetranslation,garble,gdict,gimp,goffice,google,hancom,hrtext,iscii,kword,latex,loadbindings,mif,mswrite,openwriter,openxml,opml,passepartout,pdb,pdf,presentation,s5,sdw,t602,urldict,wikipedia,wml,xslfo
--disable-builtin-plugins
--disable-print
--enable-spell
--enable-statusbar
--enable-clipart
--enable-templates
--disable-collab-backend-telepathy
--disable-collab-backend-xmpp
--disable-collab-backend-tcp
--disable-collab-backend-sugar
--disable-collab-backend-service
--disable-introspection
--without-gtk2
--with-goffice
--without-redland
--without-evolution-data-server
--without-champlain
--without-inter7eps
--without-libtidy
"

termux_step_pre_configure() {
	autoreconf -fi

	LDFLAGS+=" $($CC -print-libgcc-file-name)"
}
