import { DAppClient } from "@airgap/beacon-sdk";

import hljs from 'highlight.js/lib/core';
import ocaml from 'highlight.js/lib/languages/ocaml';
import java from 'highlight.js/lib/languages/java';
import kotlin from 'highlight.js/lib/languages/kotlin';

window.DAppClient = DAppClient;

hljs.registerLanguage('ocaml', ocaml);
hljs.registerLanguage('java', java);
hljs.registerLanguage('kotlin', kotlin)
window.hljs = hljs;