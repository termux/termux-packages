
0.2.3 / 2012-05-07 
==================

  * code plugin respects defaults
  * better code highlighting detection and parsing
  * update deps
  * travis misformatted

0.2.2 / 2012-05-02 
==================

  * Merge branch 'master' of github.com:logicalparadox/codex
  * added travis file
  * Merge pull request #9 from domenic/watch
  * Merge pull request #8 from domenic/watch-port
  * Using `fs.watch` for Windows compatibility.
  * Pass through port/p and mount/m options when using watch.

0.2.1 / 2012-05-01 
==================

  * package.json test script is `make test`
  * Merge pull request #6 from domenic/package.json
  * Merge pull request #7 from domenic/windows
  * Merge pull request #5 from domenic/typo
  * Making work on Windows by using `path.resolve`.
  * Fixing typo/bug.
  * Adding bugs and test script to package.json.
  * read me updates
  * added help for watch command

0.2.0 / 2012-02-10 
==================

  * bug with code href generation
  * descriptions always are MD
  * test stuffs for code plugin
  * added code plugin
  * bugfixes for plugin loading
  * plugins is a more appropriate name
  * code highlighting by default
  * watcher only watches certain extensions

0.1.1 / 2012-01-30 
==================

  * Merge branch 'feature/configfile'
  * load config file before middleware
  * cross version exists compat
  * Merge branch 'feature/watch'
  * cli#watch
  * project#flush
  * utilities for directory watching

0.1.0 / 2012-01-30 
==================

  * help cleaning language
  * Merge branch 'feature/v01x'
  * removing old bin
  * added cli skeleton and serve commands
  * cli output cleaner
  * build cycle cli
  * cli cleaned up
  * folder restructuring
  * added testing resources and first tests
  * added a clean option
  * finish refactoring of render process
  * grouping for pages middleware good
  * code cleanup, oath 0.2.3 compat
  * updated git ignore
  * spacing cleanup
  * pages outDir reference fix
  * pages middleware
  * project event listening - register (file, group)
  * project loads middleware
  * change markdown sep to `marked`
  * skeleton md updates
  * codex cli interface help command
  * prep deps for 0.1.x

0.0.6 / 2012-01-02
==================

  * using utils
  * added utils to make up for tea phaseout
  * removed tea dep

0.0.5 / 2011-12-15
==================

  * parse site description as markdown
  * [gitignore]
  * added makefile
  * updated description

0.0.4 / 2011-12-07
==================

  * static server can mount to folder
  * more variables passed to code templates
  * changed markdown
  * added sorting by weight
  * switched markdown library
  * added support via dox
  * code cleanup
  * npm deps updates
  * code cleanup
  * remove mkdirp … uses tea
  * package author email
  * fez compatibility
  * skeleton jquery version
  * using tea
  * dependency versions
  * extra console.log

0.0.3 / 2011-10-11
==================

  * Merge branch 'feature/server'
  * serve static support good
  * locals group identification for root files
  * improved defaults util

0.0.2 / 2011-10-08
==================

  * skeleton template footer url change: codexjs.com
  * codex.json in data folder support
  * always rendered as index.html ... parent folder = *.md filename
  * changelog for 0.0.1

0.0.1 / 2011-10-07
==================

  * added command `skeleton [dirname]` - copies skeleton to specified directory
  * deleting fixture results. moving fixture data/template to `skeleton`.
  * updated default template
  * fez!
  * default template updates
  * latest render
  * now support yaml headers. `title` and `template` defined by default
  * cleaning up fixture/default template
  * fixture updates
  * asset directory copy and stylus render
  * include basic stylus fixture
  * jade render works
  * shortname for stout
  * better outpath handling
  * Parse files into types list
  * Readme update
  * Codex is drip, walks data dir for markdown files
  * npm init
  * initialized
