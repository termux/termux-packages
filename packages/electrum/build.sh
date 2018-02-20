TERMUX_PKG_HOMEPAGE=https://electrum.org
TERMUX_PKG_DESCRIPTION="Electrum is a lightweight Bitcoin wallet."
TERMUX_PKG_VERSION=3.0.6
TERMUX_PKG_DEPENDS=python
TERMUX_PKG_SRCURL=https://download.electrum.org/$TERMUX_PKG_VERSION/Electrum-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=2f4ff9b94793b7a4c54fe578430811dbb12df552c8e0d86ade4a50f955c4b605
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
# asciinema previously contained some files that python packages have in common
TERMUX_PKG_CONFLICTS="asciinema (<< 1.4.0-1)"
TERMUX_PKG_RM_AFTER_INSTALL="bin/easy_install
bin/qr
lib/python3.6/site-packages/easy-install.pth
lib/python3.6/site-packages/site.py
lib/python3.6/site-packages/setuptools.pth
lib/python3.6/site-packages/PySocks-*-py3.6.egg
lib/python3.6/site-packages/dnspython-*-py3.6.egg
lib/python3.6/site-packages/ecdsa-*-py3.6.egg
lib/python3.6/site-packages/jsonrpclib_pelix-*-py3.6.egg
lib/python3.6/site-packages/pbkdf2-*-py3.6.egg
lib/python3.6/site-packages/protobuf-*-py3.6.egg
lib/python3.6/site-packages/pyaes-*-py3.6.egg
lib/python3.6/site-packages/qrcode-*-py3.6.egg
lib/python3.6/site-packages/Electrum-3.0.2-py3.6.egg/electrum_gui/qt"

termux_step_make () {
	return
}

termux_step_make_install () {
	export PYTHONPATH=$TERMUX_PREFIX/lib/python3.6/site-packages/
	python3.6 setup.py install --prefix=$TERMUX_PREFIX
}

termux_step_post_massage () {
	find . -path '*/__pycache__*' -delete
	# Other python packages also provides this file. Should be removed from all python packages
	for file in ./lib/python3.6/site-packages/easy-install.pth ./lib/python3.6/site-packages/site.py; do
		if [ -f $file ]; then
			rm $file
		fi
	done
}

termux_step_create_debscripts () {
	echo "#!$TERMUX_PREFIX/bin/sh" > postinst
	echo "pip3 install requests qrcode pyaes protobuf pbkdf2 jsonrpclib-pelix ecdsa dnspython PySocks" >> postinst
}
