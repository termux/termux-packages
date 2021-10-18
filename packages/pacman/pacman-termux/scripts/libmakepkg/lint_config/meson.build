libmakepkg_module = 'lint_config'

sources = [
  'ext.sh.in',
  'paths.sh.in',
  'source_date_epoch.sh.in',
  'variable.sh.in',
]

foreach src : sources
  output_dir = join_paths(get_option('datadir'), 'makepkg', libmakepkg_module)

  custom_target(
    libmakepkg_module + '_' + src.underscorify(),
    command : [ SCRIPT_EDITOR, '@INPUT@', '@OUTPUT@' ],
    input : src,
    output : '@BASENAME@',
    install : true,
    install_dir : output_dir)
endforeach
