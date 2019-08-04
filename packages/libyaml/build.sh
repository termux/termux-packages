TERMUX_PKG_HOMEPAGE=https://pyyaml.org/wiki/LibYAML
TERMUX_PKG_DESCRIPTION="LibYAML is a YAML 1.1 parser and emitter written in C"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_VERSION=0.2.2
TERMUX_PKG_REVISION=1
TERMUX_PKG_SHA256=46bca77dc8be954686cff21888d6ce10ca4016b360ae1f56962e6882a17aa1fe
TERMUX_PKG_BREAKS="libyaml-dev"
TERMUX_PKG_REPLACES="libyaml-dev"
TERMUX_PKG_SRCURL=https://github.com/yaml/libyaml/archive/$TERMUX_PKG_VERSION.tar.gz

termux_step_pre_configure() {
	./bootstrap
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f libyaml-0.so libyaml.so
}
