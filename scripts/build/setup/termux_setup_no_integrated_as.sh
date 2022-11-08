termux_setup_no_integrated_as() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = true ]; then
		if [[ "$TERMUX_APP_PACKAGE_MANAGER" = "apt" && "$(dpkg-query -W -f '${db:Status-Status}\n' binutils 2>/dev/null)" != "installed" ]] ||
			[[ "$TERMUX_APP_PACKAGE_MANAGER" = "pacman" && ! "$(pacman -Q binutils 2>/dev/null)" ]]; then
			echo "Package 'binutils' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install binutils"
			echo
			echo "  pacman -S binutils"
			echo
			exit 1
		fi
		CFLAGS+=" -fno-integrated-as"
		CXXFLAGS+=" -fno-integrated-as"
		return
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
				PATH=$TERMUX_PREFIX/opt/binutils/cross/$TERMUX_HOST_PLATFORM/bin:\$PATH
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
