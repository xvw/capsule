import hljs from "highlight.js/lib/core";
import ocaml from "highlight.js/lib/languages/ocaml";
import java from "highlight.js/lib/languages/java";
import kotlin from "highlight.js/lib/languages/kotlin";
import haskell from "highlight.js/lib/languages/haskell";
import diff from "highlight.js/lib/languages/diff";

hljs.registerLanguage("ocaml", ocaml);
hljs.registerLanguage("java", java);
hljs.registerLanguage("kotlin", kotlin);
hljs.registerLanguage("haskell", haskell);
hljs.registerLanguage("diff", diff);

window.hljs = hljs;
