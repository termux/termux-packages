termuxgui = cc.find_library('termuxgui')

if not termuxgui.found()
	subdir_done()
endif

wlr_files += files(
	'backend.c',
	'output.c',
	'input.c',
	'allocator.c',
)

wlr_deps += termuxgui
features += { 'termuxgui-backend': true }
