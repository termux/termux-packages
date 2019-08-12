TERMUX_PKG_HOMEPAGE=http://elixir-lang.org/
TERMUX_PKG_DESCRIPTION="Dynamic and functional language leveraging the Erlang VM"
TERMUX_PKG_VERSION=1.3.4
TERMUX_PKG_SRCURL=https://github.com/elixir-lang/elixir/archive/v${TERMUX_PKG_VERSION}.tar.gz
TERMUX_PKG_DEPENDS="erlang"
# TERMUX_PKG_EXTRA_CONFIGURE_ARGS="--with-ssl=openssl --disable-iri"
TERMUX_PKG_BUILD_IN_SRC=true
