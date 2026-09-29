#!@TERMUX_PREFIX@/bin/bash
set -e

# Lock terminal to prevent sending text input and special key
# combinations that may break installation process.
stty -echo -icanon time 0 min 0 intr undef quit undef susp undef

# Use trap to unlock terminal at exit.
trap 'while read -r; do true; done; stty sane;' EXIT

# Prevent running apt as root.
if [ "$(id -u)" = "0" ]; then
	echo "Installing packages as root ?"
	echo "Perhaps isn't a good idea... aborting installation :)"
	exit 1
fi

# coincurve expects ldconfig to be available.
mkdir -p "${TMPDIR:-@TERMUX_PREFIX@/tmp}"/.ldconfig
echo -e "#!@TERMUX_PREFIX@/bin/bash\nexec true" > "${TMPDIR:-@TERMUX_PREFIX@/tmp}"/.ldconfig/ldconfig
chmod 700 "${TMPDIR:-@TERMUX_PREFIX@/tmp}"/.ldconfig/ldconfig
export PATH="$PATH:${TMPDIR:-@TERMUX_PREFIX@/tmp}/.ldconfig"

for module in gevent msgpack base58 merkletools rsa PySocks pyasn1 \
	websocket_client gevent-websocket bencode.py coincurve python-bitcoinlib \
	maxminddb; do

	echo "Installing Python module: $module..."
	if ! pip install "$module"; then
		# Retrying one more time. Useful e.g. when downloading failed.
		echo "Retrying installation of $module..."
		if ! pip install "$module"; then
			# Exit if second attempt failed.
			echo "Failed to install $module."
			exit 1
		fi
	fi
done

# Cleanup.
rm -rf "${TMPDIR:-@TERMUX_PREFIX@/tmp}"/.ldconfig

exit 0
