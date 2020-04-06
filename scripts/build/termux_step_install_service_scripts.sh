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
		mkdir -p ${TERMUX_PKG_SERVICE_SCRIPT[$i]}
		# We unlink ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run if it exists to
		# allow it to be overwritten through TERMUX_PKG_SERVICE_SCRIPT
		if [ -L "${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run" ]; then
			unlink "${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run"
		fi
		echo "#!$TERMUX_PREFIX/bin/sh" > ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run
		echo -e ${TERMUX_PKG_SERVICE_SCRIPT[$((i + 1))]} >> ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run

		# Do not add service script to CONFFILES if it already exists there
		if [[ $TERMUX_PKG_CONFFILES != *${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run* ]]; then
			TERMUX_PKG_CONFFILES+=" var/service/${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run"
		fi

		chmod +x ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/run

		# Avoid creating service/<service>/log/log/
		if [ "${TERMUX_PKG_SERVICE_SCRIPT[$i]: -4}" != "/log" ]; then
			touch ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/down
			TERMUX_PKG_CONFFILES+=" var/service/${TERMUX_PKG_SERVICE_SCRIPT[$i]}/down"
			mkdir -p ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log
			ln -sf $TERMUX_PREFIX/share/termux-services/svlogger ${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log/run

			TERMUX_PKG_CONFFILES+="
			var/service/${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log/run
			var/service/${TERMUX_PKG_SERVICE_SCRIPT[$i]}/log/down
			"
		fi
	done
}
