;; extends

(call_expression
  function: (selector_expression
    field: (field_identifier) @_method)
  (#match? @_method "^(Sprintf|Printf|Fprintf|Errorf|Fatalf|Panicf|Print|Println)$")
  arguments: (argument_list
    . [
      (interpreted_string_literal)
      (raw_string_literal)
    ] @injection.content
    (#set! injection.language "printf")))
