TERMUX_PKG_HOMEPAGE=https://pyyaml.org/wiki/LibYAML
TERMUX_PKG_DESCRIPTION="LibYAML is a YAML 1.1 parser and emitter written in C"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.2.4
TERMUX_PKG_REVISION=1
TERMUX_PKG_SRCURL=https://github.com/yaml/libyaml/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=02265e0229675aea3a413164b43004045617174bdb2c92bf6782f618f8796b55
TERMUX_PKG_BREAKS="libyaml-dev"
TERMUX_PKG_REPLACES="libyaml-dev"

termux_step_pre_configure() {
	./bootstrap
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f libyaml-0.so libyaml.so
}
