TERMUX_PKG_HOMEPAGE="https://invent.kde.org/plasma/breeze-gtk"
TERMUX_PKG_DESCRIPTION="Breeze widget theme for GTK 2 and 3"
TERMUX_PKG_LICENSE="LGPL-2.0-or-later"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="6.6.0"
TERMUX_PKG_SRCURL="https://download.kde.org/stable/plasma/${TERMUX_PKG_VERSION}/breeze-gtk-${TERMUX_PKG_VERSION}.tar.xz"
TERMUX_PKG_SHA256=de64d1ade6deb440220106d3946fe99fd4404bc598b0bb466b353a668ad9bdb8
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_DEPENDS="libc++"
TERMUX_PKG_BUILD_DEPENDS="breeze, extra-cmake-modules, pycairo, sassc"
TERMUX_PKG_PLATFORM_INDEPENDENT=true
TERMUX_PKG_HOSTBUILD=true
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
-DCMAKE_SYSTEM_NAME=Linux
-DKDE_INSTALL_QMLDIR=lib/qt6/qml
-DKDE_INSTALL_QTPLUGINDIR=lib/qt6/plugins
"

termux_step_host_build() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	local hostbuild_python_version
	hostbuild_python_version="$(python -c "import platform; print(platform.python_version())")"
	hostbuild_python_version="${hostbuild_python_version%.*}"

	termux_download_ubuntu_packages \
		libpython3-dev \
		libpython"$hostbuild_python_version"-dev \
		python3-dev \
		python"$hostbuild_python_version"-dev

	local HOSTBUILD_PREFIX="$TERMUX_PKG_HOSTBUILD_DIR/ubuntu_packages/usr"
	export PKG_CONFIG_PATH="$HOSTBUILD_PREFIX/lib/x86_64-linux-gnu/pkgconfig"
	export CFLAGS="-I$HOSTBUILD_PREFIX/include"
	CFLAGS+=" -I$HOSTBUILD_PREFIX/include/python$hostbuild_python_version"

	local hostbuild_venv_dir="${TERMUX_PKG_HOSTBUILD_DIR}/venv-dir"
	mkdir -p "$hostbuild_venv_dir"
	python -m venv --system-site-packages "$hostbuild_venv_dir"
	. "$hostbuild_venv_dir/bin/activate"
	pip install pycairo
}

termux_step_pre_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "false" ]]; then
		local SAVED_PATH="$PATH"
		local hostbuild_venv_dir="${TERMUX_PKG_HOSTBUILD_DIR}/venv-dir"
		. "$hostbuild_venv_dir/bin/activate"
		export PATH="$PATH:$SAVED_PATH"
	fi
}
