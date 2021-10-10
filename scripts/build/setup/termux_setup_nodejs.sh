termux_setup_nodejs() {
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
		sudo apt-get install -y nodejs
	else
		if [ "$(dpkg-query -W -f '${db:Status-Status}\n' nodejs-lts 2>/dev/null)" != "installed" ]; then
			echo "Package 'nodejs' is not installed."
			echo "You can install it with"
			echo
			echo "  pkg install nodejs-lts"
			echo
			echo "or build it from source with"
			echo
			echo "  ./build-package.sh nodejs-lts"
			echo
			exit 1
		fi
	fi
}
