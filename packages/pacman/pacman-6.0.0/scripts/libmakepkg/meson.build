libmakepkg_modules = [
  { 'name' : 'buildenv',      'has_subdir' : true },
  { 'name' : 'executable',    'has_subdir' : true },
  { 'name' : 'integrity',     'has_subdir' : true },
  { 'name' : 'lint_config',   'has_subdir' : true },
  { 'name' : 'lint_package',  'has_subdir' : true },
  { 'name' : 'lint_pkgbuild', 'has_subdir' : true },
  { 'name' : 'source',        'has_subdir' : true },
  { 'name' : 'srcinfo',                           },
  { 'name' : 'tidy',          'has_subdir' : true },
  { 'name' : 'util',          'has_subdir' : true },
]

foreach module : libmakepkg_modules
  custom_target(
    'libmakepkg_@0@'.format(module['name']),
    command : [ SCRIPT_EDITOR, '@INPUT@', '@OUTPUT@' ],
    input : '@0@.sh.in'.format(module['name']),
    output : '@BASENAME@',
    install : true,
    install_dir : join_paths(get_option('datadir'), 'makepkg'))

  if module.get('has_subdir', false)
    subdir(module['name'])
  endif
endforeach
