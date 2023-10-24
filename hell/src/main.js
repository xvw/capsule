import { DAppClient } from "@airgap/beacon-sdk";

import hljs from "highlight.js/lib/core";
import ocaml from "highlight.js/lib/languages/ocaml";
import java from "highlight.js/lib/languages/java";
import kotlin from "highlight.js/lib/languages/kotlin";
import haskell from "highlight.js/lib/languages/haskell";

window.DAppClient = DAppClient;

hljs.registerLanguage("ocaml", ocaml);
hljs.registerLanguage("java", java);
hljs.registerLanguage("kotlin", kotlin);
hljs.registerLanguage("haskell", haskell);
window.hljs = hljs;
