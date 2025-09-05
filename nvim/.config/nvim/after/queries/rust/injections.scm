;; extends

((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (raw_string_literal) @sql)
 (#match? @_name "query(_as|_scalar|)")
 (#eq? @_path "sqlx"))
 (#offset! @sql 0 3 0 -2))

((macro_invocation
  (scoped_identifier
    path: (identifier) @_path
    name: (identifier) @_name)
  (token_tree
    . (string_literal) @sql)
 (#match? @_name "query(_as|_scalar|)")
 (#eq? @_path "sqlx"))
 (#offset! @sql 0 1 0 -1))

(macro_invocation
  macro: [
    (scoped_identifier
      name: (_) @_macro_name)
    (identifier) @_macro_name
  ]
  (token_tree
    (raw_string_literal) @injection.content)
  (#match? @_macro_name "query(_as|_scalar|)")
  (#offset! @injection.content 0 3 0 -2)
  (#set! injection.language "sql")
  (#set! injection.include-children))

((string_content) @injection.content
(#set! injection.language "html")
(#set! injection.include-children)
(#lua-match? @injection.content "^%s*</?%a*[%s*]?.*>"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Ss][Ee][Ll][Ee][Cc][Tt]%s+.+[Ff][Rr][Oo][Mm]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Ww][Ii][Tt][Hh]%s+.*[Aa][Ss].*"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Uu][Pp][Ss][Ee][Rr][Tt]%s+[Ii][Nn][Tt][Oo]%s+.*"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Ee][Xx][Pp][Ll][Aa][Ii][Nn]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Aa][Ll][Tt][Ee][Rr]%s+[Tt][Aa][Bb][Ll][Ee]%s+.*"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Tt][Rr][Uu][Nn][Cc][Aa][Tt][Ee]%s+[Tt][Aa][Bb][Ll][Ee]%s+.*"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Dd][Rr][Oo][Pp]%s+[Tt][Aa][Bb][Ll][Ee]%s+.*"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Ii][Nn][Ss][Ee][Rr][Tt]%s+[Ii][Nn][Tt][Oo]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Ff][Uu][Nn][Cc][Tt][Ii][Oo][Nn]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Ii][Nn][Dd][Ee][Xx]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Dd][Rr][Oo][Pp]%s+[Ii][Nn][Dd][Ee][Xx]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Uu][Pp][Dd][Aa][Tt][Ee]%s+.+[Ss][Ee][Tt]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Dd][Ee][Ll][Ee][Tt][Ee]%s+[Ff][Rr][Oo][Mm]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Tt][Aa][Bb][Ll][Ee]"))

([
  (string_content)
  ]@injection.content
 (#set! injection.language "sql")
 (#set! injection.include-children)
 (#any-lua-match? @injection.content
  "^%s*[Cc][Rr][Ee][Aa][Tt][Ee]%s+[Uu][Ss][Ee][Rr]"))
