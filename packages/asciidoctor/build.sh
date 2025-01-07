TERMUX_PKG_HOMEPAGE=https://asciidoctor.org/
TERMUX_PKG_DESCRIPTION="An implementation of AsciiDoc in Ruby"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.0.23
TERMUX_PKG_AUTO_UPDATE=false
TERMUX_PKG_DEPENDS="ruby"
TERMUX_PKG_SKIP_SRC_EXTRACT=true
TERMUX_PKG_BUILD_IN_SRC=true
TERMUX_PKG_PLATFORM_INDEPENDENT=true

termux_step_pre_configure() {
	ruby_version=$(. $TERMUX_SCRIPTDIR/packages/ruby/build.sh; echo $TERMUX_PKG_VERSION)
}

termux_step_make_install() {
	local gemdir="$TERMUX_PREFIX/lib/ruby/gems/${ruby_version:0:3}.0"

	rm -rf "$gemdir/asciidoctor-$TERMUX_PKG_VERSION"
	rm -rf "$gemdir/doc/asciidoctor-$TERMUX_PKG_VERSION"

	gem install --ignore-dependencies --no-user-install --verbose \
		-i "$gemdir" -n "$TERMUX_PREFIX/bin" asciidoctor -v "$TERMUX_PKG_VERSION"

	sed -i -E "1 s@^(#\!)(.*)@\1${TERMUX_PREFIX}/bin/ruby@" \
		"$TERMUX_PREFIX/bin/asciidoctor"

	install -Dm600 "$gemdir/gems/asciidoctor-${TERMUX_PKG_VERSION}/man/asciidoctor.1" \
		"$TERMUX_PREFIX/share/man/main1/asciidoctor.1"
}

termux_step_install_license() {
	local gemdir="$TERMUX_PREFIX/lib/ruby/gems/${ruby_version:0:3}.0"
	mkdir -p $TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME
	cp $gemdir/gems/asciidoctor-${TERMUX_PKG_VERSION}/LICENSE \
		$TERMUX_PREFIX/share/doc/$TERMUX_PKG_NAME/
}
