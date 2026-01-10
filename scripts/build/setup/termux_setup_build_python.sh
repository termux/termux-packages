# This script adds it's own python build to $PATH which overrides the Ubuntu's
# packaged version. Packages installed using apt on Ubuntu won't work. This
# python build is supposed to be used only for cross-compilation of pip
# packages.
#
# Before using this script manually anywhere it is highly recommended to read
# https://crossenv.readthedocs.io/en/latest/quickstart.html
# For cross compilation of python packages as well as python, a host build of
# python of the same version is required. For pip package cross compilation,
# ideally same version of python is recommended by crossenv.
termux_setup_build_python() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' python 2>/dev/null)" != "installed" ]] ||
		[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q python 2>/dev/null)" ]]; then
			echo "Package 'python is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install python"
			echo
			echo "  pacman -S python"
			echo
			echo "Note that package 'python' is known to be problematic for building on device."
			exit 1
		fi
	else
		local _PYTHON_VERSION
		local _PYTHON_SRCURL
		local _PYTHON_SHA256
		local _PYTHON_FOLDER
		_PYTHON_VERSION="$(. "$TERMUX_SCRIPTDIR/packages/python/build.sh"; echo "$TERMUX_PKG_VERSION")"
		_PYTHON_SRCURL="$(. "$TERMUX_SCRIPTDIR/packages/python/build.sh"; echo "$TERMUX_PKG_SRCURL")"
		_PYTHON_SHA256="$(. "$TERMUX_SCRIPTDIR/packages/python/build.sh"; echo "$TERMUX_PKG_SHA256")"
		if [[ "${TERMUX_PACKAGES_OFFLINE-false}" = "true" ]]; then
			_PYTHON_FOLDER=${TERMUX_SCRIPTDIR}/build-tools/python-${_PYTHON_VERSION}
		else
			_PYTHON_FOLDER=${TERMUX_COMMON_CACHEDIR}/python-${_PYTHON_VERSION}
		fi
		export TERMUX_BUILD_PYTHON_DIR=$_PYTHON_FOLDER

		if [[ ! -d "$_PYTHON_FOLDER" ]]; then
			local LAST_PWD="$(pwd)"
			termux_download \
				"$_PYTHON_SRCURL" "python-$_PYTHON_VERSION.tar.xz" "$_PYTHON_SHA256"
			mkdir "$_PYTHON_FOLDER"
			tar \
				--extract \
				--strip-components=1 \
				-C "$_PYTHON_FOLDER" \
				-f "python-$_PYTHON_VERSION.tar.xz"
			cd "$_PYTHON_FOLDER"

			for f in "$TERMUX_SCRIPTDIR"/packages/python/0009-fix-ctypes-util-find_library.patch; do
				echo "[${FUNCNAME[0]}]: Applying $(basename "$f")"
				cat "$f" | sed -e "s|@@TERMUX_PKG_API_LEVEL@@|${TERMUX_PKG_API_LEVEL}|g" | patch --silent -p1
			done

			# Perform a hostbuild of python. We are kind of doing a minimal build, which
			# may break some stuff that rely on an extended python release
			mkdir host-build/
			cd host-build/
			# We are using env -i as there are a lot of environment variable that need
			# to be unset, so better just start from scratch
			# Also whoever on crack wrote the build scripts for python, didn't think of
			# supporting the standard LD environment variable or even LDFLAGS properly.
			# So instead of using LDFLAGS we have to pass linker arguments to CC and CXX
			# and hope that Clang C and C++ drivers keep on ignoring link flags. It is
			# not at all possible to specify a separate linker without patches as it is
			# hardcoded to "$(CC) -shared" and "$(CXX) -shared"
			# Whoever that person is needs to stop writing build scripts and instead
			# question his impact on his mere existence on the world
			env -i \
				CC="clang-${TERMUX_HOST_LLVM_MAJOR_VERSION} -fuse-ld=lld" \
				CXX="clang++-${TERMUX_HOST_LLVM_MAJOR_VERSION} -fuse-ld=lld" \
				LDFLAGS="-Wl,-rpath=$_PYTHON_FOLDER/host-build-prefix/lib" \
				PATH="/usr/bin" \
				../configure \
					--with-ensurepip=install \
					--enable-shared \
					--prefix="$_PYTHON_FOLDER/host-build-prefix"
			env -i \
				make -j "$(nproc)" install
			cd "$LAST_PWD"
		fi
		# Add our own built python to path
		export PATH="$_PYTHON_FOLDER/host-build-prefix/bin:$PATH"
	fi
}
