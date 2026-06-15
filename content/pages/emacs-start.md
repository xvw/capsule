---
page_title: Emacs, comment tout a démarré (pour moi)
description:
  Une présentation de pourquoi, et de comment, j'ai commencer à utiliser Emacs
tags: [programmation, emacs, decouverte]
section: outils
published_at: 2026-06-15
display_toc: true
breadcrumb:
  - title: Outils
    url: /tools.html
  - title: Emacs
    url: /tools.html#index-emacs
synopsis:
  J'utilise (_mal_) [Emacs](https://www.gnu.org/software/emacs/)
  depuis approximativement 2008. Dans ce bref article,
  je vais essayer de vous présenter la **manière chaotique** qui m'a conduit
  à choisir Emacs comme éditeur, de texte et de code, principal. Ce n'est **absolument
  pas un article pédagogique**, c'est _un petit fragment de mon lore personnel_
  parce que c'est très rigolo de décrire des choix maladroits qui se sont révélés
  être, de mon point de vue, bénéfiques. Cet article est **grandement inspiré**,
  tout en étant moins ambitieux, du sujet
  [d'avril 2026](https://www.emacswiki.org/emacs/CarnivalApril2026)
  de [l'Emacs Carnival](https://www.emacswiki.org/emacs/Carnival).
---

Alors que je peux avoir des opinions très tranchées sur beaucoup de
sujets (notamment sur [les langages de
programmation](/pages/why-ocaml.html)), je suis moralement beaucoup
moins impliqué dans l'ancestrale [_Guerre des
éditeurs_](https://en.wikipedia.org/wiki/Editor_war). En effet, même
s'il m'arrive de défendre, _mordicus_, Emacs, pour être honnête, je
n'y connais pas grand-chose et **je n'ai jamais essayé
[Vi/Vim](https://www.vim.org/)** (ni ses
[variations](https://neovim.io/)). Ne voyez donc dans cet article
qu'une restitution approximative des raisons _historiques_ qui m'ont
fait choisir Emacs et non une tentative de conversation.

> Je n'ai absolument rien contre les autres éditeurs. Même si mon
activité professionnelle m'amène à travailler sur le support éditeur
du langage OCaml, et que j'ai parfois été chagriné par les difficultés
que l'on peut rencontrer en étendant [Visual > Studio
Code](https://code.visualstudio.com/), je n'entretiens aucune
hostilité particulière à leur égard. De même, bien que je tâche de
privilégier les logiciels libres dans la mesure du possible, je ne
suis malheureusement pas très au fait des questions de licences, des
différentes philosophies ou, plus généralement, de tout ce qui touche
au monde [GNU](https://en.wikipedia.org/wiki/GNU). Mon choix d'Emacs
n'est donc pas politique, mais pragmatique, comme nous essaierons de
le voir dans cet article.


## Ma préhistoire

Avant de raconter ma rencontre avec Emacs, je me permets un petit
détour par les choix complètement stupides que j'ai pu faire au fil
des années avant de commencer à sérieusement écrire du code. En effet,
lorsqu'on commence à découvrir la programmation en autodidacte, on
peut faire face à de nombreuses difficultés et, pour ma part, dès les
premières secondes, je me suis heurté à des problèmes terminologiques.

### Écrire du code avec Microsoft Word

Comme beaucoup de personnes de ma génération, j'ai commencé
*sérieusement* à essayer de programmer avec
[PHP](https://www.php.net/). À l'époque, je n'avais pas accès
régulièrement à une connexion internet, donc j'apprenais
essentiellement avec des livres et, n'ayant pas les droits
d'installation sur mon ordinateur, **j'imaginais que ce que j'écrivais
fonctionnait** (*true story*). À l'époque, le livre que j'utilisais
pour essayer de comprendre PHP (dont je ne me souviens malheureusement
plus du nom ni de l'édition) affirmait, dans son introduction, **que
pour écrire du code, nous pouvions utiliser n'importe quel éditeur de
texte**. Comme j'étais très jeune et que je n'exécutais pas mon code,
j'ai pris la décision d'utiliser [Microsoft
Word](https://en.wikipedia.org/wiki/Microsoft_Word). Et oui,
comprendre la différence entre un *éditeur de texte* et un *éditeur de
texte riche* était, à cette époque, trop me demander.


### EasyPHP, Notepad et Notepad++

Après avoir enfin eu l'occasion de tester le code que j'écrivais, *par
le biais d'un CD-ROM* fournissant un installateur de
[EasyPHP](https://www.easyphp.org/), j'ai pu *naïvement comprendre la
différence entre un éditeur de texte et un éditeur de texte riche* et
... je suis passé à
[Notepad](https://en.wikipedia.org/wiki/Windows_Notepad). À l'époque,
je ne comprenais pas vraiment le code que j'écrivais (et
copiais-collais), je ne me rendais pas vraiment compte de l'importance
de la coloration syntaxique et de la préservation de l'indentation.

Avec la possibilité *d'exécuter mes programmes PHP*, j'ai pu être de
plus en plus ambitieux et j'ai finalement découvert **mon premier
éditeur de code** :
[Notepad++](https://en.wikipedia.org/wiki/Notepad%2B%2B). Une
véritable *épiphanie*.


> C'est très amusant de se rendre compte que, lorsqu'on n'a pas été
> confronté à un outil confortable, on pallie laborieusement son
> absence, en imaginant que l'on pourra s'en passer toute sa
> vie. J'imagine que cela s'applique aussi aux langages de
> programmation. [Sans types sommes](https://go.dev/), on imagine que
> cela n'est pas particulièrement utile, jusqu'à ce que l'on s'en
> serve... concrètement.


J'ai longuement utilisé Notepad++, en faisant quelques détours par
[SciTE](https://en.wikipedia.org/wiki/SciTE), puis par
[Eclipse](https://en.wikipedia.org/wiki/Eclipse_%28software%29) et son
support PHP (qui, bien qu'offrant davantage de fonctionnalités, même à
une époque
[*pré-LSP*](https://fr.wikipedia.org/wiki/Language_Server_Protocol),
m'a posé beaucoup de problèmes, probablement parce que je n'étais pas
câblé pour cet outil).

Ensuite, j'ai pris le train [Sublime
Text](https://fr.wikipedia.org/wiki/Sublime_Text) en pensant que ce
serait **le dernier éditeur de code que j'utiliserais de toute ma
vie**, tant j'étais convaincu par son ergonomie et son esthétique.


### Le Site du Zero : à la découverte des alternatives

Après avoir utilisé PHP *pour faire des trucs*, j'ai commencé à
m'intéresser à la programmation **pour la programmation**, et je suis
arrivé sur [Le Site Du
Zéro](https://en.wikipedia.org/wiki/OpenClassrooms#History). J'avais
été actif sur *Le Site Du Zéro* en tant que *"programmeur PHP"*, mais
je n'étais pas particulièrement familier avec le forum (et avec *les
forums* de manière générale). Une des forces du *Site Du Zéro*, en
plus de certains de ses *tutoriels*, était **sa communauté** (qui aura
été fortement diminuée lors de sa mutation en
[OpenClassrooms](https://openclassrooms.com/en/)).

En effet, sur ce forum très actif, on retrouvait une collection
d'utilisateurs passionnés par la programmation, utilisant des langages
très différents de ceux auxquels j'avais été confronté ! En arpentant
les différents *topics* des forums, j'ai pu découvrir les noms de
langages comme [OCaml](https://ocaml.org),
[Erlang](https://www.erlang.org/),
[Forth](https://en.wikipedia.org/wiki/Forth_%28programming_language%29),
[Haskell](https://www.haskell.org/),
[Io](https://en.wikipedia.org/wiki/Io_%28programming_language%29),
[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk), des
[Lisp](https://en.wikipedia.org/wiki/Lisp_%28programming_language%29)
et plein d'autres, plus ou moins *obscurs*.

En 2026, cette liste est probablement décevante, car ces langages sont
devenus populaires. Mais à l'époque, alors que je ne connaissais que
PHP, j'étais très peu éduqué sur la grande diversité des langages de
programmation.


> Il est très amusant de voir que, plus de 15 ans après, cette
> stimulation de curiosité m'a poussé à m'orienter vers l'utilisation
> professionnelle de langages moins populaires, comme Erlang et OCaml,
> et que j'ai eu l'opportunité (et l'honneur) de collaborer avec des
> utilisateurs tellement en avance sur mes connaissances qu'ils m'ont
> implicitement fait découvrir ces langages alternatifs.

C'était très motivant de découvrir ces autres langages, cependant,
j'étais assez frustré de me rendre compte que je ne comprenais
rien. J'ai donc décidé de me former à le plus de langages possible, en
espérant que cela me permettrait d'améliorer mon PHP et, surtout, de
choisir le langage idéal en fonction des problèmes rencontrés, en
essayant d'éviter de tomber dans la [Loi de
l'instrument](https://en.wikipedia.org/wiki/Law_of_the_instrument),
piège dans lequel je suis tombé bien plus tard, car maintenant, **dans
les projets que je fais au quotidien**, j'en suis arrivé à la
conclusion que **OCaml est toujours la bonne réponse**, _héhéhé_.

#### Expérimentation du plus de langages possible

J'étais _très très motivé_ et je me suis rendu sur la page [_List of
programming
languages_](https://en.wikipedia.org/wiki/List_of_programming_languages)
avec **un objectif simple** : pour chaque langage, essayer de trouver
un compilateur ou un interpréteur, et tenter d'écrire un interpréteur
[Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) ! Je m'autorisais
évidemment la liberté de ne pas essayer certains langages s'ils
étaient trop loin d'une utilisation concrète envisageable (envisager
un interpréteur Brainfuck en
[HAL/S](https://en.wikipedia.org/wiki/HAL/S), par exemple, me semblait
très ambitieux).

## Emacs, à la rescousse ... pour Windows

À l'époque, j'utilisais beaucoup les logiciels de la [suite
Adobe](https://en.wikipedia.org/wiki/Adobe_Creative_Suite) et Windows,
et je ne me rendais pas compte à quel point, pour apprendre à
programmer, c'était, à l'époque, handicapant. Ce qui rendait ma quête
de compilateurs et interpréteurs installables **largement plus
compliquée**. De plus, m'étant habitué à la coloration syntaxique et à
la préservation de l'indentation, je voulais aussi avoir un support
d'éditeur _suffisant_.


### Un mode par problème et un excellent support Windows

Il se trouve qu'à l'époque, avant que les protocoles de normalisation
d'interaction éditeurs comme LSP (ou _TreeSitter_) soient vraiment
matures, j'ai eu l'impression que **Emacs était la norme**. En effet,
même pour [des langages qui me semblaient
obscurs](https://en.wikipedia.org/wiki/Lustre_(programming_language)),
je trouvais presque toujours un [mode Emacs
correspondant](https://www.gricad-gitlab.univ-grenoble-alpes.fr/verimag/reproducible-research/run-bench/-/blob/main/styles/emacs/lustre.el)
! De plus, **aussi étonnant que cela puisse paraître**, le support
Windows d'Emacs était (et doit toujours l'être) excellent.

La seule difficulté concrète à laquelle, à l'époque, j'ai dû faire
face est qu'en tant qu'utilisateur Windows débutant, je n'avais aucune
idée de ce qu'était mon `$PATH`, et j'ai passé beaucoup de temps à
chercher "_comment et où configurer Emacs_".

Après des dizaines d'expérimentations, Windows devenait trop limité,
je suis donc passé à une distribution Linux, d'abord par
virtualisation, ensuite en _dual-boot_, pour qu'en 2014 je supprime ma
partition Windows et passe de _mauvais utilisateur Windows_ à _mauvais
utilisateur Linux_.

## Conclusion

C'est assez amusant que j'utilise un des
[premiers](https://en.wikipedia.org/wiki/History_of_free_and_open-source_software)
logiciels libres sur une distribution propriétaire pour finalement
décider de migrer définitivement vers quelque chose de _plus
libre_. J'ai continué à utiliser Emacs comme éditeur principal au fil
des années, en essayant d'apprendre progressivement à m'en servir plus
efficacement. Cette phase d'apprentissage est toujours en cours, même
si maintenant je maintiens mon [propre
paquet](https://github.com/tarides/ocaml-eglot), j'ai appris à faire
une [configuration discutablement
générique](https://github.com/xvw/scame) et je lis avidement
différents _feeds_ relatifs à Emacs.

J'ai parfois dû faire des détours par d'autres éditeurs, comme
[IntelliJ](https://www.jetbrains.com/) (_JVM oblige_) et [Visual
Studio](https://visualstudio.microsoft.com/) (_#NET oblige_), et il
m'est arrivé d'expérimenter des alternatives. Cependant, le temps et
les habitudes avaient fait leur nid, **je reviens toujours
invariablement à Emacs** (la mémoire musculaire). Des années plus
tard, je ne regrette absolument pas ce choix, pris pour des raisons
_ad hoc_ et chaotiques. Je suis un utilisateur d'Emacs !

C'était un article un _peu plus long que prévu_, avec beaucoup de
détours et pas beaucoup d'informations utiles. Si vous êtes arrivé
jusqu'ici, _merci_ !
