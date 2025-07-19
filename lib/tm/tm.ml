let haskell =
  `Assoc
    [ "fileTypes", `List [ `String "hs" ]
    ; "keyEquivalent", `String "^~H"
    ; "name", `String "Haskell"
    ; ( "patterns"
      , `List
          [ `Assoc
              [ ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.entity.haskell" )
                          ] )
                    ; ( "2"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.entity.haskell" )
                          ] )
                    ] )
              ; ( "comment"
                , `String
                    "In case this regex seems unusual for an infix operator, \
                     note that Haskell allows any ordinary function \
                     application (elem 4 [1..10]) to be rewritten as an infix \
                     expression (4 `elem` [1..10])." )
              ; ( "match"
                , `String "(`)[\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*(`)" )
              ; "name", `String "keyword.operator.function.infix.haskell"
              ]
          ; `Assoc
              [ "match", `String "\\(\\)"
              ; "name", `String "constant.language.unit.haskell"
              ]
          ; `Assoc
              [ "match", `String "\\[\\]"
              ; "name", `String "constant.language.empty-list.haskell"
              ]
          ; `Assoc
              [ "begin", `String "\\b(module)\\b"
              ; ( "beginCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "end", `String "\\b(where)\\b"
              ; ( "endCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "name", `String "meta.declaration.module.haskell"
              ; ( "patterns"
                , `List
                    [ `Assoc [ "include", `String "#module_name" ]
                    ; `Assoc [ "include", `String "#module_exports" ]
                    ; `Assoc
                        [ "match", `String "[a-z]+"; "name", `String "invalid" ]
                    ] )
              ]
          ; `Assoc
              [ "begin", `String "\\b(class)\\b"
              ; ( "beginCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "end", `String "\\b(where)\\b"
              ; ( "endCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "name", `String "meta.declaration.class.haskell"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ ( "match"
                          , `String
                              "\\b(Monad|Functor|Eq|Ord|Read|Show|Num|(Frac|Ra)tional|Enum|Bounded|Real(Frac|Float)?|Integral|Floating)\\b"
                          )
                        ; "name", `String "support.class.prelude.haskell"
                        ]
                    ; `Assoc
                        [ ( "match"
                          , `String
                              "[\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                          )
                        ; "name", `String "entity.other.inherited-class.haskell"
                        ]
                    ; `Assoc
                        [ ( "match"
                          , `String
                              "\\b[\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*" )
                        ; "name", `String "variable.other.generic-type.haskell"
                        ]
                    ] )
              ]
          ; `Assoc
              [ "begin", `String "\\b(instance)\\b"
              ; ( "beginCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "end", `String "\\b(where)\\b|$"
              ; ( "endCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "name", `String "meta.declaration.instance.haskell"
              ; ( "patterns"
                , `List [ `Assoc [ "include", `String "#type_signature" ] ] )
              ]
          ; `Assoc
              [ "begin", `String "\\b(import)\\b"
              ; ( "beginCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "end", `String "($|;|(?=--))"
              ; "name", `String "meta.import.haskell"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ "match", `String "\\b(qualified|as|hiding)\\b"
                        ; "name", `String "keyword.other.haskell"
                        ]
                    ; `Assoc [ "include", `String "#module_name" ]
                    ; `Assoc [ "include", `String "#module_exports" ]
                    ; `Assoc [ "include", `String "#strings" ]
                    ] )
              ]
          ; `Assoc
              [ "begin", `String "(deriving)\\s*\\("
              ; ( "beginCaptures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.haskell" ] ]
                )
              ; "end", `String "\\)"
              ; "name", `String "meta.deriving.haskell"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ ( "match"
                          , `String
                              "\\b[\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                          )
                        ; "name", `String "entity.other.inherited-class.haskell"
                        ]
                    ] )
              ]
          ; `Assoc
              [ ( "match"
                , `String
                    "\\b(deriving|where|data|type|case|of|let|in|newtype|default)\\b"
                )
              ; "name", `String "keyword.other.haskell"
              ]
          ; `Assoc
              [ "match", `String "\\binfix[lr]?\\b"
              ; "name", `String "keyword.operator.haskell"
              ]
          ; `Assoc
              [ "match", `String "\\b(do|if|then|else)\\b"
              ; "name", `String "keyword.control.haskell"
              ]
          ; `Assoc
              [ "comment", `String "Floats are always decimal"
              ; ( "match"
                , `String
                    "\\b([0-9]+\\.[0-9]+([eE][+-]?[0-9]+)?|[0-9]+[eE][+-]?[0-9]+)\\b"
                )
              ; "name", `String "constant.numeric.float.haskell"
              ]
          ; `Assoc
              [ "match", `String "\\b([0-9]+|0([xX][0-9a-fA-F]+|[oO][0-7]+))\\b"
              ; "name", `String "constant.numeric.haskell"
              ]
          ; `Assoc
              [ ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.preprocessor.c" )
                          ] )
                    ] )
              ; ( "comment"
                , `String
                    "In addition to Haskell's \"native\" syntax, GHC permits \
                     the C preprocessor to be run on a source file." )
              ; "match", `String "^\\s*(#)\\s*\\w+"
              ; "name", `String "meta.preprocessor.c"
              ]
          ; `Assoc [ "include", `String "#pragma" ]
          ; `Assoc [ "include", `String "#strings" ]
          ; `Assoc
              [ ( "begin"
                , `String
                    "(?x)^(\\s*)\n\
                    \                (?<fn>\n\
                    \                  (?:\n\
                    \                    \
                     [\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']* |\n\
                    \                    \\(\n\
                    \                      (?!--+\\))\n\
                    \                      (?:\n\
                    \                        \
                     (?![(),;\\[\\]`{}_\"'])[\\p{S}\\p{P}]\n\
                    \                      )+\n\
                    \                    \\)\n\
                    \                  )\n\
                    \                  (?:\\s*,\\s*\\g<fn>)?\n\
                    \                )\n\
                    \                \\s*(::)" )
              ; ( "beginCaptures"
                , `Assoc
                    [ ( "2"
                      , `Assoc
                          [ ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "match"
                                      , `String
                                          "[\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                                      )
                                    ; ( "name"
                                      , `String "entity.name.function.haskell" )
                                    ]
                                ; `Assoc [ "include", `String "#infix_op" ]
                                ] )
                          ] )
                    ; ( "3"
                      , `Assoc
                          [ "name", `String "keyword.other.double-colon.haskell"
                          ] )
                    ] )
              ; "name", `String "meta.function.type-declaration.haskell"
              ; ( "patterns"
                , `List [ `Assoc [ "include", `String "#type_signature" ] ] )
              ; "while", `String "^\\1\\s+"
              ]
          ; `Assoc
              [ ( "match"
                , `String
                    "\\b(Just|Nothing|Left|Right|True|False|LT|EQ|GT|\\(\\)|\\[\\])\\b"
                )
              ; "name", `String "support.constant.haskell"
              ]
          ; `Assoc
              [ ( "match"
                , `String "\\b[\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                )
              ; "name", `String "constant.other.haskell"
              ]
          ; `Assoc [ "include", `String "#comments" ]
          ; `Assoc
              [ ( "match"
                , `String
                    "\\b(abs|acos|acosh|all|and|any|appendFile|applyM|asTypeOf|asin|asinh|atan|atan2|atanh|break|catch|ceiling|compare|concat|concatMap|const|cos|cosh|curry|cycle|decodeFloat|div|divMod|drop|dropWhile|elem|encodeFloat|enumFrom|enumFromThen|enumFromThenTo|enumFromTo|error|even|exp|exponent|fail|filter|flip|floatDigits|floatRadix|floatRange|floor|fmap|foldl|foldl1|foldr|foldr1|fromEnum|fromInteger|fromIntegral|fromRational|fst|gcd|getChar|getContents|getLine|head|id|init|interact|ioError|isDenormalized|isIEEE|isInfinite|isNaN|isNegativeZero|iterate|last|lcm|length|lex|lines|log|logBase|lookup|map|mapM|mapM_|max|maxBound|maximum|maybe|min|minBound|minimum|mod|negate|not|notElem|null|odd|or|otherwise|pi|pred|print|product|properFraction|putChar|putStr|putStrLn|quot|quotRem|read|readFile|readIO|readList|readLn|readParen|reads|readsPrec|realToFrac|recip|rem|repeat|replicate|return|reverse|round|scaleFloat|scanl|scanl1|scanr|scanr1|seq|sequence|sequence_|show|showChar|showList|showParen|showString|shows|showsPrec|significand|signum|sin|sinh|snd|span|splitAt|sqrt|subtract|succ|sum|tail|take|takeWhile|tan|tanh|toEnum|toInteger|toRational|truncate|uncurry|undefined|unlines|until|unwords|unzip|unzip3|userError|words|writeFile|zip|zip3|zipWith|zipWith3)\\b(?!')"
                )
              ; "name", `String "support.function.prelude.haskell"
              ]
          ; `Assoc [ "include", `String "#infix_op" ]
          ; `Assoc
              [ ( "comment"
                , `String
                    "In case this regex seems overly general, note that \
                     Haskell permits the definition of new operators which can \
                     be nearly any string of punctuation characters, such as \
                     $%^&*." )
              ; "match", `String "((?![(),;\\[\\]`{}_\"'])[\\p{S}\\p{P}])+"
              ; "name", `String "keyword.operator.haskell"
              ]
          ; `Assoc
              [ "match", `String ","
              ; "name", `String "punctuation.separator.comma.haskell"
              ]
          ] )
    ; ( "repository"
      , `Assoc
          [ ( "block_comment"
            , `Assoc
                [ "applyEndPatternLast", `Int 1
                ; "begin", `String "\\{-(?!#)"
                ; ( "captures"
                  , `Assoc
                      [ ( "0"
                        , `Assoc
                            [ ( "name"
                              , `String "punctuation.definition.comment.haskell"
                              )
                            ] )
                      ] )
                ; "end", `String "-\\}"
                ; "name", `String "comment.block.haskell"
                ; ( "patterns"
                  , `List [ `Assoc [ "include", `String "#block_comment" ] ] )
                ] )
          ; ( "comments"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "begin"
                            , `String
                                "(^[ \
                                 \\t]+)?(?=--+((?![\\p{S}\\p{P}])|[(),;\\[\\]`{}_\"']))"
                            )
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.whitespace.comment.leading.haskell"
                                        )
                                      ] )
                                ] )
                          ; ( "comment"
                            , `String
                                "Operators may begin with '--' as long as they \
                                 are not entirely composed of '-' characters. \
                                 This means comments can't be immediately \
                                 followed by an allowable operator character." )
                          ; "end", `String "(?!\\G)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "--"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "punctuation.definition.comment.haskell"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "\\n"
                                    ; ( "name"
                                      , `String
                                          "comment.line.double-dash.haskell" )
                                    ]
                                ] )
                          ]
                      ; `Assoc [ "include", `String "#block_comment" ]
                      ] )
                ] )
          ; ( "infix_op"
            , `Assoc
                [ ( "comment"
                  , `String
                      "An operator cannot be composed entirely of '-' \
                       characters; instead, it should be matched as a comment."
                  )
                ; ( "match"
                  , `String
                      "(\\((?!--+\\))((?![(),;\\[\\]`{}_\"'])[\\p{S}\\p{P}])+\\)|\\(,+\\))"
                  )
                ; "name", `String "entity.name.function.infix.haskell"
                ] )
          ; ( "module_exports"
            , `Assoc
                [ "begin", `String "\\("
                ; "end", `String "\\)"
                ; "name", `String "meta.declaration.exports.haskell"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "match"
                            , `String
                                "\\b[\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                            )
                          ; "name", `String "entity.name.function.haskell"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b[\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                            )
                          ; "name", `String "storage.type.haskell"
                          ]
                      ; `Assoc
                          [ "match", `String ","
                          ; ( "name"
                            , `String "punctuation.separator.comma.haskell" )
                          ]
                      ; `Assoc [ "include", `String "#infix_op" ]
                      ; `Assoc
                          [ ( "comment"
                            , `String
                                "So named because I don't know what to call \
                                 this." )
                          ; "match", `String "\\(.*?\\)"
                          ; "name", `String "meta.other.unknown.haskell"
                          ]
                      ; `Assoc [ "include", `String "#comments" ]
                      ] )
                ] )
          ; ( "module_name"
            , `Assoc
                [ ( "match"
                  , `String
                      "(?<conid>[\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*(\\.\\g<conid>)?)"
                  )
                ; "name", `String "support.other.module.haskell"
                ] )
          ; ( "pragma"
            , `Assoc
                [ "begin", `String "\\{-#"
                ; "end", `String "#-\\}"
                ; "name", `String "meta.preprocessor.haskell"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "comment"
                            , `String
                                "Taken from \
                                 https://downloads.haskell.org/~ghc/latest/docs/html/users_guide/glasgow_exts.html#pragmas"
                            )
                          ; ( "match"
                            , `String
                                "\\b(LANGUAGE|OPTIONS_GHC|INCLUDE|WARNING|DEPRECATED|MINIMAL|UNPACK|NOUNPACK|SOURCE|OVERLAPPING|OVERLAPPABLE|OVERLAPS|INCOHERENT|INLINE|NOINLINE|INLINABLE|CONLIKE|LINE|RULES|SPECIALIZE|SPECIALISE)\\b"
                            )
                          ; "name", `String "keyword.other.preprocessor.haskell"
                          ]
                      ] )
                ] )
          ; ( "strings"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\""
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.haskell"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "\""
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.end.haskell"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.double.haskell"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "match"
                                      , `String
                                          "\\\\(NUL|SOH|STX|ETX|EOT|ENQ|ACK|BEL|BS|HT|LF|VT|FF|CR|SO|SI|DLE|DC1|DC2|DC3|DC4|NAK|SYN|ETB|CAN|EM|SUB|ESC|FS|GS|RS|US|SP|DEL|[abfnrtv\\\\\\\"'\\&])"
                                      )
                                    ; ( "name"
                                      , `String
                                          "constant.character.escape.haskell" )
                                    ]
                                ; `Assoc
                                    [ ( "match"
                                      , `String
                                          "\\\\o[0-7]+|\\\\x[0-9A-Fa-f]+|\\\\[0-9]+"
                                      )
                                    ; ( "name"
                                      , `String
                                          "constant.character.escape.octal.haskell"
                                      )
                                    ]
                                ; `Assoc
                                    [ ( "match"
                                      , `String "\\\\\\^[A-Z@\\[\\]\\\\\\^_]" )
                                    ; ( "name"
                                      , `String
                                          "constant.character.escape.control.haskell"
                                      )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "\\\\\\s"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "constant.character.escape.begin.haskell"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "\\\\"
                                    ; ( "endCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "constant.character.escape.end.haskell"
                                                  )
                                                ] )
                                          ] )
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "match", `String "\\S+"
                                              ; ( "name"
                                                , `String
                                                    "invalid.illegal.character-not-allowed-here.haskell"
                                                )
                                              ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.haskell"
                                        )
                                      ] )
                                ; ( "2"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "constant.character.escape.haskell"
                                        )
                                      ] )
                                ; ( "3"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "constant.character.escape.octal.haskell"
                                        )
                                      ] )
                                ; ( "4"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "constant.character.escape.hexadecimal.haskell"
                                        )
                                      ] )
                                ; ( "5"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "constant.character.escape.control.haskell"
                                        )
                                      ] )
                                ; ( "6"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.end.haskell"
                                        )
                                      ] )
                                ] )
                          ; ( "match"
                            , `String
                                "(?x)\n\
                                 \t\t\t\t\t(')\n\
                                 \t\t\t\t\t(?:\n\
                                 \t\t\t\t\t\t[\\ -\\[\\]-~]\t\t\t\t\t\t\t\t# \
                                 Basic Char\n\
                                 \t\t\t\t\t  | \
                                 (\\\\(?:NUL|SOH|STX|ETX|EOT|ENQ|ACK|BEL|BS|HT|LF|VT|FF|CR|SO|SI|DLE\n\
                                 \t\t\t\t\t\t\t|DC1|DC2|DC3|DC4|NAK|SYN|ETB|CAN|EM|SUB|ESC|FS|GS|RS\n\
                                 \t\t\t\t\t\t\t|US|SP|DEL|[abfnrtv\\\\\\\"'\\&]))\t\t# \
                                 Escapes\n\
                                 \t\t\t\t\t  | (\\\\o[0-7]+)\t\t\t\t\t\t\t\t# \
                                 Octal Escapes\n\
                                 \t\t\t\t\t  | \
                                 (\\\\x[0-9A-Fa-f]+)\t\t\t\t\t\t# Hexadecimal \
                                 Escapes\n\
                                 \t\t\t\t\t  | \
                                 (\\\\\\^[A-Z@\\[\\]\\\\\\^_])\t\t\t\t\t# \
                                 Control Chars\n\
                                 \t\t\t\t\t)\n\
                                 \t\t\t\t\t(')\n\
                                 \t\t\t\t\t" )
                          ; "name", `String "string.quoted.single.haskell"
                          ]
                      ] )
                ] )
          ; ( "type_signature"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "entity.other.inherited-class.haskell"
                                        )
                                      ] )
                                ; ( "2"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "variable.other.generic-type.haskell"
                                        )
                                      ] )
                                ; ( "3"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.other.big-arrow.haskell" )
                                      ] )
                                ] )
                          ; ( "match"
                            , `String
                                "\\(\\s*([\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*)\\s+([\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*)\\)\\s*(=>)"
                            )
                          ; "name", `String "meta.class-constraint.haskell"
                          ]
                      ; `Assoc [ "include", `String "#pragma" ]
                      ; `Assoc
                          [ "match", `String "->"
                          ; "name", `String "keyword.other.arrow.haskell"
                          ]
                      ; `Assoc
                          [ "match", `String "=>"
                          ; "name", `String "keyword.other.big-arrow.haskell"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b(Int(eger)?|Maybe|Either|Bool|Float|Double|Char|String|Ordering|ShowS|ReadS|FilePath|IO(Error)?)\\b"
                            )
                          ; "name", `String "support.type.prelude.haskell"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b[\\p{Ll}_][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                            )
                          ; ( "name"
                            , `String "variable.other.generic-type.haskell" )
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b[\\p{Lu}\\p{Lt}][\\p{Ll}_\\p{Lu}\\p{Lt}\\p{Nd}']*"
                            )
                          ; "name", `String "storage.type.haskell"
                          ]
                      ; `Assoc
                          [ "match", `String "\\(\\)"
                          ; "name", `String "support.constant.unit.haskell"
                          ]
                      ; `Assoc [ "include", `String "#comments" ]
                      ] )
                ] )
          ] )
    ; "scopeName", `String "source.haskell"
    ; "uuid", `String "5C034675-1F6D-497E-8073-369D37E2FD7D"
    ]
;;
