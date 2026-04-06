
0.2.3 / 2012-01-30 
==================

  * added internal api Oath#node as helper for quick reject/resolve with node style callbacks
  * changed test reporter

0.2.2 / 2012-01-29 
==================

  * added progress as third argument for #then

0.2.1 / 2012-01-23 
==================

  * tests for node callback helper
  * add node callback helper
  * vim ignore(s)

0.2.0 / 2011-12-23
==================

  * read me updates for 0.2.x
  * Merge branch 'feature/v02x-refactor'
  * browser build for testing
  * tests conform to refactor
  * move #then to this.promise.then in constructor, added onprogress fn register
  * comments for _traverse
  * remove #call
  * comments for progress trigger
  * browser build for testing
  * [tests] for async functionality
  * [refactor] _traverse now recognized changes to results, removed get/set
  * removed pop from tests
  * Merge branch 'master' of github.com:logicalparadox/oath into feature/v02x-refactor
  * travis ci only ci's master branch
  * removed `pop`
  * [refactor] `get` now doesn't use return new oath
  * added _progress (untested)
  * [refactor] _pending now object, not array; added _register, refactored `then` / `_traverse` to work with _pending object
  * [refactor] renamed _complete to _fulfill
  * Merge branch 'master' of github.com:logicalparadox/oath
  * update dist
  * test for post fulfillment then-ing
  * oath remembers its fulfillment state, and will execute relative call/err-backs if then'ed after initial fullfillment
  * [refactor] reject/resolve into prototype, out of constructor
  * [docs] removed stubborn hidden .md file

0.1.0 / 2011-12-09
==================

  * added docs
  * few comment tweaks
  * readme cleanup , package.json marketing
  * added travis support
  * lib comments edited for upcoming docs
  * browser test page
  * script for browser compile
  * 0.0.5 make for testing
  * new git ignores
  * package marketing
  * lib linespacing cleanup
  * added prefix / suffix for browser
  * rewrote tests in mocha
  * switched to mocha & chai for tests
  * added makefile
  * last typo readme
  * reduntant typo
  * Readme updates
  * tests rewritten in sherlock
  * doc updates

0.0.5 / 2011-10-05
==================

  * then checks for existence of functions

0.0.4 / 2011-10-05
==================

  * oaths now except and apply custom context during 'then' callbacks

0.0.3 / 2011-10-04
==================

  * bugfix: skip pending that don't have required response callback

0.0.2 / 2011-10-04
==================

  * comments and tests for docs
  * basic tests cleanup

0.0.1 / 2011-10-03
==================

  * added package.json
  * initial commit
