manpages = [
  { 'name': 'alpm-hooks.5' },
  { 'name': 'pacman.8' },
  { 'name': 'makepkg.8' },
  { 'name': 'makepkg-template.1' },
  { 'name': 'repo-add.8' },
  { 'name': 'vercmp.8' },
  { 'name': 'pacman-key.8' },
  { 'name': 'PKGBUILD.5', 'extra_depends' : [ 'PKGBUILD-example.txt' ] },
  { 'name': 'makepkg.conf.5' },
  { 'name': 'pacman.conf.5' },
  { 'name': 'BUILDINFO.5' },
  { 'name': 'pacman-conf.8' },
]

sitepages = [
  { 'name': 'submitting-patches' },
  { 'name': 'translation-help' },
  { 'name': 'HACKING', 'source': '../HACKING' },
  { 'name': 'index' },
]

asciidoc_conf = join_paths(meson.current_source_dir(), 'asciidoc.conf')

asciidoc_opts = [
 '-f', asciidoc_conf,
 '-a', 'pacman_version="@0@"'.format(PACKAGE_VERSION),
 '-a', 'pacman_date=@0@'.format(run_command('date', '+%Y-%m-%d').stdout().strip()),
 '-a', 'srcext=@0@'.format(get_option('src-ext')),
 '-a', 'pkgext=@0@'.format(get_option('pkg-ext')),
 '-a', 'pkgdatadir=@0@'.format(PKGDATADIR),
 '-a', 'localstatedir=@0@'.format(LOCALSTATEDIR),
 '-a', 'sysconfdir=@0@'.format(SYSCONFDIR),
 '-a', 'datarootdir=@0@'.format(DATAROOTDIR),
 '-a', 'rootdir=@0@'.format(ROOTDIR),
]

html_targets = []
html_files = []

foreach page : manpages
  manpage = page['name']
  htmlpage = '@0@.html'.format(manpage)
  input = '@0@.asciidoc'.format(manpage)

  section = page['name'].split('.')[-1]

  mandirn = join_paths(MANDIR, 'man' + section)

  custom_target(
    manpage,
    command : [
      A2X,
      '--no-xmllint',
      '-d', 'manpage',
      '-f', 'manpage',
      '--xsltproc-opts', '-param man.endnotes.list.enabled 0 -param man.endnotes.are.numbered 0',
      '-D', '@OUTDIR@',
      '--asciidoc-opts', ' '.join(asciidoc_opts),
      '@INPUT@',
    ],
    input : input,
    output : [manpage],
    depend_files : [
      asciidoc_conf,
    ] + page.get('extra_depends', []),
    install : true,
    install_dir : mandirn,
  )
endforeach

foreach page: manpages + sitepages
  manpage = page['name']
  htmlpage = '@0@.html'.format(manpage)
  input = page.get('source', '@0@.asciidoc'.format(manpage))

  html = custom_target(
    htmlpage,
    command : [
      ASCIIDOC,
    ] + asciidoc_opts + [
      '-a', 'linkcss',
      '-a', 'toc',
      '-a', 'icons',
      '-a', 'max-width=960px',
      '-a', 'stylesheet=asciidoc-override.css',
      '-o', '@OUTPUT@',
      '@INPUT@',
    ],
    input : input,
    output : [htmlpage],
    depend_files : [
      asciidoc_conf,
      'asciidoc-override.css',
    ] + page.get('extra_depends', []),
    build_by_default : false,
    install : false,
  )
  html_targets += [html]
  html_files += [htmlpage]
endforeach

run_target('html',
           command : ['/bin/true'],
           depends : html_targets)

custom_target(
  'website.tar.gz',
  command : [
    'bsdtar', 'czf', '@OUTPUT@',
    '-C', meson.current_build_dir(),
  ] + html_files + [
    '-C', meson.current_source_dir(),
    'asciidoc-override.css',
    '-C', '/etc/asciidoc/stylesheets/',
    'asciidoc.css',
    '-C', '/etc/asciidoc/javascripts/',
    'asciidoc.js',
    '-C', '/etc/asciidoc/',
    'images',
  ],
  output : ['website.tar.gz'],
  build_by_default : false,
  depends : html_targets,
)

meson.add_install_script(MESON_MAKE_SYMLINK,
                         'repo-add.8',
                         join_paths(MANDIR, 'man8/repo-remove.8'))

meson.add_install_script(MESON_MAKE_SYMLINK,
                         'alpm-hooks.5',
                         join_paths(MANDIR, 'man5/pacman-hooks.5'))

doxygen = find_program('doxygen', required : get_option('doxygen'))
if doxygen.found() and not get_option('doxygen').disabled()
  doxyconf = configuration_data()
  doxyconf.set('INPUT_DIRECTORY', meson.current_source_dir())
  doxyconf.set('OUTPUT_DIRECTORY', meson.current_build_dir())
  doxyfile = configure_file(
    input : 'Doxyfile.in',
    output : 'Doxyfile',
    configuration : doxyconf,
    install : false)

  custom_target(
    'doxygen',
    input : doxyfile,
    output : ['man3'],
    command : [doxygen, doxyfile],
    build_by_default : true,
    install : true,
    install_dir : MANDIR)
endif
