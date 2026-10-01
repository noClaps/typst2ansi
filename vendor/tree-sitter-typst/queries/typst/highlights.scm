; Taken from https://github.com/uben0/tree-sitter-typst/blob/f457c77edffd4b93190794355ff5acf7acfb99c6/editors/helix/queries/highlights.scm#L4
; Improved by @Gaspartcho

(ident) @variable
(code
  "#" @punctuation.interp
  (ident) @ident.interp)

; CONTROL

(branch
  [
    "if"
    "else"
  ] @keyword.control.conditional)
(code
  "#" @punctuation.keyword
  (branch))

(while
  "while" @keyword.control.repeat)
(code
  "#" @punctuation.keyword
  (while))

(for
  [
    "for"
    "in"
  ] @keyword.control.repeat)
(code
  "#" @punctuation.keyword
  (for))

(flow
  [
    "break"
    "continue"
  ] @keyword.control)
(code
  "#" @punctuation.keyword
  (flow))

(return
  "return" @keyword.control)
(code
  "#" @punctuation.keyword
  (return))

; DIRECTIVES
(import
  "import" @keyword.control.import)
(code
  "#" @punctuation.keyword
  (import))

(wildcard) @operator

(as
  "as" @keyword.operator)

(include
  "include" @keyword.control.import)
(code
  "#" @punctuation.keyword
  (include))

(show
  "show" @keyword.control)
(show
  pattern: (ident) @function)
(code
  "#" @punctuation.keyword
  (show))

(set
  "set" @keyword.control)
(code
  "#" @punctuation.keyword
  (set))

(let
  "let" @keyword.storage.type)
(code
  "#" @punctuation.keyword
  (let))

; OPERATOR
(in
  [
    "in"
    "not"
  ] @keyword.operator)

(context
  "context" @keyword.control)
(code
  "#" @punctuation.keyword
  (context))

(and
  "and" @keyword.operator)

(or
  "or" @keyword.operator)

(not
  "not" @keyword.operator)

(sign
  [
    "+"
    "-"
  ] @math.operator)

(add
  "+" @math.operator)

(sub
  "-" @math.operator)

(mul
  "*" @math.operator)

(div
  "/" @math.operator)

(cmp
  [
    "=="
    "<="
    ">="
    "!="
    "<"
    ">"
  ] @math.operator)

; VALUE
(tagged
  field: (ident) @variable.parameter)

(field
  field: (_) @property)

(call
  item: (ident) @function)
(code
  "#" @punctuation.function
  (call))

(code
  "#" @punctuation.interp
  (call
    item: (field)))
(call
  item: (field
    (ident) @variable
    field: (ident) @variable))
(call
  item: (field
    field: (ident) @function.method))
(call
  item: (field
    (field
      (ident) @variable
      field: (ident) @variable)))
(code
  (call
    item: (field
      (field
        (ident) @ident.interp
        field: (ident) @ident.interp))))

; RAW

(raw_blck
  "```" @punctuation.raw @embedded
  (blob) @text.raw)

(raw_blck
  lang: (ident) @tag @embedded)

(raw_span
  "`" @punctuation.raw
  (blob) @text.raw)

; MATH
[
  (label)
  (ref)
] @tag @label

(number) @number

(string) @string

(bool) @boolean

(none) @constant.builtin

(auto) @constant.builtin

(formula
  (ident) @constant)

(formula
  (field
    (ident) @constant))

(attach
  (ident) @constant)

(attach
  (field
    (ident) @constant))

(fraction
  (ident) @constant)

(attach
  [
    "^"
    "_"
  ] @math.operator)

(fraction
  "/" @math.operator)

(fac
  "!" @math.operator)

; MARKUP
(item
  "-" @punctuation.list_marker)

(term
  [
    "/"
    ":"
  ] @punctuation.list_marker)
(term
  term: (text) @text.term)

(heading) @title

(url) @tag @link_uri

(emph) @emphasis

(strong) @emphasis.strong
(strong
  (text) @emphasis.strong)

(symbol) @operator

(shorthand) @constant.builtin @operator

(quote) @markup.quote

(code
  "#" @punctuation.interp
  (field
    (ident) @ident.interp
    field: (ident) @ident.interp))

(math
  "$" @punctuation.math)

[
  (align)
  (linebreak)
] @punctuation.special

"end" @operator

(escape) @string.escape

[
  "("
  ")"
  "{"
  "}"
  "["
  "]"
] @punctuation.bracket

[
  ","
  ";"
  ".."
  ":"
  "sep"
] @punctuation.delimiter

"assign" @punctuation

(field
  "." @punctuation)

(comment) @comment
