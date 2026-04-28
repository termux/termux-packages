TERMUX_PKG_HOMEPAGE=https://aws.amazon.com/cli
TERMUX_PKG_DESCRIPTION="Universal Command Line Interface for Amazon Web Services"
TERMUX_PKG_LICENSE="Apache-2.0"
TERMUX_PKG_MAINTAINER="@termux"
TERMUX_PKG_VERSION="2.34.38"
TERMUX_PKG_SRCURL="https://github.com/aws/aws-cli/archive/refs/tags/$TERMUX_PKG_VERSION.tar.gz"
TERMUX_PKG_SHA256=204c911d0390e9119f7f9058ffab68b7c92f6bbff73c9e113a371b0cf8e3dac2
TERMUX_PKG_AUTO_UPDATE=true
TERMUX_PKG_UPDATE_VERSION_REGEXP="\d+.\d+.\d+"
TERMUX_PKG_DEPENDS="libandroid-posix-semaphore, libandroid-support, mandoc"
TERMUX_PKG_SUGGESTS="groff"
TERMUX_PKG_BUILD_DEPENDS="aosp-libs, python-pip, cmake, ldd"
TERMUX_PKG_EXTRA_CONFIGURE_ARGS="
--with-install-type=portable-exe
--with-download-deps
PYTHON=$TERMUX_PREFIX/bin/python
"

# shellcheck disable=SC2115
termux_step_pre_configure() {
	export LDFLAGS+=" -lm"
	export PIP_NO_BINARY="awscrt,pyinstaller"
	export AWS_CRT_BUILD_FORCE_STATIC_LIBS=1

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		return
	fi

	export PIP_VERBOSE=1
	export PIP_NO_CACHE_DIR=1

	case "$TERMUX_ARCH" in
		aarch64) PYI_PLATFORM=Linux-64bit-arm ;;
		arm)     PYI_PLATFORM=Linux-32bit-arm ;;
		x86_64)  PYI_PLATFORM=Linux-64bit-intel ;;
		i686)    PYI_PLATFORM=Linux-32bit-intel ;;
		*)
			echo "ERROR: Unknown architecture: $TERMUX_ARCH"
			return 1 ;;
	esac
	export PYI_PLATFORM

	local PYTHON_INCLUDE="$TERMUX_PREFIX/include/python$TERMUX_PYTHON_VERSION"

	[[ -n "$TERMUX_PKG_TMPDIR" ]] || termux_error_exit "TERMUX_PKG_TMPDIR is unset"
	rm -rf "${TERMUX_PKG_TMPDIR}/bin"
	mkdir -p "$TERMUX_PKG_TMPDIR/bin"

	local -A tools=(
		[as]=AS
		[cc]=CC
		[cpp]=CPP
		[c++]=CXX
		[ld]=LD
		[ar]=AR
		[objcopy]=OBJCOPY
		[objdump]=OBJDUMP
		[ranlib]=RANLIB
		[readelf]=READELF
		[strip]=STRIP
		[nm]=NM
		[cxxfilt]=CXXFILT
	)

	local target cmd path
	for target in "${!tools[@]}"; do
		# indirection syntax e.g. target=nm, cmd=$NM
		cmd="${!tools[$target]}"
		path="$(command -v "$cmd")" || continue
		ln -sf "$path" "$TERMUX_PKG_TMPDIR/bin/$target"
	done

	TERMUX_PROOT_EXTRA_ENV_VARS=" \
	LD_PRELOAD= LD_LIBRARY_PATH= \
	PIP_NO_BINARY=$PIP_NO_BINARY \
	AWS_CRT_BUILD_FORCE_STATIC_LIBS=$AWS_CRT_BUILD_FORCE_STATIC_LIBS \
	PIP_NO_INDEX=1 \
	PIP_VERBOSE=$PIP_VERBOSE \
	PIP_NO_CACHE_DIR=$PIP_NO_CACHE_DIR \
	AS=$AS \
	CC=$CC \
	CPP=$CPP \
	CXX=$CXX \
	LD=$LD \
	AR=$AR \
	OBJCOPY=$OBJCOPY \
	OBJDUMP=$OBJDUMP \
	RANLIB=$RANLIB \
	READELF=$READELF \
	STRIP=$STRIP \
	NM=$NM \
	CXXFILT=$CXXFILT \
	CFLAGS='$CFLAGS -I$PYTHON_INCLUDE' \
	CPPFLAGS='$CPPFLAGS -I$PYTHON_INCLUDE' \
	CXXFLAGS='$CXXFLAGS' \
	LDFLAGS='$LDFLAGS' \
	PYTHON='$TERMUX_PREFIX/bin/python' \
	PYI_PLATFORM=$PYI_PLATFORM \
	"
}

termux_step_configure() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		termux_step_configure_autotools
		return
	fi

	termux_setup_proot

	termux-proot-run env PATH="$TERMUX_PKG_TMPDIR/bin:$TERMUX_PREFIX/bin:$PATH" \
		"$TERMUX_PKG_SRCDIR/configure" --prefix="$TERMUX_PREFIX" $TERMUX_PKG_EXTRA_CONFIGURE_ARGS
}

termux_step_make() {
	pushd "$TERMUX_PKG_SRCDIR"

	pushd "$TERMUX_PKG_TMPDIR"
	python3 -m venv venv
	source venv/bin/activate
	python3 -m pip install pip-tools
	popd
	# required by pyinstaller==6.20.0 https://github.com/pyinstaller/pyinstaller/pull/9399
	# https://github.com/aws/aws-cli/blob/v2/requirements/download-deps/bootstrap.txt#L1
	sed -i 's/^setuptools==.*/setuptools==82.0.1/' requirements/download-deps/bootstrap.txt
	pip-compile \
		--allow-unsafe \
		--generate-hashes \
		--output-file=requirements/download-deps/bootstrap-lock.txt \
		--unsafe-package=flit-core \
		--unsafe-package=pip \
		--unsafe-package=setuptools \
		--unsafe-package=wheel \
		requirements/download-deps/bootstrap.txt
	# Workaround for https://github.com/aws/aws-cli/issues/10145
	echo hatchling >>requirements/portable-exe-extras.txt
	# required for pep 738 https://github.com/pyinstaller/pyinstaller/pull/9398
	# https://github.com/aws/aws-cli/blob/v2/requirements/portable-exe-extras.txt#L1
	sed -i 's/^pyinstaller==.*/pyinstaller==6.20.0/' requirements/portable-exe-extras.txt
	pip-compile \
		--allow-unsafe \
		--generate-hashes \
		--output-file=requirements/download-deps/portable-exe-lock.txt \
		--unsafe-package=flit-core \
		--unsafe-package=pip \
		--unsafe-package=setuptools \
		--unsafe-package=wheel \
		pyproject.toml \
		requirements/portable-exe-extras.txt
	deactivate

	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		popd
		make
		return
	fi

	local WHEELHOUSE="$TERMUX_PKG_BUILDDIR/wheelhouse"
	mkdir -p "$WHEELHOUSE"

	local wheel_arch
	case "$TERMUX_ARCH" in
		aarch64) wheel_arch=arm64_v8a ;;
		arm)     wheel_arch=armeabi_v7a ;;
		x86_64)  wheel_arch=x86_64 ;;
		i686)    wheel_arch=x86 ;;
		*)
			echo "ERROR: Unknown architecture: $TERMUX_ARCH"
			return 1 ;;
	esac

	python3 -m pip download \
		--dest "$WHEELHOUSE" \
		--platform "android_${TERMUX_PKG_API_LEVEL}_${wheel_arch}" \
		--python-version "$TERMUX_PYTHON_VERSION" \
		--implementation cp \
		--abi cp"${TERMUX_PYTHON_VERSION//.}" \
		--abi abi3 \
		--abi none \
		--no-deps \
		-r requirements/download-deps/bootstrap-lock.txt \
		-r requirements/download-deps/portable-exe-lock.txt

	popd

	termux-proot-run \
		-b "$TERMUX_STANDALONE_TOOLCHAIN/sysroot/usr/include/android:$TERMUX__PREFIX__INCLUDE_DIR/android" \
		env PIP_FIND_LINKS="file://$WHEELHOUSE" PATH="$TERMUX_PKG_TMPDIR/bin:$TERMUX_PREFIX/bin:$PATH" \
		make
}

termux_step_make_install() {
	if [[ "$TERMUX_ON_DEVICE_BUILD" == "true" ]]; then
		make install
		return
	fi

	termux-proot-run env PATH="$TERMUX_PKG_TMPDIR/bin:$TERMUX_PREFIX/bin:$PATH" \
		make install
}
