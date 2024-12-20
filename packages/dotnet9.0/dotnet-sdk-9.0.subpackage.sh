TERMUX_SUBPKG_DESCRIPTION=".NET 9.0 SDK"
TERMUX_SUBPKG_DEPEND_ON_PARENT=false
TERMUX_SUBPKG_DEPENDS="aspnetcore-runtime-9.0, aspnetcore-targeting-pack-9.0, dotnet-apphost-pack-9.0, dotnet-runtime-9.0, dotnet-targeting-pack-9.0, dotnet-templates-9.0, netstandard-targeting-pack-2.1"
TERMUX_SUBPKG_INCLUDE=$(cat "${TERMUX_PKG_TMPDIR}"/dotnet-sdk.txt)

# TODO patch msbuild to run single thread by default or fix it
termux_step_create_subpkg_debscripts() {
	cat <<- EOF > ./postinst
	#!${TERMUX_PREFIX}/bin/sh
	cat <<- EOL

	====================
	NET SDK known issues
	====================

	'dotnet' may 'Build FAILED' with no error message when
	building certain projects. You may want to try building
	with single thread by passing:

	-p:BuildInParallel=false -p:maxcpucount=1

	Pass '-v n' or '-v d' or '-v diag' to increase
	log verbosity.

	Initial build only offers Mono runtime.
	Check logcat for runtime errors.
	CoreCLR is still WIP.

	EOL
	EOF
}
