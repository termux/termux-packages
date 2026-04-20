TERMUX_PKG_HOMEPAGE=https://apps.ankiweb.net/
TERMUX_PKG_DESCRIPTION="Anki is a spaced repetition system (SRS), a program which allows you to create, manage and review flashcards."
TERMUX_PKG_LICENSE="GPL-3.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION=2.1.57rc2
_COMMIT=6b7d372ca995b728f467d63ab14495f0ce346258
TERMUX_PKG_SRCURL=git+https://github.com/ankitects/anki
TERMUX_PKG_GIT_BRANCH=main
TERMUX_PKG_DEPENDS="pyqt5, python-pyqtwebengine"
TERMUX_PKG_BUILD_DEPENDS="binutils, curl, git, grep, findutils, ninja, nodejs-lts, protobuf, python, pyqt5, python-pyqtwebengine, rust, rsync"
TERMUX_PKG_PYTHON_TARGET_DEPS="pip-tools"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_post_get_source() {
	git fetch
	git checkout $_COMMIT
	git submodule update --recursive
}

termux_step_make() {
	termux_setup_rust
	export RUSTFLAGS+=" -C lto=no"
	#export CARGO_BUILD_TARGET=${CARGO_TARGET_NAME}

	termux_setup_ninja
	termux_setup_protobuf
	termux_setup_nodejs

	export NODE_BINARY=$(command -v node)
	export PROTOC_BINARY=$(command -v protoc)
	export PYTHON_BINARY=python
	export PYTHONPATH=$TERMUX_PYTHON_HOME/site-packages
	./tools/build
}

termux_step_make_install() {
	pip install out/wheels/*.whl
}
