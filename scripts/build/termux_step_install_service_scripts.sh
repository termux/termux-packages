termux_step_install_service_scripts() {
	array_length=${#TERMUX_PKG_SERVICE_SCRIPT[@]}
	if [ $array_length -eq 0 ]; then return; fi

	# TERMUX_PKG_SERVICE_SCRIPT should have the structure =("daemon name" 'script to execute')
	if [ $(( $array_length & 1 )) -eq 1 ]; then
		termux_error_exit "TERMUX_PKG_SERVICE_SCRIPT has to be an array of even length"
	fi

	mkdir -p $TERMUX_PREFIX/var/service
	cd $TERMUX_PREFIX/var/service
	for ((i=0; i<${array_length}; i+=2)); do
		mkdir -p ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log
		echo "#!$TERMUX_PREFIX/bin/sh" > ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run
		echo -e ${TERMUX_PKG_SERVICE_SCRIPT[$((i + 1))]} >> ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run

		TERMUX_PKG_CONFFILES+="
		var/service/${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run
		var/service/${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log/run
		"

		chmod +x ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run
		touch ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/down
		ln -sf $TERMUX_PREFIX/share/termux-services/svlogger ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log/run
	done
}
