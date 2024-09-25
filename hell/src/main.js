import hljs from "highlight.js/lib/core";
import ocaml from "highlight.js/lib/languages/ocaml";
import java from "highlight.js/lib/languages/java";
import kotlin from "highlight.js/lib/languages/kotlin";
import haskell from "highlight.js/lib/languages/haskell";
import diff from "highlight.js/lib/languages/diff";
import lisp from "highlight.js/lib/languages/lisp";
import scheme from "highlight.js/lib/languages/scheme";

hljs.registerLanguage("ocaml", ocaml);
hljs.registerLanguage("java", java);
hljs.registerLanguage("kotlin", kotlin);
hljs.registerLanguage("haskell", haskell);
hljs.registerLanguage("diff", diff);
hljs.registerLanguage("lisp", diff);
hljs.registerLanguage("scheme", diff);

window.hljs = hljs;
