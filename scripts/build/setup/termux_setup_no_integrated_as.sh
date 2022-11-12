termux_setup_no_integrated_as() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' binutils-bin 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q binutils-bin 2>/dev/null)" ]]; then
			echo "Package 'binutils-bin' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install binutils-bin"
			echo
			echo "  pacman -S binutils-bin"
			echo
			exit 1
		fi
		CFLAGS+=" -fno-integrated-as"
		CXXFLAGS+=" -fno-integrated-as"
		return
	fi

	local binutils_cross_bin="$TERMUX_PREFIX/opt/binutils/cross/$TERMUX_HOST_PLATFORM/bin"
	if [ ! -x "$binutils_cross_bin/as" ]; then
		termux_error_exit "[${FUNCNAME[0]}]: Package 'binutils-cross' is not installed."
	fi

	local prefix="$TERMUX_COMMON_CACHEDIR/no-integrated-as"
	local bin="$prefix/bin"
	mkdir -p "$bin"
	local env
	for env in CC CXX; do
		local cmd="$(eval echo \${$env})"
		local w="$bin/$(basename "$cmd")"
		if [ ! -e "$w" ]; then
			cat > "$w" <<-EOF
				#!$(command -v sh)
				PATH="$binutils_cross_bin:\$PATH"
				exec "$(command -v "$cmd")" \
					--start-no-unused-arguments \
					-fno-integrated-as \
					--end-no-unused-arguments \
					"\$@"
			EOF
			chmod 0700 "$w"
		fi
	done
	export PATH="$bin:$PATH"
}
