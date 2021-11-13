#!@TERMUX_PREFIX@/bin/bash
exec @TERMUX_PREFIX@/opt/zeronet/zeronet.py \
	--config_file @TERMUX_PREFIX@/etc/zeronet.conf \
	--data_dir @TERMUX_PREFIX@/var/lib/zeronet \
	--log_dir @TERMUX_PREFIX@/var/log/zeronet "$@"
