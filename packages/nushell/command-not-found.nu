do --env {
	# Handles nonexistent commands.
	# If user has entered command which invokes non-available
	# utility, command-not-found will give a package suggestions.
	let cnf = '@TERMUX_PREFIX@/libexec/termux/command-not-found'
	if ($cnf | path exists) {
		$env.config.hooks.command_not_found = $env.config.hooks.command_not_found
		| default [] | append {|cmd|
			run-external $cnf $cmd | print
		}
	}
}
