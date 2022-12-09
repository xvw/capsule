import hljs from 'highlight.js/lib/core';
import ocaml from 'highlight.js/lib/languages/ocaml';
import java from 'highlight.js/lib/languages/java';
import kotlin from 'highlight.js/lib/languages/kotlin';

hljs.registerLanguage('ocaml', ocaml);
hljs.registerLanguage('java', java);
hljs.registerLanguage('kotlin', kotlin)
window.hljs = hljs;