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

let java =
  `Assoc
    [ "fileTypes", `List [ `String "java"; `String "bsh" ]
    ; "keyEquivalent", `String "^~J"
    ; "name", `String "Java"
    ; ( "patterns"
      , `List
          [ `Assoc
              [ ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc [ "name", `String "keyword.other.package.java" ]
                      )
                    ; ( "2"
                      , `Assoc
                          [ "name", `String "storage.modifier.package.java" ] )
                    ; ( "3"
                      , `Assoc [ "name", `String "punctuation.terminator.java" ]
                      )
                    ] )
              ; "match", `String "^\\s*(package)\\b(?:\\s*([^ ;$]+)\\s*(;)?)?"
              ; "name", `String "meta.package.java"
              ]
          ; `Assoc
              [ "begin", `String "(import static)\\b\\s*"
              ; ( "beginCaptures"
                , `Assoc
                    [ ( "1"
                      , `Assoc
                          [ "name", `String "keyword.other.import.static.java" ]
                      )
                    ] )
              ; ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc [ "name", `String "keyword.other.import.java" ] )
                    ; ( "2"
                      , `Assoc
                          [ "name", `String "storage.modifier.import.java" ] )
                    ; ( "3"
                      , `Assoc [ "name", `String "punctuation.terminator.java" ]
                      )
                    ] )
              ; "contentName", `String "storage.modifier.import.java"
              ; "end", `String "\\s*(?:$|(;))"
              ; ( "endCaptures"
                , `Assoc
                    [ ( "1"
                      , `Assoc [ "name", `String "punctuation.terminator.java" ]
                      )
                    ] )
              ; "name", `String "meta.import.java"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ "match", `String "\\."
                        ; "name", `String "punctuation.separator.java"
                        ]
                    ; `Assoc
                        [ "match", `String "\\s"
                        ; ( "name"
                          , `String
                              "invalid.illegal.character_not_allowed_here.java"
                          )
                        ]
                    ] )
              ]
          ; `Assoc
              [ "begin", `String "(import)\\b\\s*"
              ; ( "beginCaptures"
                , `Assoc
                    [ ( "1"
                      , `Assoc [ "name", `String "keyword.other.import.java" ] )
                    ] )
              ; ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc [ "name", `String "keyword.other.import.java" ] )
                    ; ( "2"
                      , `Assoc
                          [ "name", `String "storage.modifier.import.java" ] )
                    ; ( "3"
                      , `Assoc [ "name", `String "punctuation.terminator.java" ]
                      )
                    ] )
              ; "contentName", `String "storage.modifier.import.java"
              ; "end", `String "\\s*(?:$|(;))"
              ; ( "endCaptures"
                , `Assoc
                    [ ( "1"
                      , `Assoc [ "name", `String "punctuation.terminator.java" ]
                      )
                    ] )
              ; "name", `String "meta.import.java"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ "match", `String "\\."
                        ; "name", `String "punctuation.separator.java"
                        ]
                    ; `Assoc
                        [ "match", `String "\\s"
                        ; ( "name"
                          , `String
                              "invalid.illegal.character_not_allowed_here.java"
                          )
                        ]
                    ] )
              ]
          ; `Assoc [ "include", `String "#code" ]
          ] )
    ; ( "repository"
      , `Assoc
          [ ( "all-types"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#primitive-arrays" ]
                      ; `Assoc [ "include", `String "#primitive-types" ]
                      ; `Assoc [ "include", `String "#object-types" ]
                      ] )
                ] )
          ; ( "annotations"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "(@[^ (]+)(\\()"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "storage.type.annotation.java"
                                        )
                                      ] )
                                ; ( "2"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.annotation-arguments.begin.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(\\))"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.annotation-arguments.end.java"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "meta.declaration.annotation.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "captures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "constant.other.key.java"
                                                  )
                                                ] )
                                          ; ( "2"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "keyword.operator.assignment.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "match", `String "(\\w*)\\s*(=)"
                                    ]
                                ; `Assoc [ "include", `String "#code" ]
                                ; `Assoc
                                    [ "match", `String ","
                                    ; ( "name"
                                      , `String
                                          "punctuation.separator.property.java"
                                      )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "match", `String "@\\w*"
                          ; "name", `String "storage.type.annotation.java"
                          ]
                      ] )
                ] )
          ; ( "anonymous-classes-and-new"
            , `Assoc
                [ "begin", `String "\\bnew\\b"
                ; ( "beginCaptures"
                  , `Assoc
                      [ ( "0"
                        , `Assoc [ "name", `String "keyword.control.new.java" ]
                        )
                      ] )
                ; "end", `String "(?<=\\)|\\])(?!\\s*{)|(?<=})|(?=;)"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "(\\w+)\\s*(?=\\[)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ "name", `String "storage.type.java" ] )
                                ] )
                          ; "end", `String "(})|(?=\\s*(?:,|;|\\)))"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.block.end.java"
                                        )
                                      ] )
                                ] )
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "\\["
                                    ; "end", `String "\\]"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#code" ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "{"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "punctuation.section.block.begin.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "(?=})"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#code" ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "(?=\\w.*\\()"
                          ; "end", `String "(?<=\\))"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#object-types" ]
                                ; `Assoc
                                    [ "begin", `String "\\("
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String "storage.type.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "\\)"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#code" ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "{"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.inner-class.begin.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "}"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.inner-class.end.java"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "meta.inner-class.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#class-body" ] ]
                            )
                          ]
                      ] )
                ] )
          ; ( "assertions"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\b(assert)\\s"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "keyword.control.assert.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "$"
                          ; "name", `String "meta.declaration.assertion.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "match", `String ":"
                                    ; ( "name"
                                      , `String
                                          "keyword.operator.assert.expression-seperator.java"
                                      )
                                    ]
                                ; `Assoc [ "include", `String "#code" ]
                                ] )
                          ]
                      ] )
                ] )
          ; ( "class"
            , `Assoc
                [ ( "begin"
                  , `String
                      "(?=\\w?[\\w\\s]*(?:class|(?:@)?interface|enum)\\s+\\w+)"
                  )
                ; "end", `String "}"
                ; ( "endCaptures"
                  , `Assoc
                      [ ( "0"
                        , `Assoc
                            [ ( "name"
                              , `String "punctuation.section.class.end.java" )
                            ] )
                      ] )
                ; "name", `String "meta.class.java"
                ; ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#storage-modifiers" ]
                      ; `Assoc [ "include", `String "#comments" ]
                      ; `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ "name", `String "storage.modifier.java"
                                      ] )
                                ; ( "2"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "entity.name.type.class.java"
                                        )
                                      ] )
                                ] )
                          ; ( "match"
                            , `String "(class|(?:@)?interface|enum)\\s+(\\w+)" )
                          ; "name", `String "meta.class.identifier.java"
                          ]
                      ; `Assoc
                          [ "begin", `String "extends"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "storage.modifier.extends.java" )
                                      ] )
                                ] )
                          ; "end", `String "(?={|implements)"
                          ; ( "name"
                            , `String
                                "meta.definition.class.inherited.classes.java" )
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "include"
                                      , `String "#object-types-inherited" )
                                    ]
                                ; `Assoc [ "include", `String "#comments" ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "(implements)\\s"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "storage.modifier.implements.java" )
                                      ] )
                                ] )
                          ; "end", `String "(?=\\s*extends|\\{)"
                          ; ( "name"
                            , `String
                                "meta.definition.class.implemented.interfaces.java"
                            )
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "include"
                                      , `String "#object-types-inherited" )
                                    ]
                                ; `Assoc [ "include", `String "#comments" ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "{"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.class.begin.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=})"
                          ; "name", `String "meta.class.body.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#class-body" ] ]
                            )
                          ]
                      ] )
                ] )
          ; ( "class-body"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#comments" ]
                      ; `Assoc [ "include", `String "#class" ]
                      ; `Assoc [ "include", `String "#enums" ]
                      ; `Assoc [ "include", `String "#variables" ]
                      ; `Assoc [ "include", `String "#methods" ]
                      ; `Assoc [ "include", `String "#annotations" ]
                      ; `Assoc [ "include", `String "#storage-modifiers" ]
                      ; `Assoc [ "include", `String "#code" ]
                      ] )
                ] )
          ; ( "code"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#comments" ]
                      ; `Assoc [ "include", `String "#class" ]
                      ; `Assoc
                          [ "begin", `String "{"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.block.begin.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "}"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.block.end.java"
                                        )
                                      ] )
                                ] )
                          ; ( "patterns"
                            , `List [ `Assoc [ "include", `String "#code" ] ] )
                          ]
                      ; `Assoc [ "include", `String "#assertions" ]
                      ; `Assoc [ "include", `String "#parens" ]
                      ; `Assoc
                          [ "include", `String "#constants-and-special-vars" ]
                      ; `Assoc
                          [ "include", `String "#anonymous-classes-and-new" ]
                      ; `Assoc [ "include", `String "#annotations" ]
                      ; `Assoc [ "include", `String "#keywords" ]
                      ; `Assoc [ "include", `String "#storage-modifiers" ]
                      ; `Assoc [ "include", `String "#method-call" ]
                      ; `Assoc [ "include", `String "#strings" ]
                      ; `Assoc [ "include", `String "#all-types" ]
                      ] )
                ] )
          ; ( "comments"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.comment.java"
                                        )
                                      ] )
                                ] )
                          ; "match", `String "/\\*\\*/"
                          ; "name", `String "comment.block.empty.java"
                          ]
                      ; `Assoc [ "include", `String "text.html.javadoc" ]
                      ; `Assoc [ "include", `String "#comments-inline" ]
                      ] )
                ] )
          ; ( "comments-inline"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "/\\*"
                          ; ( "captures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.comment.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "\\*/"
                          ; "name", `String "comment.block.java"
                          ]
                      ; `Assoc
                          [ "begin", `String "(^[ \\t]+)?(?=//)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.whitespace.comment.leading.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?!\\G)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "//"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "punctuation.definition.comment.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "\\n"
                                    ; ( "name"
                                      , `String "comment.line.double-slash.java"
                                      )
                                    ]
                                ] )
                          ]
                      ] )
                ] )
          ; ( "constants-and-special-vars"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "match", `String "\\b(true|false|null)\\b"
                          ; "name", `String "constant.language.java"
                          ]
                      ; `Assoc
                          [ "match", `String "\\b(this|super)\\b"
                          ; "name", `String "variable.language.java"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b0[xX][0-9A-Fa-f]([0-9A-Fa-f_]*[0-9A-Fa-f])?[lL]?(?!\\w|\\.)"
                            )
                          ; "name", `String "constant.numeric.hex.java"
                          ]
                      ; `Assoc
                          [ "match", `String "\\b0[0-7_]*[0-7][lL]?\\b"
                          ; "name", `String "constant.numeric.octal.java"
                          ]
                      ; `Assoc
                          [ "match", `String "\\b0[bB][01]([01_]*[01])?[lL]?\\b"
                          ; "name", `String "constant.numeric.binary.java"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b(0|[1-9]([0-9_]*[0-9])?)[lL]?(?!\\w|\\.)" )
                          ; "name", `String "constant.numeric.integer.java"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "(?x)\n\
                                 \t\t\t\t\t\t(?<!\\w)\t\t\t\t\t\t\t\t\t\t# \
                                 Ensure word boundry\n\
                                 \t\t\t\t\t\t(?>\n\
                                 \t\t\t\t\t\t\t0[xX]\t\t\t\t\t\t\t\t\t# Start \
                                 literal\n\
                                 \t\t\t\t\t\t\t([0-9A-Fa-f]([0-9A-Fa-f_]*[0-9A-Fa-f])?)?\t\t\t\t\t\t# \
                                 Optional Number\n\
                                 \t\t\t\t\t\t\t(\n\
                                 \t\t\t\t\t\t\t\t(?<=[0-9A-Fa-f])\\.\t\t\t\t\t\t\t# \
                                 A number must exist on\n\
                                 \t\t\t\t\t\t      | \
                                 \\.(?=[0-9A-Fa-f])\t\t\t\t\t\t\t#   one side \
                                 of the decimal\n\
                                 \t\t\t\t\t\t      | \
                                 (?<=[0-9A-Fa-f])\t\t\t\t\t\t\t\t# Decimal not \
                                 required\n\
                                 \t\t\t\t\t\t\t)\n\
                                 \t\t\t\t\t\t\t([0-9A-Fa-f]([0-9A-Fa-f_]*[0-9A-Fa-f])?)?\t\t\t\t\t\t# \
                                 Optional Number\n\
                                 \t\t\t\t\t\t\t[pP]\t\t\t\t\t\t\t\t\t# \
                                 Exponent Indicator\n\
                                 \t\t\t\t\t\t\t[+-]?(0|[1-9]([0-9_]*[0-9])?)\t\t\t# \
                                 Signed Integer\n\
                                 \t\t\t\t\t\t\t[fFdD]?\t\t\t\t\t\t\t\t\t# \
                                 Float Type Suffix\n\
                                 \t\t\t\t\t\t)\n\
                                 \t\t\t\t\t\t(?!\\w)\t\t\t\t\t\t\t\t\t\t# \
                                 Ensure word boundry\n\
                                 \t\t\t\t\t" )
                          ; "name", `String "constant.numeric.hex-float.java"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "(?x)\n\
                                 \t\t\t\t\t\t(?<!\\w)\t\t\t\t\t\t\t\t\t\t\t# \
                                 Ensure word boundry\n\
                                 \t\t\t\t\t\t(?>\n\
                                 \t\t\t\t\t\t\t(\n\
                                 \t\t\t\t\t\t\t\t(0|[1-9]([0-9_]*[0-9])?)\t\t\t\t# \
                                 Leading digits\n\
                                 \t\t\t\t\t\t\t\t(?=[eEfFdD.])\t\t\t\t\t\t\t# \
                                 Allow for numbers without .\n\
                                 \t\t\t\t\t\t\t)?\n\
                                 \t\t\t\t\t\t\t(\n\
                                 \t\t\t\t\t\t\t\t(?<=[0-9])(?=[eEfFdD])\t\t\t\t\t# \
                                 Allow for numbers without .\n\
                                 \t\t\t\t\t\t\t  | \\.\n\
                                 \t\t\t\t\t\t\t)\n\
                                 \t\t\t\t\t\t\t(\n\
                                 \t\t\t\t\t\t\t\t[0-9]([0-9_]*[0-9])?\t\t\t\t\t# \
                                 Numbers after .\n\
                                 \t\t\t\t\t\t\t)?\n\
                                 \t\t\t\t\t\t\t(\n\
                                 \t\t\t\t\t\t\t\t[eE][+-]?(0|[1-9]([0-9_]*[0-9])?)\t\t# \
                                 Exponent\n\
                                 \t\t\t\t\t\t\t)?\n\
                                 \t\t\t\t\t\t\t[fFdD]?\t\t\t\t\t\t\t\t\t\t# \
                                 Float Type Suffix\n\
                                 \t\t\t\t\t\t)\n\
                                 \t\t\t\t\t\t(?!\\w)\t\t\t\t\t\t\t\t\t\t\t# \
                                 Ensure word boundry\n\
                                 \t\t\t\t\t" )
                          ; "name", `String "constant.numeric.float.java"
                          ]
                      ; `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.dereference.java"
                                        )
                                      ] )
                                ] )
                          ; ( "match"
                            , `String
                                "(\\.)?\\b([A-Z][A-Z0-9_]+)(?!<|\\.class|\\s*\\w+\\s*=)\\b"
                            )
                          ; "name", `String "constant.other.java"
                          ]
                      ] )
                ] )
          ; ( "enums"
            , `Assoc
                [ "begin", `String "^(?=\\s*[A-Z0-9_]+\\s*({|\\(|,))"
                ; "end", `String "(?=;|})"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\w+"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "constant.other.enum.java" )
                                      ] )
                                ] )
                          ; "end", `String "(?=,|;|})"
                          ; "name", `String "meta.enum.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#parens" ]
                                ; `Assoc
                                    [ "begin", `String "{"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "punctuation.section.enum.begin.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "}"
                                    ; ( "endCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "punctuation.section.enum.end.java"
                                                  )
                                                ] )
                                          ] )
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#class-body"
                                              ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ; `Assoc [ "include", `String "#comments" ]
                      ; `Assoc [ "include", `String "#annotations" ]
                      ] )
                ] )
          ; ( "keywords"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "match", `String "\\b(try|catch|finally|throw)\\b"
                          ; ( "name"
                            , `String "keyword.control.catch-exception.java" )
                          ]
                      ; `Assoc
                          [ "match", `String "\\?|:"
                          ; "name", `String "keyword.control.ternary.java"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b(return|break|case|continue|default|do|while|for|switch|if|else)\\b"
                            )
                          ; "name", `String "keyword.control.java"
                          ]
                      ; `Assoc
                          [ "match", `String "\\b(instanceof)\\b"
                          ; "name", `String "keyword.operator.java"
                          ]
                      ; `Assoc
                          [ "match", `String "(<<|>>>?|~|\\^)"
                          ; "name", `String "keyword.operator.bitwise.java"
                          ]
                      ; `Assoc
                          [ "match", `String "((&|\\^|\\||<<|>>>?)=)"
                          ; ( "name"
                            , `String "keyword.operator.assignment.bitwise.java"
                            )
                          ]
                      ; `Assoc
                          [ "match", `String "(===?|!=|<=|>=|<>|<|>)"
                          ; "name", `String "keyword.operator.comparison.java"
                          ]
                      ; `Assoc
                          [ "match", `String "([+*/%-]=)"
                          ; ( "name"
                            , `String
                                "keyword.operator.assignment.arithmetic.java" )
                          ]
                      ; `Assoc
                          [ "match", `String "(=)"
                          ; "name", `String "keyword.operator.assignment.java"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\-\\-|\\+\\+)"
                          ; ( "name"
                            , `String
                                "keyword.operator.increment-decrement.java" )
                          ]
                      ; `Assoc
                          [ "match", `String "(\\-|\\+|\\*|\\/|%)"
                          ; "name", `String "keyword.operator.arithmetic.java"
                          ]
                      ; `Assoc
                          [ "match", `String "(!|&&|\\|\\|)"
                          ; "name", `String "keyword.operator.logical.java"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\||&)"
                          ; "name", `String "keyword.operator.bitwise.java"
                          ]
                      ; `Assoc
                          [ "match", `String "(?<=\\S)\\.(?=\\S)"
                          ; "name", `String "keyword.operator.dereference.java"
                          ]
                      ; `Assoc
                          [ "match", `String ";"
                          ; "name", `String "punctuation.terminator.java"
                          ]
                      ] )
                ] )
          ; ( "method-call"
            , `Assoc
                [ "begin", `String "([\\w$]+)(\\()"
                ; ( "beginCaptures"
                  , `Assoc
                      [ "1", `Assoc [ "name", `String "meta.method.java" ]
                      ; ( "2"
                        , `Assoc
                            [ ( "name"
                              , `String
                                  "punctuation.definition.method-parameters.begin.java"
                              )
                            ] )
                      ] )
                ; "end", `String "\\)"
                ; ( "endCaptures"
                  , `Assoc
                      [ ( "0"
                        , `Assoc
                            [ ( "name"
                              , `String
                                  "punctuation.definition.method-parameters.end.java"
                              )
                            ] )
                      ] )
                ; "name", `String "meta.method-call.java"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ "match", `String ","
                          ; ( "name"
                            , `String
                                "punctuation.definition.seperator.parameter.java"
                            )
                          ]
                      ; `Assoc [ "include", `String "#code" ]
                      ] )
                ] )
          ; ( "methods"
            , `Assoc
                [ ( "begin"
                  , `String "(?!new)(?=[\\w<].*\\s+)(?=([^=/]|/(?!/))+\\()" )
                ; "end", `String "(})|(?=;)"
                ; ( "endCaptures"
                  , `Assoc
                      [ ( "1"
                        , `Assoc
                            [ ( "name"
                              , `String "punctuation.section.method.end.java" )
                            ] )
                      ] )
                ; "name", `String "meta.method.java"
                ; ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#storage-modifiers" ]
                      ; `Assoc
                          [ "begin", `String "(\\w+)\\s*\\("
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "entity.name.function.java" )
                                      ] )
                                ] )
                          ; "end", `String "\\)"
                          ; "name", `String "meta.method.identifier.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#parameters" ]
                                ; `Assoc [ "include", `String "#comments" ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "<"
                          ; "end", `String ">"
                          ; "name", `String "storage.type.token.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#object-types" ]
                                ; `Assoc
                                    [ "begin", `String "<"
                                    ; ( "comment"
                                      , `String
                                          "This is just to support <>'s with \
                                           no actual type prefix" )
                                    ; "end", `String ">|[^\\w\\s,\\[\\]<]"
                                    ; ( "name"
                                      , `String "storage.type.generic.java" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "(?=\\w.*\\s+\\w+\\s*\\()"
                          ; "end", `String "(?=\\w+\\s*\\()"
                          ; "name", `String "meta.method.return-type.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#all-types" ]
                                ; `Assoc [ "include", `String "#comments" ]
                                ] )
                          ]
                      ; `Assoc [ "include", `String "#throws" ]
                      ; `Assoc
                          [ "begin", `String "{"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.section.method.begin.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=})"
                          ; "name", `String "meta.method.body.java"
                          ; ( "patterns"
                            , `List [ `Assoc [ "include", `String "#code" ] ] )
                          ]
                      ; `Assoc [ "include", `String "#comments" ]
                      ] )
                ] )
          ; ( "object-types"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\b((?:[a-z]\\w*\\.)*[A-Z]+\\w*)<"
                          ; "end", `String ">|[^\\w\\s,\\?<\\[\\]]"
                          ; "name", `String "storage.type.generic.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#object-types" ]
                                ; `Assoc
                                    [ "begin", `String "<"
                                    ; ( "comment"
                                      , `String
                                          "This is just to support <>'s with \
                                           no actual type prefix" )
                                    ; "end", `String ">|[^\\w\\s,\\[\\]<]"
                                    ; ( "name"
                                      , `String "storage.type.generic.java" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ ( "begin"
                            , `String "\\b((?:[a-z]\\w*\\.)*[A-Z]+\\w*)(?=\\[)"
                            )
                          ; "end", `String "(?=[^\\]\\s])"
                          ; "name", `String "storage.type.object.array.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "\\["
                                    ; "end", `String "\\]"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#code" ]
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
                                            "keyword.operator.dereference.java"
                                        )
                                      ] )
                                ] )
                          ; ( "match"
                            , `String "\\b(?:[a-z]\\w*(\\.))*[A-Z]+\\w*\\b" )
                          ; "name", `String "storage.type.java"
                          ]
                      ] )
                ] )
          ; ( "object-types-inherited"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\b((?:[a-z]\\w*\\.)*[A-Z]+\\w*)<"
                          ; "end", `String ">|[^\\w\\s,<]"
                          ; "name", `String "entity.other.inherited-class.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#object-types" ]
                                ; `Assoc
                                    [ "begin", `String "<"
                                    ; ( "comment"
                                      , `String
                                          "This is just to support <>'s with \
                                           no actual type prefix" )
                                    ; "end", `String ">|[^\\w\\s,<]"
                                    ; ( "name"
                                      , `String "storage.type.generic.java" )
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
                                            "keyword.operator.dereference.java"
                                        )
                                      ] )
                                ] )
                          ; "match", `String "\\b(?:[a-z]\\w*(\\.))*[A-Z]+\\w*"
                          ; "name", `String "entity.other.inherited-class.java"
                          ]
                      ] )
                ] )
          ; ( "parameters"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "match", `String "final"
                          ; "name", `String "storage.modifier.java"
                          ]
                      ; `Assoc [ "include", `String "#annotations" ]
                      ; `Assoc [ "include", `String "#primitive-arrays" ]
                      ; `Assoc [ "include", `String "#primitive-types" ]
                      ; `Assoc [ "include", `String "#object-types" ]
                      ; `Assoc
                          [ "match", `String "\\w+"
                          ; "name", `String "variable.parameter.java"
                          ]
                      ] )
                ] )
          ; ( "parens"
            , `Assoc
                [ "begin", `String "\\("
                ; "end", `String "\\)"
                ; "patterns", `List [ `Assoc [ "include", `String "#code" ] ]
                ] )
          ; ( "primitive-arrays"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "match"
                            , `String
                                "\\b(?:void|boolean|byte|char|short|int|float|long|double)(\\[\\])*\\b"
                            )
                          ; "name", `String "storage.type.primitive.array.java"
                          ]
                      ] )
                ] )
          ; ( "primitive-types"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "match"
                            , `String
                                "\\b(?:void|var|boolean|byte|char|short|int|float|long|double)\\b"
                            )
                          ; "name", `String "storage.type.primitive.java"
                          ]
                      ] )
                ] )
          ; ( "storage-modifiers"
            , `Assoc
                [ ( "captures"
                  , `Assoc
                      [ "1", `Assoc [ "name", `String "storage.modifier.java" ]
                      ] )
                ; ( "match"
                  , `String
                      "\\b(public|private|protected|static|final|native|synchronized|volatile|abstract|threadsafe|transient)\\b"
                  )
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
                                            "punctuation.definition.string.begin.java"
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
                                            "punctuation.definition.string.end.java"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.double.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "match", `String "\\\\."
                                    ; ( "name"
                                      , `String "constant.character.escape.java"
                                      )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "'"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.java"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "'"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.end.java"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.single.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "match", `String "\\\\."
                                    ; ( "name"
                                      , `String "constant.character.escape.java"
                                      )
                                    ]
                                ] )
                          ]
                      ] )
                ] )
          ; ( "throws"
            , `Assoc
                [ "begin", `String "throws"
                ; ( "beginCaptures"
                  , `Assoc
                      [ "0", `Assoc [ "name", `String "storage.modifier.java" ]
                      ] )
                ; "end", `String "(?={|;)"
                ; "name", `String "meta.throwables.java"
                ; ( "patterns"
                  , `List [ `Assoc [ "include", `String "#object-types" ] ] )
                ] )
          ; ( "values"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#strings" ]
                      ; `Assoc [ "include", `String "#object-types" ]
                      ; `Assoc
                          [ "include", `String "#constants-and-special-vars" ]
                      ] )
                ] )
          ; ( "variables"
            , `Assoc
                [ "applyEndPatternLast", `Int 1
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "begin"
                            , `String
                                "(?x:(?=\n\
                                \                        (?:\n\
                                \                            \
                                 (?:private|protected|public|native|synchronized|volatile|abstract|threadsafe|transient|static|final) \
                                 # visibility/modifier\n\
                                \                                |\n\
                                \                            (?:def)\n\
                                \                                |\n\
                                \                            \
                                 (?:void|boolean|byte|char|short|int|float|long|double)\n\
                                \                                |\n\
                                \                            \
                                 (?:(?:[a-z]\\w*\\.)*[A-Z]+\\w*) # object type\n\
                                \                        )\n\
                                \                        \\s+\n\
                                \                        \
                                 (?!private|protected|public|native|synchronized|volatile|abstract|threadsafe|transient|static|final|def|void|boolean|byte|char|short|int|float|long|double)\n\
                                \                        \
                                 [\\w\\d_<>\\[\\],\\?][\\w\\d_<>\\[\\],\\? \
                                 \\t]*\n\
                                \                        (?:=|$)\n\
                                \                        \n\
                                 \t\t\t\t\t))" )
                          ; "end", `String "(?=;)"
                          ; "name", `String "meta.definition.variable.java"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "match", `String "\\s" ]
                                ; `Assoc
                                    [ ( "captures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "constant.other.variable.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "match", `String "([A-Z_0-9]+)\\s+(?=\\=)"
                                    ]
                                ; `Assoc
                                    [ ( "captures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "meta.definition.variable.name.java"
                                                  )
                                                ] )
                                          ] )
                                    ; ( "match"
                                      , `String "(\\w[^\\s,]*)\\s+(?=\\=)" )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "="
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "0"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "keyword.operator.assignment.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "(?=;)"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#code" ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ ( "captures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "meta.definition.variable.name.java"
                                                  )
                                                ] )
                                          ] )
                                    ; "match", `String "(\\w[^\\s=]*)(?=\\s*;)"
                                    ]
                                ; `Assoc [ "include", `String "#code" ]
                                ] )
                          ]
                      ] )
                ] )
          ] )
    ; "scopeName", `String "source.java"
    ; "uuid", `String "2B449DF6-6B1D-11D9-94EC-000D93589AF6"
    ]
;;

let kotlin =
  `Assoc
    [ "fileTypes", `List [ `String "kt"; `String "kts" ]
    ; "name", `String "Kotlin"
    ; ( "patterns"
      , `List
          [ `Assoc [ "include", `String "#comments" ]
          ; `Assoc
              [ ( "captures"
                , `Assoc
                    [ "1", `Assoc [ "name", `String "keyword.other.kotlin" ]
                    ; ( "2"
                      , `Assoc [ "name", `String "entity.name.package.kotlin" ]
                      )
                    ] )
              ; "match", `String "^\\s*(package)\\b(?:\\s*([^ ;$]+)\\s*)?"
              ]
          ; `Assoc [ "include", `String "#imports" ]
          ; `Assoc [ "include", `String "#statements" ]
          ] )
    ; ( "repository"
      , `Assoc
          [ ( "classes"
            , `Assoc
                [ ( "begin"
                  , `String
                      "(?<!::)(?=\\b(?:companion|class|object|interface)\\b)" )
                ; "end", `String "(?=$|\\})"
                ; ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#comments" ]
                      ; `Assoc
                          [ ( "begin"
                            , `String
                                "\\b(companion\\s*)?(class|object|interface)\\b"
                            )
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "storage.modifier.kotlin" )
                                      ] )
                                ; ( "2"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "storage.modifier.kotlin" )
                                      ] )
                                ] )
                          ; "end", `String "(?=<|\\{|\\(|:|$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#comments" ]
                                ; `Assoc
                                    [ "match", `String "\\w+"
                                    ; ( "name"
                                      , `String "entity.name.type.class.kotlin"
                                      )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "<"
                          ; "end", `String ">"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#generics" ] ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\("
                          ; "end", `String "\\)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#parameters" ] ]
                            )
                          ]
                      ; `Assoc
                          [ "begin", `String "(:)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.declaration.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?={|$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "match", `String "\\w+"
                                    ; ( "name"
                                      , `String
                                          "entity.other.inherited-class.kotlin"
                                      )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "\\("
                                    ; "end", `String "\\)"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ ( "include"
                                                , `String "#expressions" )
                                              ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\{"
                          ; "end", `String "\\}"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#statements" ] ]
                            )
                          ]
                      ] )
                ] )
          ; ( "comments"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "/\\*"
                          ; ( "captures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.comment.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "\\*/"
                          ; "name", `String "comment.block.kotlin"
                          ]
                      ; `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "comment.line.double-slash.kotlin" )
                                      ] )
                                ; ( "2"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.comment.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "match", `String "\\s*((//).*$\\n?)"
                          ]
                      ] )
                ] )
          ; ( "constants"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "match"
                            , `String "\\b(true|false|null|this|super)\\b" )
                          ; "name", `String "constant.language.kotlin"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b((0(x|X)[0-9a-fA-F]*)|(([0-9]+\\.?[0-9]*)|(\\.[0-9]+))((e|E)(\\+|-)?[0-9]+)?)([LlFf])?\\b"
                            )
                          ; "name", `String "constant.numeric.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "\\b([A-Z][A-Z0-9_]+)\\b"
                          ; "name", `String "constant.other.kotlin"
                          ]
                      ] )
                ] )
          ; ( "expressions"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\("
                          ; "end", `String "\\)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#expressions" ] ]
                            )
                          ]
                      ; `Assoc [ "include", `String "#types" ]
                      ; `Assoc [ "include", `String "#strings" ]
                      ; `Assoc [ "include", `String "#constants" ]
                      ; `Assoc [ "include", `String "#comments" ]
                      ; `Assoc [ "include", `String "#keywords" ]
                      ] )
                ] )
          ; ( "functions"
            , `Assoc
                [ "begin", `String "(?=\\s*\\b(?:fun)\\b)"
                ; "end", `String "(?=$|\\})"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\b(fun)\\b"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ "name", `String "keyword.other.kotlin" ]
                                  )
                                ] )
                          ; "end", `String "(?=\\()"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "<"
                                    ; "end", `String ">"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#generics" ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ ( "captures"
                                      , `Assoc
                                          [ ( "2"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "entity.name.function.kotlin"
                                                  )
                                                ] )
                                          ] )
                                    ; ( "match"
                                      , `String "([\\.<\\?>\\w]+\\.)?(\\w+)" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\("
                          ; "end", `String "\\)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#parameters" ] ]
                            )
                          ]
                      ; `Assoc
                          [ "begin", `String "(:)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.declaration.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?={|=|$)"
                          ; ( "patterns"
                            , `List [ `Assoc [ "include", `String "#types" ] ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\{"
                          ; "end", `String "(?=\\})"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#statements" ] ]
                            )
                          ]
                      ; `Assoc
                          [ "begin", `String "(=)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.assignment.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#expressions" ] ]
                            )
                          ]
                      ] )
                ] )
          ; ( "generics"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "(:)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.declaration.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=,|>)"
                          ; ( "patterns"
                            , `List [ `Assoc [ "include", `String "#types" ] ] )
                          ]
                      ; `Assoc [ "include", `String "#keywords" ]
                      ; `Assoc
                          [ "match", `String "\\w+"
                          ; "name", `String "storage.type.generic.kotlin"
                          ]
                      ] )
                ] )
          ; ( "getters-and-setters"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\b(get)\\b\\s*\\(\\s*\\)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "entity.name.function.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "\\}|(?=\\bset\\b)|$"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "(=)"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "keyword.operator.assignment.kotlin"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "(?=$|\\bset\\b)"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ ( "include"
                                                , `String "#expressions" )
                                              ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "\\{"
                                    ; "end", `String "\\}"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ ( "include"
                                                , `String "#expressions" )
                                              ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\b(set)\\b\\s*(?=\\()"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String "entity.name.function.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "\\}|(?=\\bget\\b)|$"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "\\("
                                    ; "end", `String "\\)"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#parameters"
                                              ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "(=)"
                                    ; ( "beginCaptures"
                                      , `Assoc
                                          [ ( "1"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "keyword.operator.assignment.kotlin"
                                                  )
                                                ] )
                                          ] )
                                    ; "end", `String "(?=$|\\bset\\b)"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ ( "include"
                                                , `String "#expressions" )
                                              ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ "begin", `String "\\{"
                                    ; "end", `String "\\}"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ ( "include"
                                                , `String "#expressions" )
                                              ]
                                          ] )
                                    ]
                                ] )
                          ]
                      ] )
                ] )
          ; ( "imports"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "captures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ "name", `String "keyword.other.kotlin" ]
                                  )
                                ; ( "2"
                                  , `Assoc
                                      [ "name", `String "keyword.other.kotlin" ]
                                  )
                                ] )
                          ; "match", `String "^\\s*(import)\\s+[^ $]+\\s+(as)?"
                          ]
                      ] )
                ] )
          ; ( "keywords"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "match"
                            , `String
                                "\\b(var|val|public|private|protected|abstract|final|sealed|enum|open|attribute|annotation|override|inline|vararg|in|out|internal|data|tailrec|operator|infix|const|yield|typealias|typeof|reified|suspend)\\b"
                            )
                          ; "name", `String "storage.modifier.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "\\b(try|catch|finally|throw)\\b"
                          ; ( "name"
                            , `String "keyword.control.catch-exception.kotlin" )
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b(if|else|while|for|do|return|when|where|break|continue)\\b"
                            )
                          ; "name", `String "keyword.control.kotlin"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String "\\b(in|is|!in|!is|as|as\\?|assert)\\b" )
                          ; "name", `String "keyword.operator.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(==|!=|===|!==|<=|>=|<|>)"
                          ; "name", `String "keyword.operator.comparison.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(=)"
                          ; "name", `String "keyword.operator.assignment.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(::)"
                          ; "name", `String "keyword.operator.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(:)"
                          ; ( "name"
                            , `String "keyword.operator.declaration.kotlin" )
                          ]
                      ; `Assoc
                          [ "match", `String "\\b(by)\\b"
                          ; "name", `String "keyword.other.by.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\?\\.)"
                          ; "name", `String "keyword.operator.safenav.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\.)"
                          ; "name", `String "keyword.operator.dot.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\?:)"
                          ; "name", `String "keyword.operator.elvis.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\-\\-|\\+\\+)"
                          ; ( "name"
                            , `String
                                "keyword.operator.increment-decrement.kotlin" )
                          ]
                      ; `Assoc
                          [ "match", `String "(\\+=|\\-=|\\*=|\\/=)"
                          ; ( "name"
                            , `String
                                "keyword.operator.arithmetic.assign.kotlin" )
                          ]
                      ; `Assoc
                          [ "match", `String "(\\.\\.)"
                          ; "name", `String "keyword.operator.range.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(\\-|\\+|\\*|\\/|%)"
                          ; "name", `String "keyword.operator.arithmetic.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(!|&&|\\|\\|)"
                          ; "name", `String "keyword.operator.logical.kotlin"
                          ]
                      ; `Assoc
                          [ "match", `String "(;)"
                          ; "name", `String "punctuation.terminator.kotlin"
                          ]
                      ] )
                ] )
          ; ( "namespaces"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "match", `String "\\b(namespace)\\b"
                          ; "name", `String "keyword.other.kotlin"
                          ]
                      ; `Assoc
                          [ "begin", `String "\\{"
                          ; "end", `String "\\}"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#statements" ] ]
                            )
                          ]
                      ] )
                ] )
          ; ( "parameters"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "(:)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.declaration.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=,|\\)|=)"
                          ; ( "patterns"
                            , `List [ `Assoc [ "include", `String "#types" ] ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "(=)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.declaration.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=,|\\))"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#expressions" ] ]
                            )
                          ]
                      ; `Assoc [ "include", `String "#keywords" ]
                      ; `Assoc
                          [ "match", `String "\\w+"
                          ; "name", `String "variable.parameter.function.kotlin"
                          ]
                      ] )
                ] )
          ; ( "statements"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc [ "include", `String "#namespaces" ]
                      ; `Assoc [ "include", `String "#typedefs" ]
                      ; `Assoc [ "include", `String "#classes" ]
                      ; `Assoc [ "include", `String "#functions" ]
                      ; `Assoc [ "include", `String "#variables" ]
                      ; `Assoc [ "include", `String "#getters-and-setters" ]
                      ; `Assoc [ "include", `String "#expressions" ]
                      ] )
                ] )
          ; ( "strings"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\"\"\""
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "\"\"\""
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.end.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.third.kotlin"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "match"
                                      , `String "(\\$\\w+|\\$\\{[^\\}]+\\})" )
                                    ; ( "name"
                                      , `String
                                          "variable.parameter.template.kotlin" )
                                    ]
                                ; `Assoc
                                    [ "match", `String "\\\\."
                                    ; ( "name"
                                      , `String
                                          "constant.character.escape.kotlin" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\""
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.kotlin"
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
                                            "punctuation.definition.string.end.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.double.kotlin"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ ( "match"
                                      , `String "(\\$\\w+|\\$\\{[^\\}]+\\})" )
                                    ; ( "name"
                                      , `String
                                          "variable.parameter.template.kotlin" )
                                    ]
                                ; `Assoc
                                    [ "match", `String "\\\\."
                                    ; ( "name"
                                      , `String
                                          "constant.character.escape.kotlin" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "'"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "'"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.end.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.single.kotlin"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "match", `String "\\\\."
                                    ; ( "name"
                                      , `String
                                          "constant.character.escape.kotlin" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "`"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.begin.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "`"
                          ; ( "endCaptures"
                            , `Assoc
                                [ ( "0"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "punctuation.definition.string.end.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "name", `String "string.quoted.single.kotlin"
                          ]
                      ] )
                ] )
          ; ( "typedefs"
            , `Assoc
                [ "begin", `String "(?=\\s*(?:type))"
                ; "end", `String "(?=$)"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ "match", `String "\\b(type)\\b"
                          ; "name", `String "keyword.other.kotlin"
                          ]
                      ; `Assoc
                          [ "begin", `String "<"
                          ; "end", `String ">"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#generics" ] ] )
                          ]
                      ; `Assoc [ "include", `String "#expressions" ]
                      ] )
                ] )
          ; ( "types"
            , `Assoc
                [ ( "patterns"
                  , `List
                      [ `Assoc
                          [ ( "match"
                            , `String
                                "\\b(Nothing|Any|Unit|String|CharSequence|Int|Boolean|Char|Long|Double|Float|Short|Byte|dynamic)\\b"
                            )
                          ; "name", `String "storage.type.buildin.kotlin"
                          ]
                      ; `Assoc
                          [ ( "match"
                            , `String
                                "\\b(IntArray|BooleanArray|CharArray|LongArray|DoubleArray|FloatArray|ShortArray|ByteArray)\\b"
                            )
                          ; "name", `String "storage.type.buildin.array.kotlin"
                          ]
                      ; `Assoc
                          [ ( "begin"
                            , `String
                                "\\b(Array|Collection|List|Map|Set|MutableList|MutableMap|MutableSet|Sequence)<\\b"
                            )
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "storage.type.buildin.collection.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String ">"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#types" ]
                                ; `Assoc [ "include", `String "#keywords" ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\w+<"
                          ; "end", `String ">"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#types" ]
                                ; `Assoc [ "include", `String "#keywords" ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\{"
                          ; "end", `String "\\}"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#statements" ] ]
                            )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\("
                          ; "end", `String "\\)"
                          ; ( "patterns"
                            , `List [ `Assoc [ "include", `String "#types" ] ] )
                          ]
                      ; `Assoc
                          [ "match", `String "(->)"
                          ; ( "name"
                            , `String "keyword.operator.declaration.kotlin" )
                          ]
                      ] )
                ] )
          ; ( "variables"
            , `Assoc
                [ "begin", `String "(?=\\s*\\b(?:var|val)\\b)"
                ; "end", `String "(?=:|=|(\\b(by)\\b)|$)"
                ; ( "patterns"
                  , `List
                      [ `Assoc
                          [ "begin", `String "\\b(var|val)\\b"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ "name", `String "keyword.other.kotlin" ]
                                  )
                                ] )
                          ; "end", `String "(?=:|=|(\\b(by)\\b)|$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc
                                    [ "begin", `String "<"
                                    ; "end", `String ">"
                                    ; ( "patterns"
                                      , `List
                                          [ `Assoc
                                              [ "include", `String "#generics" ]
                                          ] )
                                    ]
                                ; `Assoc
                                    [ ( "captures"
                                      , `Assoc
                                          [ ( "2"
                                            , `Assoc
                                                [ ( "name"
                                                  , `String
                                                      "entity.name.variable.kotlin"
                                                  )
                                                ] )
                                          ] )
                                    ; ( "match"
                                      , `String "([\\.<\\?>\\w]+\\.)?(\\w+)" )
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "(:)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.declaration.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?==|$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#types" ]
                                ; `Assoc
                                    [ "include", `String "#getters-and-setters"
                                    ]
                                ] )
                          ]
                      ; `Assoc
                          [ "begin", `String "\\b(by)\\b"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ "name", `String "keyword.other.kotlin" ]
                                  )
                                ] )
                          ; "end", `String "(?=$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#expressions" ] ]
                            )
                          ]
                      ; `Assoc
                          [ "begin", `String "(=)"
                          ; ( "beginCaptures"
                            , `Assoc
                                [ ( "1"
                                  , `Assoc
                                      [ ( "name"
                                        , `String
                                            "keyword.operator.assignment.kotlin"
                                        )
                                      ] )
                                ] )
                          ; "end", `String "(?=$)"
                          ; ( "patterns"
                            , `List
                                [ `Assoc [ "include", `String "#expressions" ]
                                ; `Assoc
                                    [ "include", `String "#getters-and-setters"
                                    ]
                                ] )
                          ]
                      ] )
                ] )
          ] )
    ; "scopeName", `String "source.Kotlin"
    ; "uuid", `String "d508c059-a938-4779-b2bc-ff43a5078907"
    ]
;;

let lisp =
  `Assoc
    [ "comment", `String ""
    ; ( "fileTypes"
      , `List
          [ `String "lisp"
          ; `String "cl"
          ; `String "l"
          ; `String "mud"
          ; `String "el"
          ] )
    ; "keyEquivalent", `String "^~L"
    ; "name", `String "Lisp"
    ; ( "patterns"
      , `List
          [ `Assoc
              [ "begin", `String "(^[ \\t]+)?(?=;)"
              ; ( "beginCaptures"
                , `Assoc
                    [ ( "1"
                      , `Assoc
                          [ ( "name"
                            , `String
                                "punctuation.whitespace.comment.leading.lisp" )
                          ] )
                    ] )
              ; "end", `String "(?!\\G)"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ "begin", `String ";"
                        ; ( "beginCaptures"
                          , `Assoc
                              [ ( "0"
                                , `Assoc
                                    [ ( "name"
                                      , `String
                                          "punctuation.definition.comment.lisp"
                                      )
                                    ] )
                              ] )
                        ; "end", `String "\\n"
                        ; "name", `String "comment.line.semicolon.lisp"
                        ]
                    ] )
              ]
          ; `Assoc
              [ ( "captures"
                , `Assoc
                    [ ( "2"
                      , `Assoc
                          [ "name", `String "storage.type.function-type.lisp" ]
                      )
                    ; ( "4"
                      , `Assoc [ "name", `String "entity.name.function.lisp" ] )
                    ] )
              ; ( "match"
                , `String
                    "(\\b(?i:(defun|defgeneric|defmethod|defmacro|defclass|defstruct|defconstant|defvar|defparameter))\\b)(\\s+)((\\w|\\-|\\!|\\?)*)"
                )
              ; "name", `String "meta.function.lisp"
              ]
          ; `Assoc
              [ ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.constant.lisp" )
                          ] )
                    ] )
              ; "match", `String "(#|\\?)(\\w|[\\\\+-=<>'\"&#])+"
              ; "name", `String "constant.character.lisp"
              ]
          ; `Assoc
              [ ( "captures"
                , `Assoc
                    [ ( "1"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.variable.lisp" )
                          ] )
                    ; ( "3"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.variable.lisp" )
                          ] )
                    ] )
              ; "match", `String "(\\*)(\\S*)(\\*)"
              ; "name", `String "variable.other.global.lisp"
              ]
          ; `Assoc
              [ ( "match"
                , `String
                    "\\b(?i:case|ecase|ccase|typecase|etypecase|ctypecase|do|dolist|dotimes|let|let\\*|labels|flet|loop|if|else|when|unless)\\b"
                )
              ; "name", `String "keyword.control.lisp"
              ]
          ; `Assoc
              [ "match", `String "\\b(?i:eq|neq|and|or|not)\\b"
              ; "name", `String "keyword.operator.lisp"
              ]
          ; `Assoc
              [ "match", `String "\\b(?i:null|nil)\\b"
              ; "name", `String "constant.language.lisp"
              ]
          ; `Assoc
              [ ( "match"
                , `String
                    "(?<![-\\w])(?i:cons|car|cdr|cond|lambda|format|setq|setf|quote|eval|append|list|listp|memberp|t|load|progn)(?![-\\w])"
                )
              ; "name", `String "support.function.lisp"
              ]
          ; `Assoc
              [ ( "match"
                , `String
                    "\\b((0(x|X)[0-9a-fA-F]*)|(([0-9]+\\.?[0-9]*)|(\\.[0-9]+))((e|E)(\\+|-)?[0-9]+)?)(L|l|UL|ul|u|U|F|f|ll|LL|ull|ULL)?\\b"
                )
              ; "name", `String "constant.numeric.lisp"
              ]
          ; `Assoc
              [ "begin", `String "\""
              ; ( "beginCaptures"
                , `Assoc
                    [ ( "0"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.string.begin.lisp"
                            )
                          ] )
                    ] )
              ; "end", `String "\""
              ; ( "endCaptures"
                , `Assoc
                    [ ( "0"
                      , `Assoc
                          [ ( "name"
                            , `String "punctuation.definition.string.end.lisp" )
                          ] )
                    ] )
              ; "name", `String "string.quoted.double.lisp"
              ; ( "patterns"
                , `List
                    [ `Assoc
                        [ "match", `String "\\\\."
                        ; "name", `String "constant.character.escape.lisp"
                        ]
                    ] )
              ]
          ] )
    ; "scopeName", `String "source.lisp"
    ; "uuid", `String "00D451C9-6B1D-11D9-8DFA-000D93589AF6"
    ]
;;
