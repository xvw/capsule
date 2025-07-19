---
page_title: Colophon
description: Information sur comment cette application web est construite
tags: [misc, meta, colophon, ocaml]
display_toc: true
breadcrumb:
  - title: Meta
    url: /#index-meta
synopsis:
  Cette page décrit le rôle de ce site web. Elle décrit aussi
  les différentes ressources et bibliothèques utilisées. Un **Colophon** est,
  historiquement, en imprimerie, un encadré donnant des informations sur le
  résultat d'une impression. C'était donc une manière un peu manuelle d'attacher
  des _méta-données_. Je ne sais pas si c'est un titre de page pertinent, mais
  il est souvent utilisé, dans la _blogosphère_ (et spécifiquement dans
  [l'anneau web](https://webring.xxiivv.com/) dont j'ai fait partie pendant
  plusieures années) pour décrire les différents processus et outils utilisés
  pour décrire un site web.
published_at: 2024-02-02
updated_at: 2024-11-19
---

Vous êtes sur ma _page personnelle_ et son objectif est de me
permettre d'avoir un espace de _publication libre_. Où je peux choisir
les thématiques que je veux traiter et où il est possible de
structurer mes documents à ma guise. Les grandes sections présentent
sur [l'index](/) décrivent des **thématiques**, qui elles-même sont
regroupées en **sections**. L'application possède aussi un
[journal](/journal/), me permettant de rédiger _à la manière d'un
blog_. Les documents peuvent être des articles, des guides ou des
[galeries](/galleries.html).

Mon tout premier site personnel date de 2001, et avait été construit
avec l'éditeur en ligne du site
[voila.fr](https://fr.wikipedia.org/wiki/Voila), au fil des années,
j'ai eu beaucoup de sites différents (et j'ai utilisé beaucoup de
platformes différentes) dont la première archive, encore accessible,
[date de
2004](https://web.archive.org/web/20040724002549/http://www.destination-x.be.tf/)
(attention, c'est _cringe_). Depuis quelques années, j'utilise des
générateurs de sites statiques et mon contenu est versionné sur un
dépôt Git, rendant l'archivage plus aisé (il est possible de retrouver
des archives en cherchant
[nukifw.github.io](https://web.archive.org/web/20240000000000*/nukifw.github.io)
et
[xvw.github.io](https://web.archive.org/web/20240000000000*/xvw.github.io)).

### Thématiques et navigation

Alors que pendant très longtemps, je tâchais de _dupliquer_ mes
espaces de rédactions pour garantir que chacun de mes sites
possédaient une thématique clair, j'ai, vers 2014, commencé à être
amusé par certaines pages de chercheurs qui exploitaient leurs espaces
numériques pour discuter de sujets variés. Par exemple, je me souviens
d'une page de [Joe
Armstrong](https://en.wikipedia.org/wiki/Joe_Armstrong_(programmer)),
le créateur de [Erlang](https://www.erlang.org/) qui, au milieu d'une
[liste de projets très
sérieux](https://web.archive.org/web/20150905063923/https://www.sics.se/%7ejoe/bluetail/index.html),
décrivait comment il avait construit des [fusées propulsées à
l'eau](https://web.archive.org/web/20150905140220/https://www.sics.se/%7ejoe/bluetail/misc/water.html).
Ou encore certains chercheurs de [INRIA](https://www.inria.fr/fr)
profitant de leurs pages pour partager leurs photos de vacances.

Plus tard, en fréquentant l'instance Mastodon
[Merveilles](https://merveilles.town/getting-started), j'ai découvert
une [collection de sites](https://webring.xxiivv.com/) dans lesquels
il était possible de se perdre pendant plusieurs heures. Le site de
[Devine Lu Linvega](https://wiki.xxiivv.com/site/home.html) en est, de
mon point de vue, un excellent exemple. On clique sur un lien, et,
quelques heures plus tard, on s'est perdu au détour d'une section,
appartenant elle-même à une rubrique.  L'auteur décrit d'ailleurs son
site, dans la conférence [The Frameworks for
Mystics](https://www.youtube.com/watch?v=w5bbJcimCcs), comme une ville
_labyrinthique_ dans lequel il est possible de se perdre.

Cette approche du web, que l'on appelle maintenant [_Le Web
Indie_](https://indieweb.org/) est un retour aux fondamentaux, à
l'époque [Geocities](https://fr.wikipedia.org/wiki/GeoCities) où les
internautes étaient très créatifs et rigolos. La popularité des
platforme de publications _à la Medium_ a **normalisé** le contenu en
ligne, et certains, dont je fais partie, trouvent ça dommage. C'est
pour cette raison que j'ai pris, à la refonte de mon site personnel,
la décision de ne pas **figer sa thématique**, et de m'offrir la
liberté d'écrire sur **tout ce dont j'ai envie**. N'étant pas très
productif, il est possible que mon site ne ressemble jamais à une
ville dans laquelle il est possible de se perdre, mais la navigation
_structurée, mais pas trop,_ sert cette ambition.

### Technologies

Pour être parfaitement libre dans la manière dont je structure mes
documents, il était très important que j'utilise un outil libre,
extensible et que je puisse facilement maitriser. [L'itération
précédente](https://web.archive.org/web/20211021123408/https://xvw.github.io/)
de mon site personnel approchait cette idée. J'avais construit une
collection de petits logiciels (en [OCaml](https://ocaml.org),
évidemment) me permettant de _structurer de la données_ et,
potentiellement, de générer des pages. N'étant pas emballé à l'idée de
créer un _moteur de gabarits_, je m'étais tourné vers
[Hakyll](https://jaspervdj.be/hakyll/), un excellent **générateur, de
générateurs de sites statiques**, écrit en
[Haskell](https://www.haskell.org/).  Cependant, le mélange
OCaml/Haskell rendait la maintenance de l'application et j'ai décidé,
en 2022, de repartir de zéro.

Le code source du générateur, et le contenu _brut_ se trouvent sur le
dépôt Github [xvw/capsule](https://github.com/xvw/capsule) et le
résultat du site généré se trouve sur le dépôt Github
[xvw/xvw.github.io](https://github.com/xvw/xvw.github.io).

#### Génération statique: YOCaml

[YOCaml](https://github.com/xhtmlboi/yocaml) a été conçu par mon ami
[Antoine](https://xhtmlboi.github.io/) pour donner un exemple
d'utilisation de la bibliothèque
[Preface](https://github.com/xvw/preface/), sur laquelle j'avais, avec
[Didier](http://www.fungus.fr/) et [Pierre](https://github.com/gr-im),
travaillé (depuis, comme YOCaml a été utilisé, contrairement à
Preface, la version 2 du logiciel ne l'utilise plus, _snif_). Comme
Hakyll, YOCaml est un générateur très versatile, qui laisse beaucoup
de liberté sur les documents à construire. On peut le voir comme un
tout petit _framework_ pour construire des _build-systems_
minimalistes. Son fonctionnement est, dans les grandes lignes, décrit
[dans un article](https://xhtmlboi.github.io/articles/yocaml.html) du
créateur, et, j'ai eu l'honneur de [le
présenter](https://www.irill.org/videos/OUPS/2023-01/xavier-van-de-woestyne.html)
au [OCaml _usergroup_ Parisien](https://oups.frama.io/).

Le binaire principale est orchestré via un logiciel en ligne de commandes,
implémenté grâce à la très riche bibliothèque
[Cmdliner](https://ocaml.org/p/cmdliner/latest).

L'utilisation de YOCaml, dans un
contexte un peu moins _orthodoxe_ que les exemples présentés, permet
d'utililiser mon site comme incubateur et de débroussailler des améliorations
potentielles pour la prochaine version de la bibliothèque (mais aussi de trouver
des
[bogues](https://github.com/xhtmlboi/yocaml/pull/36/commits/231b59a0d4a435722d2d10aea64d7a9f2b667371)).

##### Greffons utilisés

YOCaml est un _framework_ qui vient avec plusieurs greffons (des moteurs de
gabarits, des description de langages de _markups_ etc.) me permettant de
construire une véritable application web, avec beaucoup de contrôle sur la
manière dont les pages statiques sont produites. En général, un _greffon_ est
une sur-couche à une bibliothèque OCaml existante, servant à faire la glue entre
cette dernière et YOCaml. Pour ce site, j'utilise ces différents _greffons_ :

- [Yocaml_eio](https://ocaml.org/p/yocaml_eio/latest) : comme YOCaml
  est très versatile, il peut générer un site depuis et vers un
  système de fichier Unix (via la bibliothèque
  [Eio](https://github.com/ocaml-multicore/eio)) (mais aussi dans un
  [répertoire Git](https://ocaml.org/p/yocaml_git/latest) permettant
  au site généré d'être servi par un
  [MirageOS](https://github.com/robur-coop/unipi)). Je l'utilise en
  développement (ce qui me permet d'avoir un serveur de développement)
  mais aussi en déployement.
- [Yocaml_yaml](https://ocaml.org/p/yocaml_yaml/latest) : qui repose sur la
  bibliothèque [yaml](https://ocaml.org/p/yaml/latest) pour décrire les
  métadonnées des articles avec le langage de description
  [Yaml](https://fr.wikipedia.org/wiki/YAML). Le Yaml est assez controversé mais
  pour décrire des petites structures de données servant à donner du contexte à
  des articles, je le trouve largement suffisant.
- [Yocaml_toml](https://ocaml.org/p/yocaml_toml/latest) : qui repose
  sur la bibliothèque [otoml](https://ocaml.org/p/otoml/latest) pour
  décrire la configuration du site
- [Yocaml_jingoo](https://ocaml.org/p/yocaml_jingoo/latest) : qui repose sur la
  bibliothèque [jingoo](https://ocaml.org/p/yocaml_jingoo/latest), un moteur de
  gabarits conceptuellement très proche de
  [Jinja](https://github.com/pallets/jinja/) et qui est, de mon point de vue,
  incroyablement versatile.
- [Yocaml_syndication](https://ocaml.org/p/yocaml_syndication/latest) :
  me servant à décrire le flux Atom du site. Historiquement développé
  développé par l'équipe [Psi-Prod](https://github.com/Psi-Prod), qui
  réalise beaucoup de projets en rapport avec MirageOS, Gemini et
  YOCaml, [la version
  2](https://github.com/xhtmlboi/yocaml/blob/main/CHANGES.md#v200-2024-10-04-nantes-france)
  l'a complètement réimplémenté
- [Yocaml_cmarkit](https://ocaml.org/p/yocaml_cmarkit/latest) : pour
  la transformation de
  [Markdown](https://fr.wikipedia.org/wiki/Markdown) à HTML.
- [Hilite](https://github.com/patricoferris/hilite) pour la coloration syntaxique.


#### Infrastructure

L'avantage d'un site généré statiquement est qu'il est **incroyablement facile**
à déployer ! N'étant pas un très bon _devOps_, j'ai décidé d'utiliser [Github
Pages](https://pages.github.com/) comme serveur de fichiers. J'utilise une
[Github
Action](https://github.com/xvw/capsule/blob/main/.github/workflows/pfioooouuuu.yml)
(dont le nom est un peu nul) pour déployer une nouvelle version à chaque
nouvelle version de la branche
[_main_](https://github.com/xvw/capsule/tree/main).

#### Client et technologies _front-end_

Le site web est assez sobre concernant les technologies _front-end_ mise en
œuvre, essentiellement parce que je ne suis pas très _aux faits_ des nouvelles
technologies web.

##### CSS et intégration

Concernant le CSS, **je n'utilise aucun framework**. La feuille de style a été
conçue à la main (et très maladroitement). Mon expérience avec
[Tailwind](https://tailwindcss.com/) a été très laborieuse donc j'ai décidé de
tout écrire _from-scratch_. Actuellement, je suis satisfait de _bien comprendre_
mes feuilles de styles, cependant, comme évoqué dans ma [rétrospective
2023](/journal/2023-12-29_18-23-07.html), je devrais réecrire toute la feuille
pour construire un
[_design-system_](https://en.wikipedia.org/wiki/Design_system) dédié à mon site
web pour éviter les répétitions (actuellement, les règles ont été écrites à la
nécéssité).

Je profite aussi de ce site web pour en apprendre un peu plus sur l'intégration,
le HTML et le CSS. Par exemple, après des années sans m'y être intéressé, j'ai
_enfin_ utilisé des grilles, via le [gabarit de
grilles](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_grid_layout) qui,
logiquement, pour décrire des grilles, est largement plus confortable que
[Flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_flexible_box_layout/Basic_concepts_of_flexbox).


#### Conclusion sur la pile technologique

Même s'il reste des points d'améliorations, un des éléments qui me semblait
essentiel dans la maintenance d'un site personnel était le plaisir que j'avais à
le faire évoluer. L'utilisation de [OCaml](https://ocaml.org) qui est, pour
concrétiser des projets, mon langage favori, à presque toutes les couches du
site web me donne, **en permanence**, envie de l'améliorer ! De plus,
l'utilisation de bibliothèques expérimentales, développées par des
partenaires/amis/collègues, me permet de dresser des retours d'utilisations
pertinents et potentiellement de faire remonter des bogues.

Donc même s'il est probable que dans les mois à venir, j'apporte certains
changements, je resterai probablement sur cette base, qui m'amuse et me permet
d'implémenter à peu près ce dont j'ai envie.

### Développement et production de contenu

En plus de la _génération concrète_ du site, j'utilise des
bibliothèques et des logiciels pour faciliter le développement de
l'application et la production de contenu. Le code source et les
différentes pages sont écrites avec l'éditeur
[Emacs](https://www.gnu.org/software/emacs/), que j'utilise depuis
près d'une quinzaine d'années.

#### Développement

Comme le générateur du site est un projet OCaml, j'utilise un ensemble d'outils
relatifs au développement de projets OCaml :

- [OPAM](https://opam.ocaml.org/) : le gestionnaire de paquet de OCaml.
- [Dune](https://dune.build/) : le _build-system_ (presque standard) de OCaml.
- [Merlin](https://ocaml.github.io/merlin/), via Doom-Emacs comme support IDE.
- [OCamlformat](https://github.com/ocaml-ppx/ocamlformat) : comme formatteur de
  code.
- [Utop](https://github.com/ocaml-community/utop) : comme
  [REPL](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
  (qui se marie très bien avec `Dune`).
- [ocp-indent](https://github.com/OCamlPro/ocp-indent) : comme outil
  d'indentation, qui compose très bien avec `OCamlformat`.
- [Odoc](https://ocaml.github.io/odoc/) : comme générateur de documentation.
- [mdx](https://github.com/realworldocaml/mdx) : pour écrire des _tests_ dans un
  style _literate_ (dans de la documentation ou des documents Markown),

#### Éléments visuels

Les différents éléments visuels du site sont réalisés avec ces trois outils :

- [Krita](https://krita.org/) : comme logiciel de peinture numérique. Quand j'ai
  pris la décision de supprimer ma partition Windows pour utiliser exclusivement
  GNU/Linux, j'ai dû arrêter d'utiliser [Adobe
  Photoshop](https://www.adobe.com/products/photoshop.html), je l'ai remplacé
  par `Krita` pour le dessin numérique. Aujourd'hui, j'en suis pleinement
  satisfait (bien que je ne sois absolument plus au courant des nouveautés de
  Photoshop).
  
- [Inkscape](https://www.adobe.com/products/photoshop.html) : comme logiciel de
  dessin vectoriel. Je n'ai pas encore retrouvé l'agilité que j'avais avec
  [Adobe Illustrator](https://www.adobe.com/products/photoshop.html) mais je
  compte bien continuer à utiliser à me former à `Inkscape` qui semble être
  capable de largement rivaliser avec son concurrent non-libre.
  
- [D2](https://d2lang.com/) : comme outil pour décrire des diagrammes. C'est un
  langage déclaratif permettant de décrire plusieurs types de schémas.
  Historiquement, j'utilisais [Dot](https://graphviz.org/doc/info/lang.html), de
  la suite [Graphviz](https://graphviz.org/) (que je serai peut-être amené à
  réutiliser), mais je trouve `D2` plus facile à utiliser et à personnaliser.
  J'utilise le thème [`301`](https://d2lang.com/tour/themes/) et le moteur
  d'organisation [Elk](https://d2lang.com/tour/elk).
  
Dans un futur proche, j'utiliserai [Penpot](https://penpot.app/) pour
construire le _design-system_.
  
L'ensemble des illustrations, _pixels_ ou _vectorielles_ sont réalisées avec une
bien vieille (2008) tablettes graphique **Bamboo** de chez
[Wacom](https://www.wacom.com/) qui, malgré son âge avancé... fonctionne
toujours !

##### Typographies

Le site web utilise trois polices de caractères différentes : 

- [Inria Serif](https://black-foundry.com/case-studies/inria-identity-font/) :
  comme police principale pour les paragraphes. Une police avec serifs que je
  trouve très agréable à lire.
  
- [Libre Franklin](https://github.com/impallari/Libre-Franklin) : comme police
  principale pour les titres. Une police sans serif que je trouve lisible (et
  dont les titres en gras me font penser à la typographie de [Burger
  King](https://www.bk.com/)).

- [Fira Code](https://github.com/tonsky/FiraCode) : comme police
  principale pour les blocs de code. Une police monospace très
  populaire et très lisible (pour du code).
  
J'ai longuement hésité à utiliser la police [Inter](https://rsms.me/inter/)
comme police sans serif, que je trouve aussi très jolie et lisible. Mais, même
si mon avis en tant que _designer_ a peu de valeur, je suis assez satisfait de
la composition de ces trois polices.

##### Iconographies

Dans la première version du site (avec YOCaml), j'évitais
l'utilisation d'icones, parce que je n'y connais rien en
SVG. Cependant, dans une volonté de **modernité sauvage**, j'ai
décidé, d'enfin, en utiliser !

- [Creative Commons](https://creativecommons.org/mission/downloads/),
  pour les icones concernant les attributions de la [Creative
  Commons](https://creativecommons.org/)
- [Simple Icons](https://simpleicons.org/), pour les autres icones.

### Conclusion

C'était, dans les grandes lignes, les socles sur lesquels repose ce site web. Je
n'ai malheureusement pas cité toutes les dépendances transitives des projets que
j'utilise mais comme j'utilise presque essentiellement des logiciels libres,
elles sont découvrables par le biais des liens que j'ai référencés.

De mon point de vue, la pile technologique basée sur YOCaml et Nightmare est
très amusante à utiliser et me motive à faire évoluer mon site. Ce qui me permet
de conclure sur, selon moi, l'importance de contrôler son espace personnel sur
le net. En effet, il m'arrive souvent de voir des articles publiés sur
[Medium](https://medium.com/) ou encore [Dev.to](https://dev.to/). Même si je
comprend parfaitement que le gros avantage de ces médiums de publication est la
communauté (et donc la promotion de ses rédactions), je trouve que garder le
contrôle de son contenu, d'être capable de construire une expérience de lecture
adapté à ses articles et d'offrir des rédactions sans publicités (le fameux
**Pardon the Interruption** que je trouve infernal) est un **gain énorme**. De
plus, maintenir son espace sur le web, comme un [jardin
numérique](https://maggieappleton.com/garden-history) est un exercice très
amusant, formateur et qui, selon moi, stimule sa créativité ! Et de manière un
peu technocratique, ça permet d'expérimenter des langages plus compliqués à
proposer professionnellement !

Pour ma part, même si je pense qu'au vue de mes choix technologiques, je suis
assez indépendant concernant l'évolution de mon site et du code de son
générateur, je trouve que je dépend encore trop fortemment de
[Github](https://github.com) et qu'un jour, je pourrai passer à une version
auto-hébergée, le fait que je contrôle mon contenu, qu'il est facilement
_backupable_ ne m'inquiète pas quand je voudrai migrer. Et oui, une site généré
statiquement, c'est très facile à déployer !

Si vous avez envie de vous lancer dans la construction de votre espace sur le
web, [l'anneau de la communauté Merveilles](https://webring.xxiivv.com/) est une
collection de _jardins numériques_ pouvant être une très bonne source
d'inspiration et je suis, évidemment, ouvert à tout échange à ce propos, via les
différents canaux de contact qu'il est possible de trouver sur ce site !
