termux_step_elf_cleaner() {
	termux_step_elf_cleaner__from_paths . \( -path "./bin/*" -o -path "./lib/*" -o -path "./lib32/*" -o -path "./libexec/*" -o -path "./opt/*" \)
}

termux_step_elf_cleaner__from_paths() {
	# Remove entries unsupported by Android's linker:
	find "$@" -type f -print0 | xargs -r -0 \
		"$TERMUX_ELF_CLEANER" --api-level "$TERMUX_PKG_API_LEVEL"
}
