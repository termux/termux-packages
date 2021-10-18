libmakepkg_module = 'util'

sources = [
  'compress.sh.in',
  'config.sh.in',
  'dirsize.sh.in',
  'error.sh.in',
  'message.sh.in',
  'option.sh.in',
  'parseopts.sh.in',
  'pkgbuild.sh.in',
  'schema.sh.in',
  'source.sh.in',
  'util.sh.in',
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
