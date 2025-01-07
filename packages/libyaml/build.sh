TERMUX_PKG_HOMEPAGE=https://pyyaml.org/wiki/LibYAML
TERMUX_PKG_DESCRIPTION="LibYAML is a YAML 1.1 parser and emitter written in C"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=0.2.5
TERMUX_PKG_REVISION=4
TERMUX_PKG_SRCURL=https://github.com/yaml/libyaml/archive/$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=fa240dbf262be053f3898006d502d514936c818e422afdcf33921c63bed9bf2e
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_BREAKS="libyaml-dev"
TERMUX_PKG_REPLACES="libyaml-dev"

termux_step_post_get_source() {
	# Do not forget to bump revision of reverse dependencies and rebuild them
	# after RELEASE / SOVERSION is changed.
	local _RELEASE=0
	local _SOVERSION=2

	local a
	for a in YAML_RELEASE YAML_CURRENT YAML_AGE; do
		local _${a}=$(sed -En 's/^m4_define\(\['"${a}"'\],\s*([0-9]+).*/\1/p' \
				configure.ac)
	done
	local v=$(( _YAML_CURRENT - _YAML_AGE ))
	if [ "${_RELEASE}" != "${_YAML_RELEASE}" ] || \
		[ ! "${_YAML_CURRENT}" ] || [ "${_SOVERSION}" != "${v}" ]; then
		termux_error_exit "SOVERSION guard check failed."
	fi
}

termux_step_pre_configure() {
	./bootstrap
}

termux_step_post_make_install() {
	cd $TERMUX_PREFIX/lib
	ln -s -f libyaml-0.so libyaml.so
}
