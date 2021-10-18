libmakepkg_module = 'tidy'

sources = [
  'docs.sh.in',
  'emptydirs.sh.in',
  'libtool.sh.in',
  'purge.sh.in',
  'staticlibs.sh.in',
  'strip.sh.in',
  'zipman.sh.in',
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
