termux_setup_gir() {
	if [ "$TERMUX_PKG_DISABLE_GIR" = "true" ]; then
		local args=" ${TERMUX_PKG_EXTRA_CONFIGURE_ARGS//$'\n'/ } "
		args="${args//$'\t'/ }"
		args="${args// --enable-introspection / --disable-introspection }"
		args="${args// --enable-introspection=yes / --enable-introspection=no }"
		args="${args// --enable-vala / --disable-vala }"
		args="${args// --enable-vala=yes / --enable-vala=no }"
		args="${args// -DENABLE_GOBJECT_INTROSPECTION=ON / -DENABLE_GOBJECT_INTROSPECTION=OFF }"
		args="${args// -DENABLE_INTROSPECTION=ON / -DENABLE_INTROSPECTION=OFF }"
		args="${args// -Dbuild_introspection_data=true / -Dbuild_introspection_data=false }"
		args="${args// -Ddisable-introspection=false / -Ddisable-introspection=true }"
		args="${args// -Denable-gir=true / -Denable-gir=false }"
		args="${args// -Dgir=true / -Dgir=false }"
		args="${args// -Dgobject=enabled / -Dgobject=disabled }"
		args="${args// -Dintrospection=enabled / -Dintrospection=disabled }"
		args="${args// -Dintrospection=true / -Dintrospection=false }"
		args="${args// -Dintrospection=yes / -Dintrospection=no }"
		args="${args// -Dvapi=enabled / -Dvapi=disabled }"
		args="${args// -Dvapi=true / -Dvapi=false }"
		args="${args// -Dwith_introspection=true / -Dwith_introspection=false }"
		args="${args// -Dwith_vapi=true / -Dwith_vapi=false }"
		TERMUX_PKG_EXTRA_CONFIGURE_ARGS="$args"
	fi

	# Used by gi-cross-launcher:
	export TERMUX_PKG_GIR_PRE_GENERATED_DUMP_DIR="$TERMUX_PKG_BUILDER_DIR/gir/${TERMUX_PKG_VERSION##*:}"

	local _GIR_CROSS_FOLDER="$TERMUX_COMMON_CACHEDIR/gir-cross"
	local bin="$_GIR_CROSS_FOLDER/bin"
	export GI_CROSS_LAUNCHER="$bin/gi-cross-launcher"

	if [ ! -d "$_GIR_CROSS_FOLDER" ]; then
		if [ "$TERMUX_ON_DEVICE_BUILD" = "true" ]; then
			unset TERMUX_G_IR_COMPILER

			sed -e "s|@TERMUX_PREFIX@|${TERMUX_PREFIX}|g" \
				"$TERMUX_SCRIPTDIR/packages/gobject-introspection/gi-cross-launcher-on-device.in" \
				> "$GI_CROSS_LAUNCHER"
			chmod 0700 "$GI_CROSS_LAUNCHER"
		else
			local scanner="$bin/g-ir-scanner"
			local compiler="$bin/g-ir-compiler"
			local ldd="$bin/ldd"
			export TERMUX_G_IR_COMPILER="$compiler"

			install -Dm700 -T \
				"$TERMUX_SCRIPTDIR/packages/gobject-introspection/gi-cross-launcher.sh" \
				"$GI_CROSS_LAUNCHER"

			cat > "$scanner" <<-EOF
				#!$(command -v sh)
				export XDG_DATA_DIRS="$TERMUX_PREFIX/share"
				exec /usr/bin/g-ir-scanner "\$@"
			EOF
			chmod 0700 "$scanner"

			cat > "$compiler" <<-EOF
				#!$(command -v sh)
				exec /usr/bin/g-ir-compiler "\$@" \
					--includedir "$TERMUX_PREFIX/share/gir-1.0"
			EOF
			chmod 0700 "$compiler"

			local cmd
			for cmd in valac vapigen; do
				local v="$bin/$cmd"
				cat > "$v" <<-EOF
					#!$(command -v sh)
					exec /usr/bin/$cmd \
					--vapidir="$TERMUX_PREFIX/share/vala/vapi" \
					--girdir="$TERMUX_PREFIX/share/gir-1.0" \
					"\$@"
				EOF
				chmod 0700 "$v"
			done

			cat > "$ldd" <<-EOF
				#!/bin/bash-static
				unset LD_LIBRARY_PATH
			EOF
			sed 1d "$TERMUX_SCRIPTDIR/packages/ldd/ldd.in" >> "$ldd"
			sed -i 's|@READELF@|'"$(command -v readelf)"'|g' "$ldd"
			chmod 0700 "$ldd"
		fi
	fi
	if [ "$TERMUX_ON_DEVICE_BUILD" = "false" ]; then
		local env
		for env in CC CXX; do
			local cmd="$(eval echo \${$env})"
			local w="$bin/$(basename "$cmd")"
			if [ ! -e "$w" ]; then
				cat > "$w" <<-EOF
					#!/bin/bash-static
					unset LD_LIBRARY_PATH
					exec "$(command -v "$cmd")" "\$@"
				EOF
				chmod 0700 "$w"
			fi
		done
	fi
	export PATH="$bin:$PATH"
}
