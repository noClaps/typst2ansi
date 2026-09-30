((raw_blck
  lang: (ident) @injection.language
  (blob) @injection.content)
 (#set! injection.combined))

((comment) @injection.content
  (#set! injection.language "comment"))
