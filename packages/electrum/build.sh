TERMUX_PKG_HOMEPAGE=https://electrum.org
TERMUX_PKG_DESCRIPTION="Electrum is a lightweight Bitcoin wallet."
TERMUX_PKG_VERSION=3.0.2
TERMUX_PKG_DEPENDS=python
TERMUX_PKG_SRCURL=https://download.electrum.org/$TERMUX_PKG_VERSION/Electrum-$TERMUX_PKG_VERSION.tar.gz
TERMUX_PKG_SHA256=4dff75bc5f496f03ad7acbe33f7cec301955ef592b0276f2c518e94e47284f53
TERMUX_PKG_BUILD_IN_SRC=yes
TERMUX_PKG_PLATFORM_INDEPENDENT=yes
# asciinema previously contained some files that python packages have in common
TERMUX_PKG_CONFLICTS="asciinema (<< 1.4.0-1)"

# NOTE: zn_CN translation doesn't work with dpkg for some reason, including that translation gives:
#	Unpacking electrum (3.0.2) ...
#	dpkg: error processing archive /data/data/com.termux/files/home/debs/electrum_3.0.2_all.deb (--unpack):
#	 corrupted filesystem tarfile - corrupted package archive
#	dpkg-deb (subprocess): decompressing archive member: lzma write error: Broken pipe
#	dpkg-deb: error: subprocess <decompress> returned error exit status 2
#	Errors were encountered while processing:
#	/data/data/com.termux/files/home/debs/electrum_3.0.2_all.deb
#	E: Sub-process /data/data/com.termux/files/usr/bin/dpkg returned an error code (1)
# Making a test package with only zh_CN/electrum.mo works fine..
TERMUX_PKG_RM_AFTER_INSTALL="bin/easy_install
bin/qr
lib/python3.6/site-packages/easy-install.pth
lib/python3.6/site-packages/site.py
lib/python3.6/site-packages/setuptools.pth
lib/python3.6/site-packages/Electrum-3.0.2-py3.6.egg/electrum_gui/qt
lib/python3.6/site-packages/Electrum-3.0.2-py3.6.egg/electrum/locale/zh_CN"

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
