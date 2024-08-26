---
title: Sur le choix d'OCaml
creation_date: 2024-08-25
description:
  Une explication détaillée de pourquoi j'ai fais le choix de OCaml
  pour langage de programmation "par défaut" pour chaque projet.
synopsis:
  J'ai commencé à utiliser régulièrement le langage [OCaml](https://ocaml.org) vers 2012, et depuis, 
  mon intérêt et mon engouement pour ce langage n'ont cessé de croître. 
  Il est devenu mon choix de prédilection pour presque tous mes projets personnels, 
  influençant également mes choix professionnels.  
  
  Depuis 2014, je participe activement aux conférences grand public dédiées à la 
  programmation et à la construction de logiciels, où j'exprime souvent mon 
  enthousiasme pour OCaml de manière parfois excessive (mais toujours passionnée). 
  Cela m'a valu, de manière amicale, le surnom _d'évangéliste d'OCaml_, une appellation qui, 
  je l'avoue, me flatte énormément.  

  Convaincu que mon intérêt pour OCaml est justifié, je prends souvent plaisir à énumérer 
  les nombreux avantages de cette technologie. J'ai donc décidé de coucher par écrit les
  raisons pour lesquelles je considère OCaml comme un excellent choix pour divers types 
  de projets. Cette page me permettra de partager facilement mes arguments et d'expliquer 
  pourquoi OCaml mérite attention et intérêt.  

  De plus, je ne suis pas seul à penser cela. Malgré l'idée reçue que OCaml ne serait pas 
  un choix pragmatique pour l'industrie, de grandes entreprises telles que 
  [Meta](https://engineering.fb.com/?s=ocaml), 
  [Microsoft](https://www.microsoft.com/en-us/research/project/slam/?from=https://research.microsoft.com/en-us/projects/slam/&type=exact),
  [Ahref](https://tech.ahrefs.com/tagged/ocaml), 
  [Tarides](https://tarides.com),
  [OCamlPro](https://ocamlpro.com/),
  [Bloomberg](https://www.bloomberg.com/company?s=ocaml),
  [Docker](https://github.com/moby/vpnkit), [Janestreet](https://www.janestreet.com/technology/),
  [Citrix](https://xapi-project.github.io/), [Tezos](https://tezos.com), 
  et [bien d'autres](https://ocaml.org/industrial-users) l'utilisent activement.
toc: true
tags:
  - programmation
  - ocaml
  - opinion
breadcrumb:
  - name: Programmation
    href: /programming.html
  - name: Opinions
    href: /programming.html#index-opinion
mastodon_thread:
  instance: merveilles.town
  user: xvw
  id: "113021972448640275"
---

Dans ce _billet d'opinion_, je vais essayer de présenter brièvement ma rencontre
avec le langage, et d'énumérer ses avantages — répartis en plusieurs rubriques
portant sur _le langage lui-même_, son écosystème et sa communauté. Je tâcherai
également de _débunker_ certains mythes (ou idées reçues) populaires sur
Internet. Par souci de transparence, il est important de préciser qu'à l'heure
où j'écris ces lignes, mon [activité professionnelle]((https://tarides.com))
consiste **à travailler pour et sur l'écosystème OCaml**. Cependant, les
lecteurs qui me suivent depuis plusieurs années pourront témoigner que je
faisais la promotion du langage bien avant d'être rémunéré pour travailler sur
l'écosystème OCaml, parfois de manière immodérée.


## Avant-propos

Premièrement, cet article expliquera pourquoi je trouve **personnellement**
qu'OCaml est un choix pertinent dans de nombreux contextes. Mon but n'est pas
particulièrement de vous convaincre — même si cela serait un _effet de bord_
tout à fait bénéfique — et il est fort probable que beaucoup des arguments que
je présenterai s'appliquent aussi à d'autres langages !

Ensuite, très souvent, quand je propose OCaml à des gens qui souhaitent
découvrir de nouveaux langages ou encore des solutions écrites en OCaml, on me
fait gentiment remarquer que _je fais toujours la promotion d'OCaml_. Il est
amusant de constater que lorsque les propositions concernent des langages
adoptés __par défaut_ comme JavaScript ou des langages plus récents comme
[Rust](https://www.rust-lang.org/) ou [Go](https://go.dev/), cela suscite
souvent moins de réactions. Probablement parce que l'on pense _implicitement_
que la proposition d'un langage _moins connu_ tend vers l'irrationalité et les
préférences personnelles. De mon point de vue, **proposer OCaml est, dans
beaucoup de cas où le contrôle mémoire fin n'est pas nécessaire, aussi pertinent
que proposer Rust** (et probablement plus).

Pour terminer cet avant-propos, beaucoup de personnes ont été confrontées à
OCaml (ou [Caml Light](https://caml.inria.fr/caml-light/release.fr.html)) en
licence ou en classes préparatoires, l'utilisant dans des contextes souvent très
éloignés de l'industrie. Pour ma part, j'ai commencé à m'intéresser à OCaml bien
avant, grâce au [Site du Zéro](http://sdz.tdct.org/), où une petite communauté
de programmeurs férus de fonctionnel faisait la promotion de langages moins
_mainstream_ comme [OCaml](https://ocaml.org), [Erlang](https://www.erlang.org/)
et [Haskell](https://www.haskell.org/). Mon interaction avec OCaml à
l'université n'était **que du bonus**.


### Autres ressources

Je ne suis pas le premier à avoir documenté les raisons qui poussent à choisir
OCaml. Il existe de nombreuses alternatives qui, selon moi, valent aussi le coup
d'être consultées et qui démontrent que les utilisateurs d'OCaml en sont
généralement très satisfaits, les motivant à communiquer sur _comment et
pourquoi_ nous avons fait le choix du langage comme technologie principale :

- ["**Why OCaml?**"](https://dev.realworldocaml.org/prologue.html#why-ocaml),
  prologue du livre [Real World OCaml](https://dev.realworldocaml.org/toc.html),
  qui présente des avantages factuels à l'utilisation d'OCaml (et dont
  l'introduction propose une frise chronologique). Même si le livre est
  excellent sur de nombreux aspects, j'ai pris l'habitude de ne pas le
  recommander car je le trouve très biaisé dans son usage, proposant
  l'utilisation de bibliothèques, par défaut, qui ne font pas spécialement
  l'unanimité dans la communauté.

- ["**Better Programming Through
  OCaml**"](https://cs3110.github.io/textbook/chapters/intro/intro.html),
  prologue du livre (accompagné de vidéos) [OCaml Programming: Correct +
  Efficient + Beautiful](https://cs3110.github.io/textbook/cover.html) qui
  présente essentiellement en quoi l'apprentissage d'OCaml peut améliorer les
  compétences d'un développeur dans d'autres technologies plus populaires. Le
  livre est assez récent et c'est celui que **j'ai pris l'habitude de
  recommander comme ressource de base** pour appréhender OCaml.

- [**Conférence "Why OCaml?"**](https://www.youtube.com/watch?v=v1CmGbOGb2I),
  une conférence de [Yaron Minsky](https://twitter.com/yminsky), le _CTO_ de
  l'entreprise [Jane Street](https://blog.janestreet.com/) — un utilisateur
  industriel d'OCaml faisant partie des _leaders_ mondiaux de la finance. Yaron
  est aussi l'un des auteurs de _Real World OCaml_ et la personne à qui l'on
  doit la très populaire phrase, dans le monde des langages de programmation à
  vérification statique des types, "_Make illegal states unrepresentable_". La
  conférence donne beaucoup d'informations sur les motivations du choix d'OCaml
  chez Jane Street.

- ["**OCaml for Fun & Profit: An Experience
  Report**"](https://www.youtube.com/watch?v=TxuLrsQZprE), présentée par [Tim
  McGilchrist](https://lambdafoo.com/) durant la conférence [Yow
  2023](https://yowcon.com/melbourne-2023), qui, après une présentation riche du
  langage, expose certains cas d'usages très concrets de l'utilisation d'OCaml
  en production, _avec fun et profit_.

- ["**Replacing Python for
  0Install**"](https://roscidus.com/blog/blog/categories/0install/) par [Thomas
  Leonard](https://roscidus.com/blog/). Cette série d'articles est, de mon point
  de vue, **incroyablement intéressante**. En effet, l'auteur de
  [0Install](https://0install.net/), un système d'installation de logiciels
  décentralisé et multiplateforme (une alternative très légèrement plus ancienne
  que [Nix](https://nixos.org/)), cherche un autre langage que
  [Python](https://www.python.org/) pour l'implémentation d'une nouvelle version
  (le remplacement de Python est, lui aussi,
  [documenté](https://roscidus.com/blog/blog/2013/06/09/choosing-a-python-replacement-for-0install/#why-replace-python))
  et procède très consciencieusement à la comparaison méthodique de plusieurs
  candidats : [ATS](https://www.cs.bu.edu/~hwxi/atslangweb/),
  [C#](https://learn.microsoft.com/en-us/dotnet/csharp/),
  [Haskell](https://www.haskell.org/), [Go](https://go.dev),
  [Rust](https://www.rust-lang.org/) et [OCaml](https://ocaml.org) avec Python.
  Plusieurs années après, je suis toujours émerveillé par la rigueur et la
  nuance de cette série que je **recommande très fortement**.

Il existe probablement d'autres ressources et témoignages, notamment sur le
[site officiel](https://ocaml.org/) qui propose des témoignages
[industriels](https://ocaml.org/industrial-users) et
[académiques](https://ocaml.org/academic-users). De même qu'il existe des
articles témoignant du dépit que peut provoquer OCaml. Je suis conscient
qu'OCaml n'est pas parfait — je pense qu'il n'existe pas de technologie
parfaite. Il est probable que j'évoque (implicitement ou explicitement) certains
de ces articles dans la section dédiée aux _mythes_ et en conclusion, où je
tâcherai d'expliquer dans quels contextes je ne trouve pas l'utilisation d'OCaml
pertinente.


## OCaml en tant que langage

Avant de rentrer dans les **fonctionnalités** offertes par le langage,
j'aimerais commencer par un point qui, selon moi, est essentiel. OCaml est un
langage de programmation issu [de la
recherche](https://ocaml.org/about#history), utilisé par des [utilisateurs
industriels](https://ocaml.org/industrial-users). Cette dualité est importante
car elle offre au langage deux choses :

- Une guidance sur les fonctionnalités _désirables_ comme objet de langage
  intéressant, supportées par une recherche poussée. Par exemple, à ma
  connaissance, OCaml est le premier langage _mainstream_ proposant un support
  natif des [effets définis par
  l'utilisateur](https://v2.ocaml.org/manual/effects.html) (_user-defined
  effects_), qui est le fruit d'une recherche avancée, illustrée par beaucoup de
  [publications](https://arxiv.org/search/cs?searchtype=author&query=Sivaramakrishnan,+K).
  
- Une guidance sur les fonctionnalités _désirables_ comme outil pour
  l'industrialisation, aussi supportées par une recherche poussée et motivées
  par des cas d'usages. Par exemple, depuis peu, [Jane
  Street](https://blog.janestreet.com/), un des utilisateurs industriels très
  importants de OCaml, a proposé l'intégration de _sessions affines_ permettant
  un [contrôle linéaire des
  ressources](https://blog.janestreet.com/search/?query=oxidizing) (un peu _à la
  Rust_).

Cet entrelacement entre des motivations industrielles et académiques permet à
OCaml de proposer une collection de fonctionnalités solides, utiles et
clairement définies. En d'autres termes, OCaml est un langage **vivant** et
depuis que je m'en sers, j'ai eu l'occasion d'être témoin de nombreuses
évolutions et ajouts très — de mon point de vue — désirables et qui _débunkent_
une assertion très courante en défaveur de OCaml : **le langage ne sert que pour
de la théorie ou pour l'implémentation de [Coq/Rocq](https://coq.inria.fr/)**.
Même si, historiquement, c'était vrai, les motivations apportées par les
utilisateurs industriels justifient le titre "_An industrial-strength functional
programming language with an emphasis on expressiveness and safety_". La
_Keynote_ d'ouverture du [OCaml Workshop
2021](https://ocaml.org/workshops/ocaml-workshop-2021) de [Xavier
Leroy](https://xavierleroy.org/), "[_25 Years Of
OCaml_](https://watch.ocaml.org/w/tU8wR9EcAcyFHHVcX4GS46)" présente une frise
chronologique exhaustive de la conception continue de OCaml, montrant les
différentes phases d'évolutions par lesquelles est passé le langage.

Dans les grandes lignes, OCaml est un langage de programmation de la famille
[ML](https://en.wikipedia.org/wiki/ML_(programming_language)), **haut-niveau**
(ici, à lire comme étant doté d'un
[glâneur de cellules](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science))),
**statiquement typé** (dont les types sont vérifiés à la compilation et ne font
pas de conversions implicites), avec de la **synthèse de types** (aussi appelée
[_inférence de types_](https://en.wikipedia.org/wiki/Type_inference), laissant
la main au compilateur, dans une majorité de cas, de déduire le type d'une
expression) permettant de programmer dans un style
[**fonctionnel**](https://en.wikipedia.org/wiki/Functional_programming) et
[**impératif**](https://en.wikipedia.org/wiki/Imperative_programming). Il
dispose aussi d'un modèle de **programmation par objets** et d'un **langage de
modules** très riche. OCaml dispose de deux schémas de compilation : `ocamlc`,
qui permet de compiler vers un _bytecode_ interprétable par une **machine
virtuelle** (portable et efficace), et `ocamlopt`, qui compile vers du **code
machine** (exécutable dans une grande [diversité
d'architectures](https://github.com/ocaml/ocaml?tab=readme-ov-file#overview)).
De plus, OCaml permet la **conversion de son _bytecode_ en JavaScript** au moyen
de [Js_of_ocaml](https://ocsigen.org/js_of_ocaml/latest/manual/overview),
permettant une interopérabilité _très rapide_ avec l'écosystème OCaml (je
l'utilise d'ailleurs _massivement_ sur ce site web). La [même approche est
utilisée pour produire du
WebAssembly](https://github.com/ocaml-wasm/wasm_of_ocaml). Pour une
interopérabilité plus poussée avec l'écosystème JavaScript,
[Melange](https://melange.re/) utilise une approche sensiblement différente de
Js_of_ocaml pour produire du JavaScript robuste.

OCaml est un langage **très versatile** et maintenant, je vais tâcher de
présenter les fonctionnalités et apports du langage qui en font — _pour moi_ —
un outil idéal pour la construction de projets personnels et professionnels, en
commençant par un petit détour sur le typage statique.


### Sur la vérification statique des types

Quand je préparais, avec [Bruno](https://twitter.com/bibear), l'épisode [If This
Then Dev](https://www.ifttd.io/liste-des-episodes) dédié à OCaml, qui, au final,
a été
[enregistré](https://www.ifttd.io/episodes/le-langage-de-tous-les-langages) avec
[Didier](https://github.com/d-plaindoux), il m'a posé une question que j'ai
trouvée surprenante :

> Est-ce que ça vaut vraiment la peine de s'embêter avec des types quand on fait
> un _projet perso_, rapidement ? Même si, pour de la _prod_, je vois
> parfaitement l'intérêt, pour un _projet personnel_, ça me semble être une
> perte de temps.

Je pense qu'il y a deux axes de réponse. Le premier, et le plus évident, c'est
que, dans l'absolu, **je ne vois pas pourquoi un projet personnel devrait être
moins hygiénique qu'un projet professionnel**. Quand j'écris un logiciel _pour
moi_, je peux effectivement me contenter de ne pas le faire se heurter aux
_corner cases_ de mon implémentation, certes. Mais ce n'est probablement pas ce
que j'ai envie de faire. Donc, si un langage et son compilateur me permettent de
tendre des filets de sécurité pour me forcer à prendre en compte tous les cas
d'un logiciel, _je prends_ — de la même manière que rédiger des _tests
unitaires_ **facilite mon développement** et je ne les vois pas comme une
contrainte.

Mais au-delà des considérations sur l'hygiène que l'on souhaite apporter à un
projet personnel, je pense que, généralement, la mauvaise presse de la
vérification statique des types est souvent la conséquence d'une mauvaise
expérience. En effet, dans des langages comme C, ou encore Java, les types
**sont essentiellement une contrainte** qu'il est possible de dérouter
_facilement_. Dans des langages qui portent un intérêt fort au typage, comme
[OCaml](https://ocaml.org), [Haskell](https://haskell.org),
[F#](https://fsharp.org/), [Scala](https://www.scala-lang.org/) ou encore
[Rust](https://www.rust-lang.org), **les types servent de garde-fous**, mais, et
selon moi, c'est le point le plus important, **les types servent aussi d'outil
de _design_ expressif**. En les utilisant, on gagne en sécurité, mais on dispose
également d'un outil de description de données incroyablement riche, versatile
et concis.

D'après mon expérience, même s'il est courant de passer d'un langage _mal-typé_
(désolé, la tentation est trop forte) à un langage _dynamiquement typé_ — j'ai,
par exemple, expérimenté le passage de Java à Ruby avec beaucoup de joie —
passer d'un langage avec un système de type riche, comme OCaml ou Haskell, rend
le passage à un langage _dynamiquement typé_ largement plus compliqué. À l'heure
actuelle, **je ne connais personne ayant expérimenté sérieusement des langages
comme OCaml ou Haskell, qui soit ravi de revenir à des langages aux systèmes de
types moins sophistiqués** (même si la motivation d'un projet intéressant peut
justifier la régression technologique).

Ce n'est d'ailleurs **pas une observation personnelle** ; la vérification
statique des types fait partie intégrante _du grand débat sur l'évolution des
langages_. Des langages historiques muent (ou tentent de muer) pour intégrer
plus de vérification des types. Par exemple, [Erlang](https://www.erlang.org/),
dès les années 80 (avant la libération du code source de son compilateur), avait
expérimenté [l'intégration d'un système de
type](https://homepages.inf.ed.ac.uk/wadler/papers/erlang/erlang.pdf). Et Java
améliore, de version en version, les fonctionnalités destinées à améliorer la
vérification statique des types, en intégrant, par exemple, des [familles
scellées](https://openjdk.org/jeps/409). Beaucoup de langages expérimentent
l'intégration de systèmes de types : [Ruby avec
RBS](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/) (ou
encore [Crystal](https://crystal-lang.org/), un langage statiquement typé,
drastiquement inspiré par Ruby), [Python et Mypy](https://mypy-lang.org/),
[Elixir](https://www.irif.fr/_media/users/gduboc/elixir-types.pdf), qui revient
sur les tentatives passées d'Erlang en proposant une approche graduelle viable,
et évidemment, [TypeScript](https://www.typescriptlang.org/) qui est devenu
**largement adopté** par la communauté des développeurs et développeuses
JavaScript. Même si toutes ces initiatives sont très motivantes, et vont
clairement, selon moi, dans la bonne direction, actuellement, ces propositions
_ajoutent des garde-fous_, mais ne servent pas encore d'outils de _design_
expressifs.

Dans l'utilisation de systèmes de types de plus en plus riches, **la Maison
Blanche** a récemment publié un
[communiqué](https://www.whitehouse.gov/wp-content/uploads/2024/02/Final-ONCD-Technical-Report.pdf)
qui insiste sur l'importance de la _memory safety_ dans la conception de
programmes et ... _plébiscite_ l'utilisation du langage
[Rust](https://www.rust-lang.org) (historiquement [écrit en
OCaml](https://users.rust-lang.org/t/understanding-how-the-rust-compiler-is-built/87237/7),
avant d'être _auto-hébergé_) au détriment de C++, montrant très explicitement
que même les instances officielles (et souvent présentées comme poussiéreuses)
soulignent l'importance des systèmes de types riches — d'ailleurs, la [réponse
formulée par
Tarides](https://tarides.com/blog/2024-03-07-a-time-for-change-our-response-to-the-white-house-cybersecurity-press-release/),
l'entreprise où je travaille à l'heure où je rédige cet article, est aussi
porteuse d'arguments intéressants en faveur de l'utilisation d'OCaml pour la
construction de systèmes critiques.

Pour conclure, la vérification statique des types, c'est vraiment bien et
recommandé, et ça vaut le coup de regarder des langages disposant de systèmes de
types sophistiqués (comme OCaml) et pourquoi pas, d'aller encore plus loin, en
s'intéressant de plus en plus aux méthodes formelles.


### Fonctionnalités du _langage_

Même s'il est très tentant de faire un gigantesque tutoriel sur OCaml,
l'objectif de cet article est de présenter, dans cette section, ce qui fait que
**pour moi**, OCaml est un choix **très pertinent** pour l'apprentissage et la
production. Les avantages seront donc présentés (et _défendus_), mais **ce n'est
pas un tutoriel**.


#### Un langage _multi-paradigmes_

De nos jours, parler de langages **multi-paradigmes** peut sembler peu sensé car
une très large partie des langages de programmation _plébiscités par
l'industrie_ sont déjà multi-paradigmes. Cependant, OCaml est un langage de
**programmation fonctionnelle**, permettant la **programmation impérative**, la
**programmation modulaire**, la **programmation par objets**, et depuis la
version `5.0.0` du langage, la **programmation multi-cœur**. Comme
[Haskell](https://www.haskell.org/) a _pignon sur rue_ quand on parle de
programmation fonctionnelle, il arrive souvent que l'on considère que proposer
des mécanismes impératifs, dans un langage, est une mauvaise idée, surtout si
l'on est convaincu des bienfaits du style fonctionnel. De mon point de vue, il
existe plusieurs raisons parfaitement légitimes de faire de la programmation
impérative, si le langage le permet :

- **La lisibilité d'une implémentation.** En effet, il arrive parfois que pour
  éviter la mutabilité, il faille ajouter de la plomberie additionnelle (par
  exemple, une [monade State](https://wiki.haskell.org/State_Monad)) rendant la
  lecture et la compréhension d'un programme plus laborieuse.
  
- **La performance.** L'ajout de plomberie peut engendrer des coûts, rendant
  l'exécution d'implémentations plus laborieuse.
  
- **Le confort à l'usage.** Il y a quelques années, [Arthur
  Guillon](https://twitter.com/rtguillon) m'avait cérémonieusement dit que
  "_OCaml était un lambda-calcul permettant trivialement d'exécuter des
  effets_", ce qui le rendait très efficace pour, par exemple, faciliter le
  débogage en permettant facilement d'imprimer des messages sur la sortie
  standard. Même si je reconnais que ce n'est probablement pas la _meilleure
  manière_ de produire de la journalisation, cela apporte indéniablement un
  confort d'utilisation, permettant le prototypage rapide.
  
De manière générale, la nature à la fois impérative et fonctionnelle d'OCaml
permet de tirer parti des différents avantages des deux paradigmes dans des
situations différentes et, évidemment, de les coupler. Par exemple, en cachant
la nature impérative d'un module sous une API fonctionnelle.

##### Syntaxe _à la ML_

Bien que la syntaxe soit souvent considérée comme un détail, les langages de [la
famille ML](https://en.wikipedia.org/wiki/ML_(programming_language)) disposent
d'une syntaxe concise, expressive et lisible. Même si *cette famille de syntaxe*
peut être déroutante quand on vient de syntaxe plus conventionnelle, _inspirée
de C_, on s'y fait assez rapidement et l'on peut très vite se rendre compte
qu'elle est très cohérente et relativement peu ambigüe. Cependant, si la syntaxe
de OCaml vous pose des soucis, n'hésitez pas à vous tourner vers
[ReasonML](https://reasonml.github.io/), une syntaxe alternative — avec des
accolades.

##### Étroitement lié à la recherche

OCaml est un langage issu de la recherche française, comme en témoigne
[l'histoire de Caml](https://caml.inria.fr/about/history.en.html),
essentiellement pour permettre l'implémentation de l'assistant de preuves
[Coq/Rocq](https://coq.inria.fr/). Cette provenance — et les motivations
initiales, implémenter Coq, mais aussi servir de langage de programmation
enseigné en classes préparatoires — induit une certaine dualité :

- Le socle des fonctionnalités n'a pas été pensé pour l'industrie. Cependant,
  cette assertion n'est plus du tout vraie, essentiellement parce que OCaml
  **est** devenu un langage utilisé industriellement. Même si, dans la genèse du
  langage, on trouvait plus d'outils pour construire un langage (permettant de
  faciliter l'enseignement du fonctionnement des compilateurs plus aisé) que de
  l'outillage pour _construire des applications dites
  "[entreprises](https://www.oracle.com/fr/java/technologies/java-ee-glance.html)"_,
  des projets issus de la communauté, motivés par des usages industriels
  enrichiront le langage et son écosystème, faisant du langage un outil
  générique, et adapté à l'industrie. Par exemple, la construction d'une
  _liaison_ avec la bibliothèque
  [Tk](https://en.wikipedia.org/wiki/Tk_(software)) motivera l'intégration, dans
  le langage, [d'arguments nommés](https://ocaml.org/manual/lablexamples.html),
  [d'arguments
  optionnels](https://ocaml.org/manual/lablexamples.html#s%3Aoptional-arguments),
  et de [variants polymorphes](https://ocaml.org/manual/polyvariant.html).
  
- L'ensemble des paradigmes et des fonctionnalités du langage sont **très
  mûrement réfléchis et théorisés**. En général, l'intégration d'une
  fonctionnalité (ou d'une collection de fonctionnalités) est le fruit d'un
  travail de recherche méticuleux, basé sur des fondements théoriques solides et
  soumis à la revue d'un grand nombre d'experts dans le domaine (souvent
  [reconnus](https://www.inria.fr/fr/avec-xavier-leroy-linformatique-confirme-sa-presence-au-college-de-france)
  par la communauté scientifique). Cette rigueur peut parfois ralentir
  l'intégration de nouvelles fonctionnalités, mais garantit généralement leur
  bon fonctionnement et leur stabilité théorique.
  
Cette rigueur théorique, engendrée par une proximité indéniable avec le monde de
la recherche, fait que les différents aspects de OCaml sont bien documentés,
illustrés par [un grand nombre de
publications](https://arxiv.org/search/?query=ocaml&searchtype=all&source=header)
et possèdent des **comportements prévisibles**. Ce qui fait que, de mon point de
vue, OCaml est un choix très judicieux pour comprendre, _en profondeur_, ces
différentes fonctionnalités. Par exemple, je pense que OCaml m'a permis de
**largement mieux comprendre** certains traits ou paradigmes de langages.

D'ailleurs, un très bon exemple démontrant comment un travail méticuleux et
rigoureux de recherche peut servir l'intégration d'un aspect de langage est
l'implémentation d'un [modèle
objet](https://ocaml.org/manual/objectexamples.html) dans OCaml. En effet, la
thèse de [Jérôme Vouillon](https://www.irif.fr/~vouillon/), _[Conception et
réalisation d'une extension du langage ML avec des
objets](https://www.irif.fr/~vouillon/publi/these.ps.gz)_ propose un modèle
objet novateur, qui se marie très bien à l'inférence de types en [séparant la
notion d'héritage et de
sous-typage](https://caml.inria.fr/pub/docs/oreilly-book/html/book-ora144.html)
— l'héritage étant une **notion syntaxique** et le sous-typage étant une
**notion sémantique** — utilisant du [polymorphisme de
rangée](https://en.wikipedia.org/wiki/Row_polymorphism) pour décrire des
relations de [sous-typage
structurelles](https://en.wikipedia.org/wiki/Structural_type_system), par
opposition au [sous-typage
nominal](https://en.wikipedia.org/wiki/Nominal_type_system), utilisé par Java,
C#, et une grande partie des langages de programmation OOP populaires. Le modèle
objet de OCaml se conforme parfaitement au principe
[SOLID](https://en.wikipedia.org/wiki/SOLID) sans [cérémonie
additionnelle](https://spring.io/projects/spring-boot).

#### Types algébriques

J'ai été assez expansif sur les raisons qui font que je trouve qu'un langage
soit doté d'une analyse statique des types. Cependant, dans mon expérience, je
trouve que pour qu'un langage statiquement typé soit réellement utilisable, la
présence de [types
algébriques](https://cs3110.github.io/textbook/chapters/data/algebraic_data_types.html)
est nécessaire :

- Des **types produits** : qui permettent de grouper des valeurs de types
  hétérogènes (donc de créer une **conjonction** de types hétérogènes). Ils sont
  généralement présents dans tous les langages _mainstream_ (les _objets_ par
  exemple, qui introduisent des concepts en plus, ou les couples et les
  enregistrements).
  
- Des **types sommes** : qui permettent de construire une **disjonction** de
  types de valeurs hétérogènes, des différents _cas_, indexés par des
  constructeurs. Même si on peut trouver des _cas particuliers_ de sommes dans
  les langages _mainstreams_, notamment les _booléens_ (qui sont une disjonction
  de deux cas : `true` et `false`, soit deux constructeurs sans paramètres), le
  support de ces dernières est souvent laborieux dans les langages populaires.
  Par exemple, Kotlin et Java (et _de facto_, C#) utilisent une construction,
  associée aux relations d'héritages, [le
  scellage](https://docs.oracle.com/en/java/javase/17/language/sealed-classes-and-interfaces.html).
  L'intégration [d'une syntaxe dédiée aux
  sommes](https://docs.scala-lang.org/scala3/reference/enums/adts.html) a aussi
  pris un peu de temps en Scala, qui, avant les dernières versions du langage,
  utilisait aussi des familles scellées, rendant l'expression de sommes assez
  verbeuses (et, de mon point de vue, difficile à raisonner).

- Des **types exponentiels** : qui permettent de décrire des fonctions qui
  permettent d'exprimer des types pour des fonctions d'ordre supérieur (que l'on
  peut passer en argument ou renvoyer).

Couplé avec de la [correspondance de
motifs](https://ocaml.org/manual/5.2/patterns.html) et du [polymorphisme
paramétrique](https://en.wikipedia.org/wiki/Parametric_polymorphism) (ou
_génériques_), un système de types algébriques est un outil formidablement
expressif pour décrire des structures de données, la machine à état d'un
programme, ou l'expression d'un [domaine
métier](https://pragprog.com/titles/swdddf/domain-modeling-made-functional/)
avec une cardinalité adaptée. Même s'il est, au 21ème siècle, courant d'avoir
des produits et des exponentiels, quand je suis amené à utiliser des langages
_très populaires_, je suis souvent frustré de l'absence de sommes, m'obligeant à
utiliser un encodage verbeux (et augmentant la cardinalité d'un domaine). C'est
très flagrant dans l'utilisation de [Go](https://go.dev/) et de
[TypeScript](https://www.typescriptlang.org/).

L'intérêt de cette triade est d'ailleurs, probablement, une des raisons (couplée
à un écosystème et une chaîne d'outillage très ergonomique) qui explique le
succès de [Rust](https://www.rust-lang.org/). En bref, si vous avez l'intention
de construire un nouveau langage de programmation, doté d'une vérification
statique des types, _par pitié_, n'hésitez surtout pas à intégrer des types
algébriques !

Pour terminer, il existe des pans du systèmes de types de OCaml que je n'ai pas
couverts, mais qui méritent probablement des articles dédiés. Par exemple, [les
types algébriques généralisés](https://ocaml.org/manual/gadts-tutorial.html) qui
permettent de décrire encore plus d'invariants.

#### Programmation modulaires et langage de modules

OCaml, par le biais de [Caml
Light](https://caml.inria.fr/pub/docs/manual-caml-light/), son ancêtre, figure
parmi les premiers langages à proposer un système de modules, à l'instar de
[Standard ML](https://smlfamily.github.io/), offrant ainsi **l'encapsulation et
l'abstraction** tout en permettant **la compilation séparée**, à la manière de
[Modula-2](https://en.wikipedia.org/wiki/Modula-2). Le langage de modules
d'OCaml constitue un **aspect fondamental** de ce langage, bien que sa
complexité puisse intimider. En effet, en OCaml, il est possible de distinguer
clairement l'interface (la _signature_) de l'implémentation (la _structure_),
facilitant ainsi l'encapsulation et la documentation, tout en autorisant
**l'application de fonctions dans le langage des modules**.

Il m'est particulièrement difficile d'aborder brièvement le sujet des modules
(c'est un domaine que j'aspire à explorer depuis _des années_ sur mon blog).
Cependant, voici une liste des avantages que je perçois dans cette approche
_très modulaire_ d'OCaml :

- La compilation séparée, une fonctionnalité clé, permet de compiler
  efficacement de gros programmes en identifiant des points de jonction pour
  optimiser la compilation parallèle et incrémentale. Cette approche est
  exploitée par [dune](https://dune.build/), le système de construction
  recommandé pour compiler du OCaml.
  
- La séparation systématique entre l'implémentation et l'interface offre
  plusieurs avantages significatifs, notamment l'encapsulation et la
  localisation de la documentation dans l'interface. Dans mon flot de
  programmation, je trouve ça très confortable car je peux implémenter ma
  _structure_ (l'implémentation d'un module) en me _laissant guider par
  l'inférence_ et spécifier son API dans sa _signature_ (l'interface du module)
  tout en décidant d'un ordre d'affichage et en fournissant une documentation
  claire ne polluant pas l'espace d'implémentation. En complément,
  l'encapsulation me permet librement de décrire, dans le corps de ma structure,
  des types intermédiaires pour, par exemple, exprimer la machine à état d'une
  application, [sans la laisser
  s'échapper](https://en.wikipedia.org/wiki/Leaky_abstraction).

- Un outil formidable pour décrire des structures de données. En effet, en
  abstrayant les types (en cachant leur implémentation), couplé à
  l'encapsulation, il est possible de décrire des structures de données qui
  **maintiennent des invariants**. C'est d'ailleurs pour ça qu'il est courant
  d'avoir une paire structure/signature par structure de données cachant, au
  moyen de l'abstraction et de l'encapsulation, des détails d'implémentation.
  
- De la réutilisabilité et de la mutualisation. En effet, de la même manière
  qu'il est possible de décrire des types dans le langage des valeurs (comme
  nous l'avons vu dans la rubrique dédiée aux types algébriques), il est
  possible de décrire des types dans le langage des modules, que l'on appelle
  des **signatures translucides**, permettant de décrire le type d'une
  signature, sans l'associer à une structure. Ces signatures sont typées
  structurellement, et couplées avec les fonctions dans le langage des modules,
  [foncteurs](https://ocaml.org/docs/functors), il est possible de _mutualiser
  du comportement_ attaché à des modules.
  
- Des formes de polymorphisme avancé, notamment du [Higher Kinded
  Polymorphism](https://okmij.org/ftp/ML/higher-kind-poly.html), disponible
  dans le langage des modules. Dans les grandes lignes, on peut décrire _"des
  génériques, paramétrés par des génériques"_. Cette limitation dans des
  langages, comme F# ou Java, motive souvent l'utilisation [d'encodages
  lourds](https://github.com/yallop/higher?tab=readme-ov-file#implementations-in-other-languages)
  pour pallier ce manque.
  
La théorie derrière les langages de modules dans les langages ML est un sujet
très vaste, [toujours en évolution](https://dl.acm.org/doi/10.1145/3649818),
qu'il est très difficile de résumer dans un paragraphe. Cependant,
l'introduction de la thèse de [Derek
Dreyer](https://people.mpi-sws.org/~dreyer/), [_Understanding and Evolving the
ML Module System_](https://people.mpi-sws.org/~dreyer/thesis/main.pdf) donne une
très bonne explication sur les intérêts des modules, de leurs usages, illustrés
avec beaucoup d'exemples. J'espère cependant prendre du temps dans les
semaines/mois à venir pour écrire sur le langage de modules, plus expansivement
que ce que j'ai [déjà tenté](/pages/modules-import.html), parce que ça pourrait
être formateur et que le domaine est, je trouve, très très intéressant !

#### Injection et inversion de dépendances

En parlant brièvement de la programmation orientée objets en OCaml, j'ai évoqué
rapidement le _fait_ que OCaml permet d'exprimer, par le biais des
fonctionnalités offertes par le langage, trivialement, des prérequis pour écrire
du code **SOLID**. Le dernier point que j'aimerais souligner est la facilité
d'inversion des dépendances à injecter au moyen de **fonctionnalités offertes
par le langage**. Dans les grandes lignes, le principe d'inversion des
dépendances consiste à décrire des treillis de dépendance au moyen
**d'abstractions** et non **d'implémentations**. De cette manière, les
dépendances peuvent-être _injectées à postériori_ — rendant, notamment, le
changement de contextes, pour des tests unitaires par exemple, trivialement
implémentables.

OCaml dispose de deux outils facilitant cette inversion, et pouvant être utiles
dans des contextes différents. Et nous allons nous inspirer de l'exemples très
populaires du télétype pour montrer comment inverser les dépendances :

```ocaml
let program () =
  let () = print_endline "Hello World" in
  let () = print_endline "What is your name?" in
  let name = read_line () in
  print_endline ("Hello " ^ name)
```

Même si ça peut ne pas sembler évident, ce programme dépend d'implémentations
concrètes, **les interactions avec l'entrée et la sortie standards**.

##### Par le biais de modules

L'approche la plus évidente consiste à utiliser des modules, comme [valeurs de
premier ordre](https://ocaml.org/manual/firstclassmodules.html) ou par
construction, au moyen de [foncteurs](https://ocaml.org/docs/functors). La
dualité entre les signatures et les structures rend l'inversion de dépendances
évidente. Par exemple, pour reprendre notre exemple, voici comment, en utilisant
des [_first-class modules_](https://ocaml.org/manual/firstclassmodules.html), il
est **très facile** de dépendre d'un ensemble d'interaction abstrait. On
commence par décrire la représentation abstraite des interactions possibles :

```ocaml
module type IO = sig
  val print_endline : string -> unit
  val read_line : unit -> string
end
```

On peut maintenant attendre de notre fonction `program` qu'elle prenne un module
du type `IO` en argument (on appellera ça _un gestionnaire_) et utiliser les
fonctions exportées par le module, qui, dans notre exemple, s'appelle `Handler`
:

```ocaml
let program (module Handler: IO) = 
  let () = Handler.print_endline "Hello World" in
  let () = Handler.print_endline "What is your name?" in
  let name = Handler.read_line () in
  Handler.print_endline ("Hello " ^ name)
```

Et il est possible, par exemple, dans le contexte des tests unitaires, de
fournir une implémentation qui journalise l'ensemble des opérations appelées (et
qui _mock_ l'appel de `read_line`, pour fixer le résultat renvoyé). Cela rend
l'expression de tests unitaires _testant la logique métier_ très facile à
implémenter.

L'action de passer une implémentation concrète en argument à notre fonction
consiste à **interpréter le programme**.

##### Par le biais d'_effets définis par l'utilisateur_

La version 5 d'OCaml est arrivée avec son lot de nouveautés. Cependant, la plus
grande avancée est la refonte du _runtime_ d'OCaml pour prendre en charge le
multi-cœur. Il existe plusieurs manières de décrire des algorithmes concurrents,
par exemple en utilisant des
[acteurs](https://en.wikipedia.org/wiki/Actor_model) ou encore des
[canaux](https://go101.org/article/channel.html). OCaml a fait le choix
d'utiliser [des
effets](https://github.com/ocaml-multicore/ocaml-effects-tutorial), permettant
de simplifier le traitement du flot de contrôle du programme. En effet OCaml
permet à l'utilisateur de décrire ses propres effets, que l'on appelle
logiquement, [des effets définis par
l'utilisateur](https://ocaml.org/manual/effects.html). Même s'ils forment un
outil formidable pour décrire des programme concurrents, ils permettent aussi de
faciliter l'injection de dépendances quand on veut garder la main, _au niveau du
gestionnaire_, sur le flot d'exécution d'un programme.

> Attention, dans mon exemple, j'utilise une syntaxe expérimentale, [tout juste
> fusionnée](https://github.com/ocaml/ocaml/pull/12309) dans le tronc de OCaml,
> et qui sera probablement disponible dans la version `5.3.0` du langage.

Comme pour notre amélioration précédente, il faut d'abord décrire l'ensemble des
opérations que l'on pourra produire. On utilise la construction `effect` :

```ocaml
effect Print_endline : string -> unit
effect Read_line : unit -> string
```

Ensuite, on peut écrire, dans un style directe, notre programme en _produisant
des effets_ :

```ocaml
let program () =
  let () = Effect.perform (Print_endline "Hello World") in
  let () = Effect.perform (Print_endline "What is your name?") in
  let name = Effect.perform (Read_line ()) in
  Effect.perform (Print_endline ("Hello " ^ name))
```

Il est ensuite possible d'interpréter, à postériori, notre programme en
utilisant une construction similaire au filtrage par motif pour donner un sens
spécifique à chaque effet.

Actuellement, on regrettera que la propagation d'effets ne soit pas capturée par
le système de types. Cependant, il s'agit d'une fonctionnalité expérimentale,
que l'on utilise massivement dans la [nouvelle version de
YOCaml](https://gitlab.com/funkywork/yocaml). Je sais que des ressources sont
allouées à l'élaboration d'un système de type efficace pour _tracker_ la
propagation d'effets !

En général, quand je ne me soucie pas du contrôle du flot du programme, ou que
je ne veux pas pouvoir ajouter des effets _à postériori_, j'utilise des modules.
Mais dans le cas de YOCaml, on a profité de l'utilisation du nouveau système
d'effets pour [introduire des effets dédiés aux tests
unitaires](https://gitlab.com/funkywork/yocaml/-/commit/d78bb21077272ae86f7b6b3017509596de0a5a27),
permettant, par exemple, de _mocker_ le _temps qui passe_.

Une fois de plus, il est vraiment très compliqué de ne pas trop s'épancher sur
les _effets définis par l'utilisateur_, qui est une toute nouvelle
fonctionnalité très excitante du langage. Je terminerai en me contentant de vous
partager deux articles écrits par [Arthur Wendling](https://github.com/art-w)
expliquant, très pédagogiquement, l'utilisation des effets, ainsi qu'une
bibliographie très complète de la littérature relative à l'abstraction d'effets
en programmation fonctionnelle :

- [Scopes and effect
  handlers](https://hackmd.io/@yF_ntUhmRvKUt15g7m1uGw/Bk-5NXh15)
- [Roguelike with effect
  handlers](https://hackmd.io/@yF_ntUhmRvKUt15g7m1uGw/BJBZ7TMeq)
- [Effect bibliography](https://github.com/yallop/effects-bibliography)

À noter qu'il serait aussi possible de procéder à cette inversion/injection au
moyen de _records_ ou d'objets, cependant, mon expérience en OCaml m'indique que
les approches avec des modules ou des effets (quand on veut pouvoir manipuler le
flot de contrôle), sont souvent plus directes et facile à raisonner.

### Concernant le futur

OCaml est un langage _toujours en activité_ qui, de version en version, évolue.
Dans la section dédiée à l'inversion de dépendances, j'ai rapidement parlé de
l'inclusion toute récente d'effets dans le langage pour décrire un _runtime_
multi-cœur, témoignant des mutations dont bénéficie le langage au fil des
années. On notera aussi l'intégration des [opérateurs de
liaisons](https://ocaml.org/manual/bindingops.html), rendant l'utilisation de la
triade
[Foncteurs](https://en.wikipedia.org/wiki/Functor_(functional_programming)),
[Foncteurs Applicatifs](https://en.wikipedia.org/wiki/Applicative_functor) et
[Monades](https://en.wikipedia.org/wiki/Monad_(functional_programming)) plus
confortable — à la manière des [expressions de
calcul](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/computation-expressions),
en F#.

Actuellement, beaucoup de chantiers très excitants sont en œuvre pour améliorer,
encore plus, le langage :

- un travail de fond sur l'expression des effets, avec une nouvelle syntaxe
  fraichement ajoutée, et une collection de travaux sur la séparation entre les
  [opérations et les effets](https://github.com/ocaml/ocaml/pull/12736) et,
  évidemment, sur la [propagation des effets dans le système de
  types](https://arxiv.org/abs/2407.11816).
  
- [Jane Street](https://opensource.janestreet.com/) a proposé [un modèle
  non-intrusif de gestion de
  ressources](https://antonlorenzen.de/mode-inference.pdf), inspiré par celui de
  Rust, introduisant _des modalités_ et _un peu de linéarité_.
  
- Un véritable [travail de
  fond](https://clement.blaudeau.net/assets/pdf/blaudeau_ocaml_modules.pdf) à
  été entamé sur le langage de modules permettant de rendre l'implémentation de
  [Modular
  Implicits](https://www.cl.cam.ac.uk/~jdy22/papers/modular-implicits.pdf) plus
  sereinement implémentable.
  
On notera aussi le développement d'un système de [macro
hygiénique](https://xnning.github.io/papers/icfp23.pdf), de l'intégration
progressive d'un système de [métaprogrammation à
étages](https://okmij.org/ftp/ML/MetaOCaml.html), de l'implémentation d'un
[_back-end d'optimisation_](https://ocamlpro.com/blog/tag/flambda2/), témoignant
de l'activité forte de OCaml dans le secteur de l'innovation et rendant son
développement, pour les années à venir, très motivant et excitant !

### Points faibles

Même si je suis convaincu que OCaml est un **excellent langage**, dire qu'il est
parfait serait probablement de la _très mauvaise foi_ — en effet, _rien n'est
malheureusement parfait_. Voici, selon moi, quelques points ombrageant OCaml en
tant que langage :

- l'absence de [polymorphisme
  ad-hoc](https://en.wikipedia.org/wiki/Ad_hoc_polymorphism). Même s'il est
  possible de s'en tirer sans, notamment au moyen d'ouvertures locales de
  modules, l'absence de _polymorphisme ad-hoc_ (au moyen de [classes de
  types](https://en.wikibooks.org/wiki/Haskell/Classes_and_types), _à la
  Haskell_ ou
  [traits](https://doc.rust-lang.org/book/ch10-02-traits.html)/[objets
  implicites](https://docs.scala-lang.org/tour/implicit-parameters.html), _à la
  Rust et Scala_ ou encore des [structures
  canoniques](https://coq.inria.fr/doc/v8.18/refman/language/extensions/canonical.html)
  _à la Coq_) peut parfois rendre certaines situations délicates. Même si j'ai
  tendance à toujours trouver les relations explicites préférables, j'ai, au fil
  des années, trouvé plusieurs cas où cette absence pouvait être problématique :
  
    - l'impossibilité de décrire des contraintes de paramètres de types sur des
      fonctions polymorphes, introduisant dans la bibliothèque des fonctions
      d'égalités et de comparaisons polymorphes, faisant couler [beaucoup
      d'encre](https://blog.janestreet.com/the-perils-of-polymorphic-compare/)
      et imposant, par exemple, des versions spécialisées de opérateurs
      arithmétiques pour les differentes représentations des nombres (`int`,
      `int64`, `float`).
      
    - Le risque d'explosion combinatoire quand on décrit beaucoup de relations
      entre des modules. C'est pour cette raison que la bibliothèque
      [Preface](https://github.com/xvw/preface) propose une [découpe modulaire
      un peu
      complexe](https://github.com/xvw/preface/blob/master/guides/option_instantiation.md)
      
  Cependant, même si l'arrivée des [modules
  implicites](https://www.cl.cam.ac.uk/~jdy22/papers/modular-implicits.pdf)
  n'est probablement pas dans la feuille de route _court-termiste_, les récents
  travaux sur le langage de modules, présentés dans la rubrique dédiée au futur
  du langages, sont prometteurs.
  
- Une interaction laborieuse entre le langage de modules et le langages des
  valeurs. En effet, le langage de modules est **un langage différent**, doté
  d'un système de types différent. Je ne sais pas si l'on peut réellement parler
  d'un point faible, mais cette différence peut être intimidante et s'explique
  par le fait que le langage de modules de OCaml est un pionier dans la théorie
  des modules et prédate des innovation _plus récentes_
  ([1ML](https://people.mpi-sws.org/~rossberg/1ml/1ml-extended.pdf) par
  exemple). Dans la pratique, en plus d'être _complexe à appréhender_, certains
  pans du langages sont difficiles à spécifier correctement, par exemple [les
  modules
  récursifs](https://www.ocaml.org/manual/5.2/recursivemodules.html#s%3Arecursive-modules).
  
- Un langage _confortable pour la programmation fonctionnelle_, impur. Même si
  je trouve que l'impureté est **une feature**, quand on essaye d'importer des
  idiomes issus de langages purs (au hasard, Haskell), on peut se heurter à des
  difficultés liées à l'inférence de types : la [_value
  restriction_](https://en.wikipedia.org/wiki/Value_restriction). Même si, en
  OCaml, elle [a été
  _détendue_](https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.pdf),
  ses implications sur l'inférence de fonctions polymorphes peuvent être
  intimidantes — pour de très bonnes raisons.
  
- La syntaxe. Même si, à titre personnel, j'apprécie beaucoup la syntaxe de
  OCaml et que je suis convaincu que la syntaxe devrait rarement être une issue,
  je suis conscient que certains choix syntaxiques peuvent être déroutants. Par
  exemple, le fait que les paramètres de types préfixent le nom du type, _une
  liste de a_ sera écrite `'a list`. Beaucoup de ces choix sont motivés par une
  _volonté de réduire l'ambiguïté de la syntaxe du langage_ et on s'y fait très
  vite. Cependant, je suis conscient qu'en venant d'un autre langage, certains
  de ces choix peuvent sembler surprenants.
  
Je pense que ces points faibles sont globalement discutables (parce qu'ils sont
souvent justifiés), mais je comprend parfaitement qu'ils peuvent être
perturbants. Cependant, je pense qu'ils ne suffisent pas à rendre OCaml
inutilisable et **qu'ils ne devraient pas être une barrière trop grande pour se
mettre à OCaml** ! Et le bénéfice d'avoir un langage _améliorable_, c'est qu'il
reste, en permanence, une volée d'améliorations potentielles, motivant des
travaux qui peuvent, en plus, bénéficier à d'autres langages. Et, en toute
sincérité, en étant conscient de ces _parties rugueuses_, j'ai plus souvent eu
l'occasion de râler de l'absence de traits de langages, présents dans OCaml,
dans d'autres langages, que de râler de ces parties en écrivant du OCaml, pour
lesquelles il existe, souvent, des solutions (parfois, à la limite de la
satisfaction, je vous l'accorde) permettant de travailler sereinement.


### Pour conclure sur le langage

J'ai, dans les _très très_ grandes lignes, survolé **des raisons** qui font que,
selon moi, apprendre OCaml est un choix **très pertinent**. Ce langage permet de
_comprendre fondamentalement_ certains idiomes de programmation _très_
populaires (mais souvent mal définis). De plus, certains aspects du langage
servent parfaitement des desseins industriels rendant, parfois, des bonnes
pratiques, triviales à exprimer ! Une grande partie de ces attraits est
expérimentable avec d'autres langages, cependant, la nature _fortement
multi-paradigmes_ de OCaml permet de centraliser son apprentissage dans un seul
langage. À ma connaissance, dans la jungle de langages _partiellement
populaires_, seul Scala semble couvrir autant de sujets, même si, de mon point
de vue, son modèle objet est, essentiellement par soucis d'interopérabilité avec
les autres langages de la JVM, largement moins intéressant.

Comme l'objectif de cet article n'est pas d'être un tutoriel, j'ai
volontairement passé rapidement sur certains concepts, [les
modules](https://ocaml.org/docs/modules) et les
[effets](https://ocaml.org/manual/ffects.html). Je n'ai presque pas parlé des
[objets](https://ocaml.org/docs/objects), des [variants
polymorphes](https://ocaml.org/manual/polyvariant.html) et des [types
algébriques généralisés](https://ocaml.org/manual/gadts-tutorial.html). Si
jamais ces sujets vous intéressent, je vous invite à lire en détail l'excellent
[Using, Understanding, and Unraveling The OCaml
Language](https://caml.inria.fr/pub/docs/u3-ocaml/index.html), de [Didier
Remy](http://cristal.inria.fr/~remy/), couplé aux livres que j'ai présentés en
introduction, qui est une mine d'or pour toute personne désireuse d'approfondir
ses connaissances en OCaml.

Pour conclure, OCaml offre un outillage, au niveau du langage, varié et riche
pour l'apprentissage de la programmation, la construction de programmes
industriels respectant des standards mais aussi l'implémentation [structure de
données complexes](https://github.com/art-w/deque) et [d'abstractions issu de la
théorie des catégories](https://github.com/xvw/preface) comme un noyau
fonctionnel, des traits impératifs, un système de types inférés riche et
expressif (permettant l'expression de types algébriques, facilitant l'expression
de domaines clairs), un langage de modules comme outil d'abstraction, de
réutilisabilité et de définition d'unités de compilation, un modèle objet, la
possibilité d'exprimer des effets que l'on peut propager et interpréter _à
postériori_ et d'autres fonctionnalités avancées. Ne serait-ce que pour
_appréhender des concepts avancés de programmation_, OCaml est un **excellent
candidat** — c'est d'ailleurs pour ça que OCaml est une inspiration évidente
pour beaucoup de langages plus récents, [Rust étant un des exemples
notables](https://doc.rust-lang.org/reference/influences.html).


## OCaml en tant qu'écosystème

Avoir un langage expressif est très bénéfique pour _construire des choses_ (la
formulation est volontairement naïve). Cependant, dans différents contextes, le
professionnel et le personnel, ce n'est pas suffisant :

- dans le contexte professionnel, il est évident que si je veux que mon équipe et moi
  soyons productifs, il n'est probablement pas très pertinent de devoir
  construire une pile d'outils avant de pouvoir commencer à répondre au problème
  pour lequel on est mandaté.
  
- Dans le contexte personnel, même si l'on pourrait _arguer_ que construire sa
  pile technologique est **très formateur**, ça modifie l'ensemble des
  compétences que l'on veut _travailler_. Si pour construire une petite
  application web pour m'initier à OCaml comme un langage web, je dois
  construire toute ma pile HTTP, il est fort probable que OCaml ne soit pas le
  bon choix. Rassurez-vous, cependant, OCaml dispose [d'un outillage
  riche](https://ocaml.org/docs/is-ocaml-web-yet) pour construire des
  applications web !
  
C'est pour ça que les fonctionnalités offertes par le langage ne sont pas une
métrique suffisante pour décrire sa viabilité pour construire et maintenir des
projets. L'écosystème est aussi un point très important. C'est d'ailleurs pour
ces raisons que [.NET](https://dotnet.microsoft.com/en-us/) et la
[JVM](https://en.wikipedia.org/wiki/Java_virtual_machine), par le biais de
langages relativement peu expressifs (mais en progrès) comme Java et C# sont
aussi populaires. Pour juger la pertinence d'un écosystème, je pense qu'il est
important de prendre en compte plusieurs critères :

- la pertinence du _runtime_ (ou des cibles de compilations) pour le projet. Il
  est probable que je ne recommande pas OCaml pour l'embarquer dans un tout
  petit _hardware_ exotique — même si, n'y connaissant rien en programmation
  _bas-niveau_ (parce que ce n'est pas du tout mon métier), il est probable que
  je me trompe.
  
- Sa **plateforme**. Est-ce que l'ensemble de sa _chaine d'outillage_ est
  complète et ergonomique. Ce qui inclut, de mon point de vue, un gestionnaire
  de paquet, un _build-system_, un bon _support éditeur_ (agnostique au
  possible), un bon générateur de documentation et une collection d'outils
  additionnels, comme, par exemple, un _formateur_ (et bien d'autres).
  
- La pertinence des **bibliothèques disponibles** (et leur niveau de maintenance
  et leur découvrabilité, ce qui implique généralement la nécéssité de disposer
  d'un gestionnaire de paquets) avec une considération particulière sur
  l'ergonomie de ces dernières. Par exemple, si je ne dispose d'aucune primitive
  de chiffrement, il est probable que je ne choisisse pas cette technologie pour
  construire une _blockchain_. Il existe toute une classe de problèmes qu'il est
  **très difficile** de _résoudre dans son coin_ ou dans un contexte
  professionnel.
  
Dans cette section, nous allons essayer de survoler ces différents points pour
voir si l'écosystème OCaml est à la hauteur du langage. Je tiens à préciser que
**je suis un peu biaisé** parce que je suis convaincu de la pertinence de OCaml
depuis 2012, à l'époque où l'écosystème était **drastiquement plus pauvre**. A
cette époque, j'ai essayé de construire des projets en composant avec les
manques ce qui a engendré, probablement, un [biais du
survivant](https://en.wikipedia.org/wiki/Survivorship_bias). Comme de nos jours,
notamment grâce à des utilisateurs industriels, l'écosystème de OCaml est
largement plus riche et étendu, il est cependant devenu beaucoup plus simple de
le défendre, et quand certains manques subsistent, la mauvaise fois _de l'ancien
utilisateur_ peut ressurgir.

### Compilation, _runtimes_, et cibles additionnelles

OCaml dispose depuis sa genèse de deux cibles de compilation : 

- une compilation native, qui produit des exécutables très efficaces, compilés
  pour une architecture. (Et qui supporte un [grand nombre
  d'architectures](https://github.com/ocaml/ocaml?tab=readme-ov-file#overview)).
  De plus, alors qu'historiquement, Windows était fortement délaissé, [un effort
  tout
  particulier](https://tarides.com/blog/2024-05-22-launching-the-first-class-windows-project/)
  a été mis en oeuvre pour le supporter (on notera aussi le projet
  [DkMl](https://github.com/diskuv/dkml-installer-ocaml), une initiative
  indépendante).

- une compilation vers un _bytecode_ (donc à destination d'une machine
  virtuelle), produisant des exécutables portables.
  
La présence d'une machine virtuelle a permis le développement du vénérable
[Js\_of\_OCaml](http://ocsigen.org/js_of_ocaml/latest/manual/overview) qui
permet [la transformation dy bytecode OCaml vers
JavaScript](https://www.irif.fr/~vouillon/publi/js_of_ocaml.pdf), rendant OCaml
parfaitement viable pour le développement d'application dans le navigateur, mais
aussi dans le _runtime_ [node](https://nodejs.org/en), et qui est drastiquement
utilisé pour ce site web. En utilisant une technique similaire, le support de
[WebAssembly](https://webassembly.org/) a été rendu possible, très récemment,
par le biais du projet
[Wasm\_of\_OCaml](https://github.com/ocaml-wasm/wasm_of_ocaml). Supporter la
compilation vers _WASM_ pour un langage étant doté d'un [glâneur de
cellules](https://en.wikipedia.org/wiki/Garbage_collection_(computer_science))
était un _sacré challenge_, mais l'équipe derrière _WASM_ ayant récemment
spécificé l'interaction entre _WASM_ et des [_garbage
collector_](https://github.com/WebAssembly/gc)), **OCaml dispose maintenant
d'une compilation vers WebAssembly parfaitement décente** (et beaucoup de
projets web, ambitieux, comme [Ocsigen](https://ocsigen.org), commencent à
supporter _WASM_ nativement).
  
De plus, le projet [Melange](https://melange.re) (historiquement
[BuckleScript](https://discuss.ocaml.org/t/a-short-history-of-rescript-bucklescript/7222))
propose de _transpiler_ — mapper l'_AST_ de OCaml vers l'_AST_ de JavaScript —
est une alternative pour produire du JavaScript. Si je devais comparer
[Js\_of\_OCaml](http://ocsigen.org/js_of_ocaml/latest/manual/overview) et
[Melange](https://melange.re), au delà des différentes méthodes sous-jacentes
utilisées pour produire du JavaScript (compiler vers du _bytecode_ et
transformer ce _bytecode_ en JavaScript, contre la transformation syntaxique de
OCaml en JavaScript), je dirais que **Js\_of\_OCaml** se marie mieux avec
l'écosystème OCaml, et est donc, probablement, à **destination de développeurs
OCaml** désireux de rendre leurs projets accessibles depuis un navigateur — en
effet, l'interaction avec l'écosystème JavaScript existant peut-être plus
laborieuse. **Melange** se marie mieux avec l'écosystème JavaScript (`npm` _and
co_) et est donc, probablement, **à destination des développeurs JavaScript**
désireux d'apporter plus de sûreté dans leurs projets JS (ou dans une base de
code existante).

De nos jours, il est courant de trouver des langages _multi-backend_ comme
[Idris](https://www.idris-lang.org/) ou [Nim](https://nim-lang.org/). Cependant,
_à l'époque_, j'étais très impressionné par le fait que OCaml puisse, _depuis le
moment où j'ai commencé à l'utiliser_, compiler vers JavaScript (en plus). A
cette épqoue, je ne connaissais que [Haxe](https://haxe.org/) qui proposait
plusieurs cibles de compilation, si différentes (d'ailleurs, Haxe est [écrit en
OCaml](https://github.com/HaxeFoundation/haxe)). 

En effet, en 2024, produire du JavaScript est devenu standard, on trouve les
[premières traces de Js\_of\_OCaml en
2006](https://www.irif.fr/~balat/publications/2006mlworkshop-balat-ocsigen.pdf),
faisant de OCaml, un pionier dans le domaine !

#### Un petit détour par MirageOS

Dans le _treillis formé par les différents contextes d'exécution et de
compilation de OCaml_, avoir des bibliothèques qui fonctionnent bien dans _une
majorité de contexte_ est un exercice compliqué. Heureusement, le projet
[MirageOS](https://mirage.io/) — un ensemble de bibliothèques conçues pour
construire un **systéme d'exploitation dedié à ne faire tourner qu'une seule
application**, au moyen de virtualisation (un
[_unikernel_](https://en.wikipedia.org/wiki/Unikernel)) — a introduit une
véritable hygiène de la production de bibliothèques multi-contextes.

Dans un futur _proche_, j'aimerais passer plus de temps à écrire sur Mirage, un
projet fascinant que l'on essaie d'intégrer dans nos projets, par exemple dans
[YOCaml](https://github.com/xhtmlboi/yocaml), notre générateur de sites
statiques. D'ailleurs, en plus de fournir une approche saine de la distribution
de bibliothèques _intelligemment compartimentées_, Mirage offre un socle solide
de bibliothèques pour la construction de projets OCaml, dont je parlerai, en
étant plus _expansif_, dans la rubrique dédiée aux bibliothèques.


### La plateforme OCaml

La [plateforme OCaml](https://ocaml.org/platform) est un ensemble d'outils,
maintenus dans un cycle de vie explicite (`actif`, `en incubation`, `maintenu`
et `déprécié`), destinés adosser le compilateur à une chaine d'outillage
cohérente pour la production de code OCaml. On y trouve beaucoup d'outils qui
servent différents propos, cependant, dans cette section, je ne vais me
focaliser que sur certains points de la plateforme, vous laissant le loisir de
consulter sa [page](https://ocaml.org/platform) et sa [feuille de
route](https://ocaml.org/tools/platform-roadmap) pour de plus amples
informations. Dans cette section, nous allons nous intéresser, _dans les grandes
lignes_, à 4 grands points spécifiques :

- Le gestionnaire de paquets
- Le système de construction (_build-system_)
- Le support éditeurs (incluant le formatage de code)
- Le générateur de documentation

Quand on utilise OCaml depuis un certains temps, c'est probablement la partie la
plus excitante de l'article, car, selon moi, c'est celle qui a bénéficié du plus
de progrès. Et la [feuille de route](https://ocaml.org/tools/platform-roadmap)
est, selon moi, prometteuse !

#### OPAM, le gestionnaire de paquets

Même si _les gestionnaires de paquets dédiés à un langage spécifique_ sont
devenu très populaires (pour ne pas dire obligatoire) dans la réduction des
frictions de l'adoption d'un langage, à l'époque ou OCaml a été conçu, ces
derniers étaient confidentiels. En effet, mis à part
[CTAN](https://en.wikipedia.org/wiki/CTAN), pour distribuer des paquets
[TeX](https://en.wikipedia.org/wiki/TeX) et
[CPAN](https://en.wikipedia.org/wiki/CPAN), inspiré par CTAN, pour distribuer
des paquets [Perl](https://www.perl.org/) et
[PEAR](https://en.wikipedia.org/wiki/PEAR), pour [PHP](https://www.php.net/), il
faudra attendre les [Gems](https://en.wikipedia.org/wiki/RubyGems) pour que les
technologies de développement considèrent l'adoption d'un gestionnaire de
paquets comme axiomatique pour le développement d'un langage.

[OPAM](https://opam.ocaml.org), pour **O**Caml **Pa**ckage **M**anager est une
[proposition](https://raw.githubusercontent.com/ocaml/opam/30598a59c98554057ce2beda80f0d31474b94150/specs/roadmap.pdf)
de 2012 (la [page _À propos_ du site
officiel](https://opam.ocaml.org/about.html) présente une petite frise
chronologique). OPAM permet, en plus d'installer des paquets, installer des
versions différentes de OCaml, et construire des environnements _potentiellement
isolés dans des bacs à sables_, que l'on appelle des
[switches](https://ocaml.org/docs/opam-switch-introduction). Il est possible
d'utiliser le dépôt publique de ressources, [hébergé sur
Github](https://github.com/ocaml/opam-repository) mais il est parfaitement
possible de construire son propre index de paquets.

> Ayant déjà publié plusieurs paquets sur OPAM, je dois avouer que la
> [CI](https://check.ci.ocaml.org/) de validation d'ajout de paquets est
> incroyablement efficace et ergonomique (chaque erreur fournit un Dockerfile
> pour reproduire l'issue localement) et que l'équipe de personnes qui modèrent
> et administrent les ajouts/modifications de paquets sont extraordinaires de
> réactivité et de bienveillance.

Même si, à la lumière de la modernité, on pourrait reprocher plusieurs points à
OPAM, par exemple :

- une terminologie pouvant être laborieuse à appréhender (_switch_, _invariant_,
  etc.)
- la duplication de tous les paquets et de tous les compilateurs entre plusieurs
  _switches_ (c'est un problème connu pour lequel [du travail a déjà été mis en
  oeuvre](https://www.youtube.com/watch?v=5JDSUCx-tPw))
- et probablement quelques soucis d'ergonomie (notamment l'interaction avec
  `dune` pouvant être plus _smooth_, pour lequel un [travail est aussi
  actuellement en
  cours](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160))
- quelques complications quand il s'agit de gérer des paquets en développement,
  en les référençant depuis un dépôt de source plutôt que depuis OPAM
  
Je dois avouer qu'en venant d'une ère où OPAM n'existait pas, j'ai appris à
m'accomoder de certains de ces petits écueils et que, quotidiennement, je dois
avouer avoir peu de raison de me plaindre de l'outil qui, pour mon usage
quotidien, ne m'a jamais réellement fait défaut. Cependant, si vous avez fait
face à des soucis d'usages, je vous invite à venir en discuter sur [l'un des
espaces destinés à la communication](https://ocaml.org/community) pour que
l'équipe de développement puisse tenir compte de vos retours, et vous aiguiller.

Il existe aussi [esy](https://esy.sh/) comme gestionnaire de paquets alternatif,
qui s'inspire de [Nix](https://nixos.org/) pour construire un _store_
réutilisable, de la même manière qu'il est possible d'utiliser Nix avec OCaml,
cependant, étant un peu conventionnel, je ne suis pas vraiment aux faits de ces
pratiques et, étant satisfait de mon _workflow_ avec OPAM, je n'ai,
malheureusement, jamais pris le temps d'expérimenter sérieusement **esy**.

#### Dune, le _build-system_

Comme pour la gestion de paquets, historiquement, OCaml disposait de
**plusieurs** _build-systems_ : le vénérable
[ocamlbuild](https://github.com/ocaml/ocamlbuild),
[oasis](https://github.com/ocaml/oasis),
[ocp-build](https://github.com/OCamlPro/ocp-build),
[Jenga](https://ocaml.org/p/jenga/latest) et d'autres variation autours de
[Make](https://www.gnu.org/software/make/). Cependant, depuis 2018, la
communauté à fortement adopté [Dune](https://dune.build/), un _build-system_
initialement développé à [Janestreet](https://www.janestreet.com/).

Sur beaucoup d'aspects, Dune peut être intimidant. En effet, sa
[documentation](https://dune.readthedocs.io/en/stable/) est **très touffue** —
mais elle s'est très largement améliorée, en terme de structure au cours de ces
derniers mois. Et, alors que beaucoup d'outils choisissent des langages de
descriptions de règles comme [Yaml](https://en.wikipedia.org/wiki/YAML),
[Toml](https://en.wikipedia.org/wiki/TOML) ou encore
[JSon](https://en.wikipedia.org/wiki/JSON), Dune a fait le choix des
[S-expression](https://en.wikipedia.org/wiki/S-expression). On regrettera aussi
que Dune paramètre, _par défaut_, [l'ensemble des
avertissements](https://ocaml.org/manual/5.2/comp.html#s%3Acomp-warnings) fatal.

Avant de motiver certains choix (comme les **S-expression**), il est très
important de souligner les points qui ont fait de Dune un standard :

- Dune est **très rapide** et propose un modèle d'exécution **très efficace**
- il construit des artéfacts nécéssaire à la configuration _gratuitement_
- il génère certains fichiers redondants (comme les fichiers de description
  OPAM)
- il trivialise le [_vendoring_](https://en.wikipedia.org/wiki/S-expression) de
  bibliothèques
- il permet d'invoquer des [boucles
  d'interaction](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
  correctement provisionnées par le contexte
- on se familiarise très rapidement avec les **S-expression**, qui permette de
  décrire schématiquement et rapidement des règles de compilation
- il est relativement agnostique et peut exécuter des tâches arbitraires (à la
  manière de `make`)
- il est en constante évolution et amélioré de version en version
- adossé à [dune-release](https://github.com/tarides/dune-release), il rend la
  publication de paquets sur OPAM incroyablement simple
  
Peut-être que je suis biaisé mais, selon moi, Dune est un des _build-system_ les
plus génériques et agréables que j'ai pu utiliser — même si, aux premiers
abords, il peut sembler effrayant et certains choix peuvent sembler difficile à
motiver.

##### Sur le choix des S-expression

Aux premiers abords, l'utilisation d'un _lisp-like_ pour décrire des binaires,
des bibliothèques et des projets peut sembler surprenant. Cependant, cette
décision à plusieurs avantages :

- l'AST des **S-expression** étant **drastiquement simple**, le _parsing_ est
  très simple et il est facile de le rendre très efficace, ce qui ne pénalise
  pas l'efficacité de la compilation
- le langage dispose de _terminaison_, ce qui le rend plus facile à inspecter en
  cas d'erreurs (pour toute personne ayant tenté de traiter des erreurs dans de
  gros fichiers YAML doit avoir été confronté à ce genre de problèmes)
- le langage est très facile à apprendre, et à décrire
- il permet de décrire de **véritables programmes**, rendant Dune relativement
  générique et permettant de faire des tâches additionnelles
  
Donc, de mon point de vue, le choix des **S-expression** est pertinent, il
permet de décrire des programmes complexes, lisibles, sans être trop verbeux, il
ne pénalise pas trop la compilation et il permet de décrire, de manière très
concise, des règles de compilations très complexes. Et pour être très honnête,
on s'y fait très vite !

##### Contribution à l'état de l'art: Selective Applicative Functor

En plus d'être un très agréable _build-system_, Dune a contribué à l'état de
l'art de la recherche en mettant en lumière une nouvelle construction _inspirée
de la théorie des catégories_. En effet, en 2018, [Andrey
Mokhov](https://blogs.ncl.ac.uk/andreymokhov/about/), [Neil
Mitchell](https://ndmitchell.com/) et [Simon Peyton
Jones](https://simon.peytonjones.org/) ont proposé, dans l'excellent papier
["_Build Systems à la Carte_"](https://dl.acm.org/doi/10.1145/3236774), une
collection d'abstraction pour réimplémenter — modulairement — des
_build-systems_ divers et variés. Cependant, pour certaines raisons liées à
**l'analyse statique des dépendances**, ces modèles n'étaient pas compatibles
avec Dune. Après plusieurs investigations et expérimentations, une nouvelle
construction, similaire à un
[Applicative](https://hackage.haskell.org/package/base-4.20.0.1/docs/Control-Applicative.html),
un [Selective Applicative Functor](https://dl.acm.org/doi/10.1145/3341694),
capturant les pré-requis de Dune a été proposée. Cette information peut sembler
anecdotique, mais, de mon point de vue, elle renforce l'intérêt (et
l'importance) d'être à **l'intersection entre la recherche et l'industrie**.

##### Alternatives

Bien qu'étant fortement adopté par la communauté, OCaml propose des systèmes
alternatifs (utilisant parfois Dune _sous le capot_), par exemple,
[Obazl](https://obazl.github.io/docs_obazl/) qui offre des règles OCaml pour
[Bazel](https://bazel.build/), [Onix](https://github.com/rizo/onix) qui permet
de construire des projets avec [Nix](https://nixos.org),
[Buck2](https://buck2.build/) qui est un projet ambitieux et générique qui est
en compétition avec Bazel et [Drom](https://github.com/OCamlPro/drom) qui offre
une expérience similaire à [Cargo](https://doc.rust-lang.org/stable/cargo/),
unifiant la gestion de paquets et la construction de projets. 

En toute transparence, je n'ai jamais expérimenté ces alternatives, étant très
satisfait de Dune et de la direction qu'il est en train de prendre, unifiant
enfin, la gestion des _constructions_ et des paquets !

#### LSP et Merlin pour les éditeurs

Dans les précédentes sections, nous avons pu voir à quel point OCaml à progressé
dans des domaines nécéssaires à l'industrialisation. Par contre, en terme de
support éditeur, OCaml dispose depuis plus de 10 ans d'un excellent support pour
[Vim](https://www.vim.org/) et [Emacs](https://www.gnu.org/software/emacs/) au
moyen du projet [Merlin](https://github.com/ocaml/merlin) qui fournit des
services d'éditeurs permettant de la **complétion**, du **diagnostique**, des
fonctionnalités de **navigation dans le code**, des outils liées à la
**déstructuration de valeurs**, à la **construction de valeur**, de la gestion
(et navigation) de **trous typés**, de la **recherche par polarité**, des
informations précises (avec contrôle de verbosité) sur **les types de valeurs**,
du **_jump-to-definition_** etc. 

Selon moi, le support IDE, via Merlin, est excellent, en OCaml, depuis très
longtemps. Couplé avec [ocp-indent](https://github.com/OCamlPro/ocp-indent), qui
permet de calculer la position du curseur après une action dans l'éditeur et
[OCamlformat](https://github.com/ocaml-ppx/ocamlformat), qui permet le formatage
(configurable) à la volée de document OCaml, écrire du code dans Emacs ou Vim
est un immense plaisir !

##### Avènement de VSCode, LSP comme standard

En 2015, [Visual Studio Code](https://en.wikipedia.org/wiki/Visual_Studio_Code)
est arrivé en amenant [Language Server
Protocol](https://en.wikipedia.org/wiki/Language_Server_Protocol) permettant
d'abstraire la manière dont les éditeurs interagissent avec un langage par le
biais d'un serveur, respectant protocole uniforme. OCaml dispose d'un [très bon
serveur LSP](https://github.com/ocaml/ocaml-lsp) qui, lui même, repose sur des
bibliothèques éprouvées de l'écosystème OCaml, notamment Merlin. Comme LSP est
devenu _relativement standard_ dans le monde des éditeurs (Vim, Emacs et, en
fait, presque tous les éditeurs libres que je connaisse) permettent d'interagir
avec un serveur LSP, il est question de déprécier le serveur de Merlin, pour ne
passer plus que par LSP, faisant de Merlin une bibliothèque _bas-niveau_,
fournissant l'outillage, sous forme de bibliothèque utilisée par LSP. C'est un
des projets sur lequel travaille l'équipe `Editeur`, chez
[Tarides](https://tarides.com) (dont je fais partie) : rendre `ocaml-lsp`
compatible en fonctionnalités, avec le serveur historique de Merlin pour réduire
la maintenance des clients alternatifs (Emacs et Vim), ne nous souciant plus que
des requêtes et actions spécifiques à OCaml (et ne faisant donc, logiquement,
pas partie du protocole).

Un peu comme pour Dune, l'état de l'outillage est, à mon sens, excellent, et la
feuille de route est motivante ! Cependant, comme c'est **mon travail**, il est
probable que je sois biaisé.

#### Odoc, le générateur de documentation

OCaml est distribué avec un générateur de documentation, le vénérable
[OCamldoc](https://ocaml.org/manual/5.2/ocamldoc.html), cependant, ce dernier
n'est plus recommandé par/pour la communauté. En effet, l'outil mis en avant est
[Odoc](https://ocaml.github.io/odoc/), un nouvel outil, qui vit en dehors du
compilateur et qui offre plusieurs fonctionnalités très intéressantes :

- un langage de _markup riche_, supportant les références croisées
- la possibilité d'écrire des pages "de manuel", volatiles, tout en bénéficiant
  des références croisées
- une très bonne intégration dans Dune
- une barre de recherche par types (implémentée via
  [Sherlodoc](https://doc.sherlocode.com/))
- l'inclusion du code source (rédigé dans la documentation ou des modules documentés)
- l'implémentation de _dérivers_ permettant de générer des grands ensembles de
  documentation (utilisé pour implémenter [la documentation de tous les paquets
  présents sur OPAM](https://ocaml.org/packages))
- le support de [_doctest_](https://en.wikipedia.org/wiki/Doctest) via
  [mdx](https://github.com/realworldocaml/mdx)
  
Même si le _look'n feel_ d'une documentation générée par Odoc, par défaut, est,
de mon point de vue, **largement superieur** de celle générée par OCamldoc, il
reste tout de même (_une fois de plus, de mon point de vue_) un peu de travail à
fournir sur l'UI pour que l'outil soit réellement **parfait** !

J'ai clairement une certaine sympathie pour la documentation du langage
[Elixir](https://elixir-lang.org/), [HexDoc](https://hexdocs.pm/) (en terme de
_design_ et de fonctionnalités), et à titre personnel, j'aimerais que OCaml
converge vers cet exemple. En revanche, il faut reconnaitre que la documentation
générée par Odoc est supérieure à beaucoup de documentation d'autres langages.

### Bibliothèques disponibles

On a vu que le langage était _cool_, et qu'il dispose d'un outillage, bien que
toujours en progrès, efficace et agréable à utiliser. Se pourrait-il que son
manque de popularité soit la conséquence d'un ensemble de bibliothèque trop
restreind ? Pour être très honnête, **je ne sais pas**. Ce que je sais, c'est
que quand j'ai eu à écrire des projets OCaml, professionnels comme personnels,
j'ai souvent trouvé tout mon bonheur dans la [liste des
paquets](https://ocaml.org/packages). Je pense que les raisons qui font que
OCaml est mature pour beaucoup de projets usuels peut se synthétiser en
plusieurs points :

- des entreprises comme [Lexifi](https://www.lexifi.com/) et
  [Janestreet](https://www.janestreet.com/) ont fortement contribué à
  l'écosystème en libérant beaucoup des bibliothèques nécéssaires à leurs usages
  quotidien
- Des projets de recherches ambitieux, comme, dans le cas du Web par exemple,
  [Ocsigen](https://ocsigen.org/home/intro.html), utilisé industriellement dans
  le projet [BeSport](https://www.besport.com) ont généré une collection de
  bibliothèques utiles
- Nous en parlions précédemment mais [MirageOS](https://mirage.io), dans son
  approche [_Clean
  Slate_](https://blog.container-solutions.com/all-about-unikernels-part-1-what-they-are)
  a, naturellement, engendré beaucoup de bibliothèques robustes
- Comme pour des langages populaires, comme JavaScript ou Rust, des
  contributeurs motivés ont fourni d'excellentes bibliothèques
- Le langage est ancien, et utilisé industriellement depuis bien longtemps
  
Pour ma part, il m'est arrivé de _re-créer_ des bibliothèques pour le **plaisir
de réinventer la roue**, mais aussi, parfois, pour proposer une interface
alternative. De plus, OCaml permet de s'interfacer avec, entre autres, du C,
permettant de construire des _bindings_ pour un grand nombre de bibliothéques et
outils. Cependant, s'il existe une bibliothèque que vous trouvez _objectivement_
manquante, je vous invite à prendre part à [la
communauté](https://ocaml.org/community).

Il est important de noter que mon usage de OCaml s'est porté essentiellement sur
3 sujets :

- **le développement web** (fortement porté par Mirage, Ocsigen et des projets
  indépendants, comme [Dream](https://aantron.github.io/dream/),
  [YOCaml](https://github.com/xhtmlboi/yocaml) et bien
  [d'autres](https://ocaml.org/packages/search?q=web))
- **le développement de [Blockchain](https://tezos.com/)** et par extension
  l'utilisation de bibliothèque de cryptographie, offertes, une fois de plus,
  par Mirage, mais aussi par le projet
  [HACL\*](https://github.com/hacl-star/hacl-star), une bibliothèque
  formellement vérifiée, écrite en [F\*](https://fstar-lang.org/) et extraite en OCaml
- **le développement de [Merlin](https://github.com/ocaml/merlin)**

Tous ces sujets impliquent tout de même la nécéssité d'un bon outillage de tests
et OCaml dispose de plusieurs bibliothèques complémentaires pour implémenter des
suites de tests robustes. En effet, dans l'écosystème OCaml on trouve de quoi
rédiger des [doctests](https://github.com/realworldocaml/mdx), des [tests
unitaires classiques](https://github.com/mirage/alcotest), de quoi décrire des
[tests dirigés par les propriétés](https://github.com/c-cube/qcheck), de quoi
faire [du _fuzzing_](https://github.com/stedolan/crowbar) mais aussi des [tests
par observation de la
sortie](https://dune.readthedocs.io/en/stable/tests.html#inline-expectation-tests),
des [tests
_inlines_](https://dune.readthedocs.io/en/stable/tests.html#inline-tests) (qui
permettent de tester, notamment, des composants privés) et des [tests
cram](https://dune.readthedocs.io/en/latest/reference/cram.html).

Je continue de trouver mon bonheur dans les paquets disponibles et je suis
toujours très impressionné de voir le nombre de paquets et d'alternative
croître, _d'année. en année_. Il existe évidemment des manques, mais qui n'ont
pas invalidés mon choix de OCaml.

#### Aparté sur la bibliothèque standard

Un reproche récurrent qu'il est fait à OCaml est la _modestie_ de sa
bibliothèque standard. En effet, _historiquement_, cette dernière ne servait
qu'a implémenter le langage. Elle ne s'ecombrait donc pas de certaines
fonctionnalités utiles pour l'utilisateur final. Cette situation a engendré
l'émergence de bibliothèques standards alternatives dont les plus populaires
sont :

- [Batteries](https://github.com/ocaml-batteries-team/batteries-included), une
  alternative à la bibliothèque standard _un peu datée_. Historiquement une
  _fork_ de [Extlib](https://github.com/ygrek/ocaml-extlib).
- [Base](https://opensource.janestreet.com/base/), une alternative construite
  par [Janestreet](https://janestreet.com) utilisée _un peu invasivement_ dans
  le livre [Real World OCaml](https://dev.realworldocaml.org/). La bibliothèque
  utilise des conventions forte, comme _labeliser_ les fonctions d'ordre
  superieur (généralement avec le nom `f`).
- [Core](https://opensource.janestreet.com/core/) est une extension de Base.
- [Containers](https://github.com/c-cube/ocaml-containers) est une extension de
  la bibliothèque standard (dans le sens où `open Containers` en début de module
  ne casse pas du code rédigé avec la bibliothèque standard).
  
Je n'ai pas d'opinion forte concernant le choix d'une bibliothèque alternative,
j'ai tendance à utiliser celle que mon projet utilise ou de _réinventer la roue_
(parce que c'est très rigolo), cependant, si je devais donner un avis, il est
probable que je recommande **Containers**.

En plus de ces bibliothèques standards alternatives, on trouve des bibliothèques
spécifiques qui résolvent des problématiques générales comme
[Bos](https://github.com/dbuenzli/bos) qui propose des outils pour interagir
avec un système d'exploitation ou encore
[Preface](https://github.com/xvw/preface) — _shameless plug_ — qui permet de
_concrétiser des abstractions issues de la théorie des catégories_.

La position des mainteneurs sur la bibliothèque standard à évolué au fil des
années et il est dorénavant envisageable de l'étendre. Cependant, les additions
dans cette dernière sont souvent sujettes à débat et l'addition de nouveaux
modules peut parfois prendre beaucoup de temps. Pour ma part, j'aurais préféré
que la bibliothèque standard **continue à ne servir que le développement du
langage** et qu'une bibliothèque sous l'ombrelle de la communauté OCaml soit
publiée. Cette séparation permet de désynchroniser les _releases_ du langage et
de sa bibliothèque standard et aussi, probablement, de simplifier la
compatibilité entre cette bibliothèque et le langage.

### Conclusion de l'écosystème

Je n'ai malheureusement pas l'occasion de parler de tous les outils de la
plateforme, ni des briques fondamentales qui font que OCaml est un langage
agréable à utiliser pour des projets personnels, mais aussi pour des projets
industriels (par exemple, des différents
[débogueurs](https://github.com/hackwaly/ocamlearlybird) existants). En
revanche, j'espère avoir survolé quelques outils, qui forment un socle solide
pour l'utilisation de OCaml.

Dans mon utilisation du langage, il m'est parfois arrivé de devoir construire ma
propre bibliothèque, cependant, ce n'est pas un exercice que je regrette et je
pense que, maheureusement, si l'on décide de ne jamais utiliser un langage parce
que 100% des bibliothèques nécéssaires ne sont pas disponibles, je trouve,
peut-être maladroitement que c'est **nivellement par le bas**, et que ça nous
enferme derrière des langages portés par des _entreprises riches_, comme Java ou
C# et **c'est un peu triste**.

## Sur la communauté

Même si j'ai utilisé beaucoup de langages de programmation différents, je pense
que OCaml est le seul avec lequel j'ai entretenu une interaction communautaire
forte. Je ne suis donc pas au courant de la manière dont les choses se passent
dans d'autres communautés, ce qui rend mon retour _un peu inutile_. Mais de mon
expérience, je trouve que la communauté OCaml, en plus d'être très productive,
est :

- **Très accessible** : comme beaucoup d'autres, OCaml dispose d'une [présence
  numérique forte](https://ocaml.org/community). Sur ces différents espaces, il
  est possible d'y retrouver des contributeurs au langage et à son écosystème
  très aguéris et de bénéficier de conseils pointus (ou moins). Je me permet
  d'adresser une mention particulière à [Gabriel Scherer](http://gasche.info) et
  [Florian Angeletti](https://perso.quaesituri.org/florian.angeletti) dont les
  réponses sont toujours élaborées et intéressantes.
  
- **Très bienveillante** : il m'arrive souvent d'avoir à demander de l'aide et
  j'ai toujours eu l'occasion d'avoir des réponses claires et précises, que ça
  soit en privé ou en public.
  
- **Très brillante** : OCaml est le fruit du travail de _chercheurs brillants_
  et avoir l'opprtunité d'interagir avec eux est incroyable (et potentiellement
  un peu intimidant). Avoir l'opportunité de poser, directement, des questions à
  des gens étant derrière certaines découvertes importantes de la construction
  de langage est une aubaine formidable.

Pour conclure sur le pan communautaire, même si je ne suis pas réellement aux
faits des interactions dans d'autres communautés, je trouve que c'est un plaisir
de faire partie de celle des développeurs et développeuses OCaml. C'est un
espace bienveillant, propice au partage et à l'apprentissage.

## Quelques mythes liés à OCaml

J'arrive — _enfin_ — à la partie la plus amusante de ce trop long article, je
vais pouvoir _debunker_ certains mythes persistants liés à OCaml. Je ne promet
toujours de bonne foi, mais sachez que mon intention est bonne. On lit souvent
sur les internets plusieurs critiques ou remarques à l'égard d'OCaml, et
souvent, je trouve qu'il est fatiguant d'y répondre. Cependant, quoi de mieux
qu'un article destiné à faire part de mon intérêt pour le langage pour prendre
le temps de survoler certaines de ses critiques et tâcher d'apporter une réponse
?

J'en ai sélectionné quelques-uns mais il est probable que dans le futur,
j'écrirais des articles un peu plus long, à la manière des membres de
[HeyPlzLookAtMe](https://www.heyplzlookat.me/articles/critique-de-la-raison-pure.gmi),
sur des articles que je trouve injustes.

### OCaml et F\#

[F\#](https://fsharp.org/) est un langage de programmation [historiquement très
inspiré](https://fsharp.org/history/hopl-final/hopl-fsharp.pdf) par OCaml qui
tourne sur la plateforme [.NET](https://dotnet.microsoft.com) (et s'interface,
_de facto_, très bien avec C\#). Je trouve le langage — que j'ai
professionnellement utilisé chez [DernierCri](https://derniercri.io/) et chez
[D-Edge](https://www.d-edge.com) — très agréable. Comme historiquement, .NET
était exclusivement réservé à des environnements Windows, OCaml souffrait peu de
la comparaison, cependant depuis l'arrivée de [.NET
Core](https://github.com/dotnet/core), une implémentation multi-plateforme de
.NET, il m'arrive de plus en plus de lire sur les internets, de phrases de ce
genre :

> Pourquoi continuer à faire du OCaml, quand on peut disposer du même langage,
> F\#, avec tout l'écosystème .NET, plus de fonctionnalités et une syntaxe plus
> agréable à utiliser.

Premièrement, je trouve que oui, bénéficier de l'écosystème .NET (Core) est un
énorme avantage. Concernant le syntaxe, je suis plus réservé. En effet, je
trouve que la syntaxe basé sur l'indentation rend parfois le déplacement de code
plus laborieux et même s'il existe des critiques à l'encontre de la syntaxe de
OCaml, je dois avouer qu'elle ne me fait pas défaut. Le dernier point me semble,
lui, un peu plus pernicieux. En effet, F\# s'est vu doté de fonctionnalités non
présentes dans OCaml, par exemple :

- les [expressions de
  calcul](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/computation-expressions)
  (qui sont une forme syntaxiquement plus générale que les [opérateurs de
  liaisons](https://ocaml.org/manual/5.2/bindingops.html))
- le [fournisseur de
  types](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/computation-expressions)
  (qui malheureusement ne fonctionne pas avec .NET Core)
- les [motifs
  actifs](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/active-patterns)
- [Paramètres de type résolus
  statiquement](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters)
- la possibilité d'attribuer des méthodes à des sommes et des produits, ce qui,
  pour des raisons d'interopérabilité a beaucoup de sens, mais casse notablement
  l'inférence
- et probablement d'autres fonctionnalités que je ne connais pas bien (ou liées
  à l'interopérabilité avec la plateforme .NET, notamment de la
  [réflexion](https://learn.microsoft.com/fr-fr/dotnet/fsharp/language-reference/attributes))
  
Ces évolutions sont arrivées progressivement dans le langage. Il serait naïf de
croire que OCaml n'a pas évolué lui aussi. En effet, bien que historiquement,
les deux langages semblaient très similaires, dès le début de la proposition de
F\#, certaines fonctionnalités étaient manquantes :

- l'absence d'un **langage de modules**. En effet, le mot-clé `module` est
  présent en F\#, cependant, ce dernier ne sert qu'a décrire des classes
  statiques (et se marie étrangement avec les espaces noms)
- Un modèle objet **drastiquement différent** (pour l'interopérabilité avec C#,
  évidemment)
  
Ces deux raisons, à elles seules, suffiraient de considérer OCaml et F# comme
deux langages _cousins_ mais **très différents** et motiveraient, selon moi,
très largement le fait de préférer l'un à l'autre. Dans mon cas, OCaml plutôt
que F# rendant la phrase d'introduction de la section caduc. Cependant, comme
F#, OCaml a aussi évolué et en plus de ces deux différences fondamentales, on
trouve beaucoup de choses en OCaml, absente dans F# :

- les ouvertures locales et
  [généralisées](https://ocaml.org/manual/5.2/generalizedopens.html). En effet,
  en F#, on ne peut ouvrir un module qu'en _top-level_, ce qui parfois peut être
  très iritant
- Du [row polymorphism](https://en.wikipedia.org/wiki/Row_polymorphism) sur les
  produits (via des objets) et sur les sommes (via des [variants
  polymorphes](https://ocaml.org/manual/5.2/polyvariant.html))
- Des [Types algébriques
  généralisés](https://ocaml.org/manual/5.2/gadts-tutorial.html) (probablement
  une des fonctionnalités, après le langage de modules, qui m'a le plus manqué)
- Des [Effets définis par
  l'utilisateur](https://ocaml.org/manual/5.2/effects.html)
- Des [sommes ouvertes](https://ocaml.org/manual/5.2/extensiblevariants.html),
  ce qui peut largement se simuler avec des objets et de l'héritage ceci-dit
  
Pour conclure, même si F# est un vraiment chouette langage, et que son usage
fait profiter de beaucoup d'avantages (notamment la plateforme .NET), ce n'est
pas _juste une meilleure version de OCaml_. Les deux langages sont très
différents et, de mon point de vue, OCaml dispose d'un système de types plus
sophistiqué, me faisant le préférer largement à F#. Et, à mon sens, dire que F#
est juste un OCaml plus beau est aussi recevable que de dire que
[Kotlin](https://kotlinlang.org/) n'est rien de plus qu'un
[Scala](https://www.scala-lang.org/) avec une syntaxe plus légère.

### Les opérateurs doublés pour les flottants

Dans la bibliothèque standard, on trouve les opérateurs arithmétiques sur les
entiers suivant :

```ocaml
val ( + ) : int -> int -> int
val ( - ) : int -> int -> int
val ( * ) : int -> int -> int
```

Mais aussi des opérateurs arithmétiques pour les nombres flottants :

```ocaml
val ( +. ) : float -> float -> float
val ( -. ) : float -> float -> float
val ( *. ) : float -> float -> float
```

Aux premiers abords, cela peut sembler déroutant. Cependant, c'est parfaitement
sensé. Si on voulait avoir des opérateurs génériques, il nous faudrait du
[polymorphisme ad-hoc](https://en.wikipedia.org/wiki/Ad_hoc_polymorphism), comme
c'est le cas en Haskell, par exemple, où les opérateurs arithmétiques résides
dans la classe `Num` :

```haskell
class  Num a  where
  -- more code
  (+), (-), (*) :: a -> a -> a
  -- more code
```

Sans forme de polymorphisme ad-hoc (via des classes, des traits ou des
implicites), permettant de décrire une contrainte sur nos opérateurs : `op ::
Num a => a -> a -> a` ? Une proposition que j'ai souvent lu sur internet serait
d'utiliser _la même triche_ que pour l'opérateur `=`, dont le type est `val
(=) : 'a -> 'a -> 'a`. Ça ne fonctionne pas, parce que alors que l'on peut
espérer que _tout soit compatable_ (dans le pire des cas, on peut renvoyer
`false`), comment généraliser, par exemple, une addition ?

Le support des opérateurs arithmétiques est un problème laborieux, qui est
d'ailleurs la motivation originale derrière les [classes de
types](https://en.wikipedia.org/wiki/Type_class) (et la raison d'être des
[Paramètres de type résolus
statiquement](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters)
en F#). De mon point de vue, _en attendant les [modules
implicites](https://www.cl.cam.ac.uk/~jdy22/papers/modular-implicits.pdf)_,
doubler les opérateurs pour fonctionner avec les entiers et les flottants me
semble être une proposition _raisonnable_ et, si pour d'étranges raisons,
suffixer les opérateurs par des points en présence de flottant vous donne de
l'urticaire, il est possible, au moyen d'ouvertures locales, de s'en passer en
fournissant, par exemple, ce module :

```ocaml
module Arithmetic (P : sig
  type t

  val add : t -> t -> t
  val sub : t -> t -> t
  val mul : t -> t -> t
  val div : t -> t -> t
end) =
struct
  let ( + ), ( - ), ( * ), ( / ) = P.(add, sub, mul, div)
end
```

Qui permet d'étendre les modules `Int` et `Float` (qui disposent déjà des
fonctions `add`, `sub`, `mul` et `div`) pour les provisionner d'opérateurs
arithmétiques :

```ocaml
module Int = struct
  include Int
  include Arithmetic (Int)
end
```

Dans les grandes lignes, on construit un module `Int`, on inclut le module `Int`
précédent, pour que notre nouveau module `Int` dispose de toute l'API du module
`Int` original, ensuite on construit (et on inclut) nos opértateurs
arithmétiques. On peut maintenant répéter l'opération avec `Float` :

```ocaml
module Float = struct
  include Float
  include Arithmetic (Float)
end
```

Et on peut maintenant se servir de l'ouverture locale pour ne pas devoir
suffixer nos opérateurs avec des points :

```ocaml
let x = Int.(1 + 2 + 3 + (4 * 6 / 7))
let y = Float.(1.3 + 2.5 + 3.1 + (4.6 * 6.8 / 7.9))
```

De mon point de vue, même si ça peut être déroutant quand on vient de languages
pour lesquels ce n'est pas une question, c'est un problème mineur, et il me
semble que l'absence de surcharge d'opérateurs est un argument un peu léger pour
ne pas donner sa chance à un langage, _mais ce n'est que mon humble avis_.

### Sur la séparation entre `ml` et `mli`

Un autre point qui fait couler beaucoup d'encre (encore
[récemment](https://discuss.ocaml.org/t/has-there-been-a-syntax-proposed-for-combining-mli-into-ml/15163))
porte sur la **séparation entre `ml` et `mli`**. Pour ma part, je trouve ça
génial, même si ça peut engendrer une légère forme de répétition, je peux me
concentrer sur l'API, via l'encapsulation, de mon module côté `mli` tout en
décrivant de la documentation, ça me permet d'ordonner les fonctions que
j'expose dans l'ordre qu'il me plait et, naturellement, ça me fait abstraire au
maximum les types que je partage. De plus, si je consulte une implémentation, le
code du `ml` est rarement pollué par de la documentation et je peux rapidement
naviguer dans les différentes éléments qui consistuent le module que j'observe.
En plus ça rend la compilation séparée possible et permet de ne pas recompiler
des modules qui dépendent de modules dont seul l'implémentation a été modifiée
en développement (c'est le comportement par défaut de Dune dans le profile
`dev`).

Cependant, les goûts et les couleurs ne sont pas vraiment discutable et quand on
expose des types complexes ou des types de modules, cette répétition peut être
ennuyante. Heureusement, il existe une _astuce_, présentée en 2020 par [Craig
Ferguson](https://www.craigfe.io), qui permet de palier à ces répétitions : [The
`_intf_` trick](https://www.craigfe.io/posts/the-intf-trick).

En plus, il existe des petites astuces, basées sur la possibilité de passer des
expressions de modules arbitraires aux primitives `open` et `include` qui
permettent, parfois, de se passer `mli`. J'en avais déjà parlé dans l'article
[OCaml, modules et schémas d'importation](/pages/modules-import.html).

#### Gérer l'encapsulation sans `mli`

On peut simplement utiliser `open struct (* code privé *) end` pour ne pas
exporter des parties codes sans nécéssiter d'interfaces. Par exemple :

```ocaml
open struct
  (* Private API *)
  let f x = x
  let g = _some_private_stuff
end

(* Public API *)
let a = f 10
let b = g + 11
```

#### Exprimer l'interface depuis le `ml`

Une autre technique similaire consiste à utiliser `include (struct ... end : sig
(* API publique *) end)` pour permettre de décrire la structure et l'interface
dans le même fichier. Par exemple :

```ocaml
include (struct 
  type t = int
  let f x = x
  let g = _some_private_stuff
end : sig 
  type t
  val f : int -> t
end)
```

De cette manière, la signature et la structure vivent dans le même fichier, tout
en permettant de contrôler précisemment l'encapsulation. Une autre approche
consisterait à sortir la signature dans un `module type` dédié, de cette manière
:

```ocaml
module type S = sig
  type t
  val f : int -> t
end

include (struct
  type t = int
  let f x = x
  let g = _some_private_stuff
end : S)
```

C'est très similaire à la première proposition, si ce n'est que le module expose
aussi le type de module `S`. L'effet de bord bénéfique de ce _leak_ est que l'on
peut facilement référencer la signature du module en utilisant `My_mod.S` plutôt
que de devoir utiliser `module type of My_mod`.

#### Pour conclure sur la séparation

Je trouve que cette séparation est **très désirable**, cependant, le langage de
module de OCaml étant très expressif, il est possible, au moyen d'un peu
d'encodage, de pallier à cette séparation. De mon point de vue, ces approches
servent essentiellement à démontrer cette _expressivité_ parce que le
contre-coup de ce regroupement est la perte de la compilation séparée, ce que je
trouve sacrément balot.

# Pour conclure

Je pense avoir _sommairement_ survolé les points que je voulais développer. De
mon point de vue, **OCaml est un langage génial** ! En effet, il offre un très
bon compromis entre la sûreté et l'expressivité notamment grâce à un système de
type très avancé, un langage de modules riche, des objets, le support de _row
polymorphism_ au moyen d'objets et de variants polymorphes et le support
d'effets définis par l'utilisateurs ! Son intersection entre la recherche et
l'industrie en font un langage qui, de mon point de vue, évolue dans la bonne
direction, en intégrant précautionneusement de nouvelles fonctionnalités
permettant au langage de rester moderne, sans subir les éceuils d'une
intégration trop rapide et non éprouvée.

Même si pendant plusieurs années, l'outillage de OCaml pouvait sembler un peu
... _poussiéreux_, ces derniers temps, notamment grâce au support commercial de
certaines entreprises, l'outillage s'est drastiquement modernisé, et continue
son progrès comme le témoigne [la feuille de route de la
plateforme](https://ocaml.org/tools/platform-roadmap). En complément, l'ensemble
des bibliothèques disponibles progresse permettant d'utiliser OCaml dans une
multitude de contexte, notamment grâce à ses différentes cibles de compilation
(par exemple le navigateur via
[js\_of\_ocaml](https://github.com/ocsigen/js_of_ocaml) et
[wasm\_of\_ocaml](https://github.com/ocaml-wasm/wasm_of_ocaml)).

En ajoutant à un langage expressif, doté d'un écosystème versatile, une
communauté bienveillante et réactive, OCaml devient un choix très sérieux pour
des projets personnels et professionnels. Il est évident que proposer une
migration complète d'une base de code pour aller vers OCaml n'est probablement
pas un choix pragmatique, mais si vous avez des petits projets personnels en
tête et que vous êtes curieux et amusés par les langages de programmation, **je
vous invite sérieusement à considérer OCaml** !

J'espère avoir réussi à transmettre mon intérêt pour ce langage (et son
écosystème). Si vous désirez en parler, trouver des projets ou des points de
contributions, je serais ravi d'en parler avec vous, ou alors vous pouvez vous
adresser à la communauté par le biais [du forum](https://discuss.ocaml.org/) qui
est actif, réactif et bienveillant !
