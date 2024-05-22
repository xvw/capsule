---
title: Sur le choix de OCaml
creation_date: 2024-05-07
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
  - name: Notes
    href: /programming.html#index-notes
  - name: Opinions
    href: /opinions.html
---

Dans ce _billet d'opinion_, je vais essayer de présenter brièvement ma rencontre
avec le langage, et d'énumérer ses avantages — répartis en plusieurs rubriques
portant sur _le langage lui-même_, son écosystème et sa communauté. Je tâcherai
également de démystifier certains mythes (ou idées reçues) populaires sur
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
avant, grâce au [Site du Zéro]((http://sdz.tdct.org/)), où une petite communauté
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
  Effect.perform (Print_endline ("Hello " ^ name)
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
  évidemment, sur la propagation des effets dans le système de types.
  
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
  pile technologique est **très formatteur**, ça modifie l'ensemble des
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
  
- Sa **platforme**. Est-ce que l'ensemble de sa _chaine d'outillage_ est
  complète et ergonomique. Ce qui inclut, de mon point de vue, un gestionnaire
  de paquet, un _build-system_, un bon _support éditeur_ (agnostique au
  possible), un bon générateur de documentation et une collection d'outils
  additionnels, comme, par exemple, un _formatteur_ (et bien d'autres).
  
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




## Concernant les performances
