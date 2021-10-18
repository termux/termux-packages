libmakepkg_module = 'lint_pkgbuild'

sources = [
  'arch.sh.in',
  'arch_specific.sh.in',
  'backup.sh.in',
  'changelog.sh.in',
  'checkdepends.sh.in',
  'conflicts.sh.in',
  'depends.sh.in',
  'epoch.sh.in',
  'fullpkgver.sh.in',
  'install.sh.in',
  'makedepends.sh.in',
  'optdepends.sh.in',
  'options.sh.in',
  'package_function.sh.in',
  'package_function_variable.sh.in',
  'pkgbase.sh.in',
  'pkglist.sh.in',
  'pkgname.sh.in',
  'pkgrel.sh.in',
  'pkgver.sh.in',
  'provides.sh.in',
  'source.sh.in',
  'util.sh.in',
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
