;; extends

; Panicf with format string as first argument (not in nvim-treesitter built-in)
((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    .
    (interpreted_string_literal
      (interpreted_string_literal_content) @injection.content)))
  (#eq? @_method "Panicf")
  (#set! injection.language "printf"))

; Raw string literal (backtick) format strings for all common format functions
((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    .
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#any-of? @_method "Printf" "Sprintf" "Fatalf" "Errorf" "Skipf" "Logf" "Panicf")
  (#set! injection.language "printf"))

; Fprintf/Appendf with raw string literal as second argument
((call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  arguments: (argument_list
    (_)
    .
    (raw_string_literal
      (raw_string_literal_content) @injection.content)))
  (#any-of? @_method "Fprintf" "Appendf")
  (#set! injection.language "printf"))
