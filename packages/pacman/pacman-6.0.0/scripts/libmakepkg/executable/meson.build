libmakepkg_module = 'executable'

sources = [
  'ccache.sh.in',
  'checksum.sh.in',
  'distcc.sh.in',
  'fakeroot.sh.in',
  'gpg.sh.in',
  'gzip.sh.in',
  'pacman.sh.in',
  'strip.sh.in',
  'sudo.sh.in',
  'vcs.sh.in',
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
