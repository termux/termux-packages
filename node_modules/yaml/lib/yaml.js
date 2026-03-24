// YAML - Core - Copyright TJ Holowaychuk <tj@vision-media.ca> (MIT Licensed)

/**
 * Version triplet.
 */

exports.version = '0.2.3'

// --- Helpers

/**
 * Return 'near "context"' where context
 * is replaced by a chunk of _str_.
 *
 * @param  {string} str
 * @return {string}
 * @api public
 */

function context(str) {
  if (typeof str !== 'string') return ''
  str = str
    .slice(0, 25)
    .replace(/\n/g, '\\n')
    .replace(/"/g, '\\\"')
  return 'near "' + str + '"'
}

// --- Lexer

/**
 * YAML grammar tokens.
 */

var tokens = [
  ['comment', /^#[^\n]*/],
  ['indent', /^\n( *)/],
  ['space', /^ +/],
  ['true', /^\b(enabled|true|yes|on)\b/],
  ['false', /^\b(disabled|false|no|off)\b/],
  ['null', /^\b(null|Null|NULL|~)\b/],
  ['string', /^"(.*?)"/],
  ['string', /^'(.*?)'/],
  ['timestamp', /^((\d{4})-(\d\d?)-(\d\d?)(?:(?:[ \t]+)(\d\d?):(\d\d)(?::(\d\d))?)?)/],
  ['float', /^(\d+\.\d+)/],
  ['int', /^(\d+)/],
  ['doc', /^---/],
  [',', /^,/],
  ['{', /^\{(?![^\n\}]*\}[^\n]*[^\s\n\}])/],
  ['}', /^\}/],
  ['[', /^\[(?![^\n\]]*\][^\n]*[^\s\n\]])/],
  [']', /^\]/],
  ['-', /^\-/],
  [':', /^[:]/],
  ['string', /^(?![^:\n\s]*:[^\/]{2})(([^:,\]\}\n\s]|(?!\n)\s(?!\s*?\n)|:\/\/|,(?=[^\n]*\s*[^\]\}\s\n]\s*\n)|[\]\}](?=[^\n]*\s*[^\]\}\s\n]\s*\n))*)(?=[,:\]\}\s\n]|$)/], 
  ['id', /^([\w][\w -]*)/]
]

/**
 * Tokenize the given _str_.
 *
 * @param  {string} str
 * @return {array}
 * @api private
 */

exports.tokenize = function (str) {
  var token, captures, ignore, input,
      indents = 0, lastIndents = 0,
      stack = [], indentAmount = -1
  while (str.length) {
    for (var i = 0, len = tokens.length; i < len; ++i)
      if (captures = tokens[i][1].exec(str)) {
        token = [tokens[i][0], captures],
        str = str.replace(tokens[i][1], '')
        switch (token[0]) {
          case 'comment':
            ignore = true
            break
          case 'indent':
            lastIndents = indents 
            // determine the indentation amount from the first indent
            if (indentAmount == -1) {
              indentAmount = token[1][1].length
            }

            indents = token[1][1].length / indentAmount
            if (indents === lastIndents)
              ignore = true
            else if (indents > lastIndents + 1)
              throw new SyntaxError('invalid indentation, got ' + indents + ' instead of ' + (lastIndents + 1))
            else if (indents < lastIndents) {
              input = token[1].input
              token = ['dedent']
              token.input = input
              while (--lastIndents > indents)
                stack.push(token)
            }
        }
        break
      }
    if (!ignore)
      if (token)
        stack.push(token),
        token = null
      else 
        throw new SyntaxError(context(str))
    ignore = false
  }
  return stack
}

// --- Parser

/**
 * Initialize with _tokens_.
 */

function Parser(tokens) {
  this.tokens = tokens
}

/**
 * Look-ahead a single token.
 *
 * @return {array}
 * @api public
 */

Parser.prototype.peek = function() {
  return this.tokens[0]
}

/**
 * Advance by a single token.
 *
 * @return {array}
 * @api public
 */

Parser.prototype.advance = function() {
  return this.tokens.shift()
}

/**
 * Advance and return the token's value.
 *
 * @return {mixed}
 * @api private
 */

Parser.prototype.advanceValue = function() {
  return this.advance()[1][1]
}

/**
 * Accept _type_ and advance or do nothing.
 *
 * @param  {string} type
 * @return {bool}
 * @api private
 */

Parser.prototype.accept = function(type) {
  if (this.peekType(type))
    return this.advance()
}

/**
 * Expect _type_ or throw an error _msg_.
 *
 * @param  {string} type
 * @param  {string} msg
 * @api private
 */

Parser.prototype.expect = function(type, msg) {
  if (this.accept(type)) return
  throw new Error(msg + ', ' + context(this.peek()[1].input))
}

/**
 * Return the next token type.
 *
 * @return {string}
 * @api private
 */

Parser.prototype.peekType = function(val) {
  return this.tokens[0] &&
         this.tokens[0][0] === val
}

/**
 * space*
 */

Parser.prototype.ignoreSpace = function() {
  while (this.peekType('space'))
    this.advance()
}

/**
 * (space | indent | dedent)*
 */

Parser.prototype.ignoreWhitespace = function() {
  while (this.peekType('space') ||
         this.peekType('indent') ||
         this.peekType('dedent'))
    this.advance()
}

/**
 *   block
 * | doc
 * | list
 * | inlineList
 * | hash
 * | inlineHash
 * | string
 * | float
 * | int
 * | true
 * | false
 * | null
 */

Parser.prototype.parse = function() {
  switch (this.peek()[0]) {
    case 'doc':
      return this.parseDoc()
    case '-':
      return this.parseList()
    case '{':
      return this.parseInlineHash()
    case '[':
      return this.parseInlineList()
    case 'id':
      return this.parseHash()
    case 'string':
      return this.advanceValue()
    case 'timestamp':
      return this.parseTimestamp()
    case 'float':
      return parseFloat(this.advanceValue())
    case 'int':
      return parseInt(this.advanceValue())
    case 'true':
      this.advanceValue(); return true
    case 'false':
      this.advanceValue(); return false
    case 'null':
      this.advanceValue(); return null
  }
}

/**
 * '---'? indent expr dedent
 */

Parser.prototype.parseDoc = function() {
  this.accept('doc')
  this.expect('indent', 'expected indent after document')
  var val = this.parse()
  this.expect('dedent', 'document not properly dedented')
  return val
}

/**
 *  ( id ':' - expr -
 *  | id ':' - indent expr dedent
 *  )+
 */

Parser.prototype.parseHash = function() {
  var id, hash = {}
  while (this.peekType('id') && (id = this.advanceValue())) {
    this.expect(':', 'expected semi-colon after id')
    this.ignoreSpace()
    if (this.accept('indent'))
      hash[id] = this.parse(),
      this.expect('dedent', 'hash not properly dedented')
    else
      hash[id] = this.parse()
    this.ignoreSpace()
  }
  return hash
}

/**
 * '{' (- ','? ws id ':' - expr ws)* '}'
 */

Parser.prototype.parseInlineHash = function() {
  var hash = {}, id, i = 0
  this.accept('{')
  while (!this.accept('}')) {
    this.ignoreSpace()
    if (i) this.expect(',', 'expected comma')
    this.ignoreWhitespace()
    if (this.peekType('id') && (id = this.advanceValue())) {
      this.expect(':', 'expected semi-colon after id')
      this.ignoreSpace()
      hash[id] = this.parse()
      this.ignoreWhitespace()
    }
    ++i
  }
  return hash
}

/**
 *  ( '-' - expr -
 *  | '-' - indent expr dedent
 *  )+
 */

Parser.prototype.parseList = function() {
  var list = []
  while (this.accept('-')) {
    this.ignoreSpace()
    if (this.accept('indent'))
      list.push(this.parse()),
      this.expect('dedent', 'list item not properly dedented')
    else
      list.push(this.parse())
    this.ignoreSpace()
  }
  return list
}

/**
 * '[' (- ','? - expr -)* ']'
 */

Parser.prototype.parseInlineList = function() {
  var list = [], i = 0
  this.accept('[')
  while (!this.accept(']')) {
    this.ignoreSpace()
    if (i) this.expect(',', 'expected comma')
    this.ignoreSpace()
    list.push(this.parse())
    this.ignoreSpace()
    ++i
  }
  return list
}

/**
 * yyyy-mm-dd hh:mm:ss
 *
 * For full format: http://yaml.org/type/timestamp.html
 */

Parser.prototype.parseTimestamp = function() {
  var token = this.advance()[1]
  var date = new Date
  var year = token[2]
    , month = token[3]
    , day = token[4]
    , hour = token[5] || 0 
    , min = token[6] || 0
    , sec = token[7] || 0

  date.setUTCFullYear(year, month-1, day)
  date.setUTCHours(hour)
  date.setUTCMinutes(min)
  date.setUTCSeconds(sec)
  date.setUTCMilliseconds(0)
  return date
}

/**
 * Evaluate a _str_ of yaml.
 *
 * @param  {string} str
 * @return {mixed}
 * @api public
 */

exports.eval = function(str) {
  return (new Parser(exports.tokenize(str))).parse()
}
