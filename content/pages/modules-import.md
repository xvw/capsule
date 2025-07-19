---
page_title: OCaml, modules et schémas d'importation
description:
  Utilisation du langage de modules et des ouvertures pour reproduire des schémas
  d'importations usuels dans d'autres langages
tags: [programmation, ocaml, modules]
section: programmation
published_at: 2023-10-31
display_toc: true
breadcrumb:
  - title: Programmation
    url: /programming.html
  - title: Bribes & Encodages
    url: /programming.html#index-bribes-and-encodages
synopsis:
  Le langage de modules de [OCaml](https://ocaml.org) peut être intimidant, et 
  il implique généralement l'utilisation de beaucoup de mots-clés, 
  par exemple `open` et `include` qui  permettent d'importer des définitions 
  dans un module. Depuis la version `4.08` du langage, la primitive `open` a été 
  _généralisée_ pour permettre l'ouverture **d'expression de module arbitraire**.
  Dans cet article, nous allons observer comment utiliser cette généralisation
  pour reproduire une pratique commune dans d'autres langages,
  que j'appelle, _un peu pompeusement_, des stratégies d'importation, 
  décrivant, par exemple, ce genre de d'importation `import {a, b as c} from K`
  sans dépendre d'un langage dédié à l'importation.
---


La généralisation des ouvertures a été documentée dans le papier
["_Extending OCaml's_
`open`"](https://www.cl.cam.ac.uk/~jdy22/papers/extending-ocamls-open.pdf),
présenté au [OCaml Workshp
2017](https://ocaml.org/workshops/ocaml-users-and-developers-workshop-2017),
et implémenté — pour la version `4.08` de OCaml — via les soumissions
[`#1506`](https://github.com/ocaml/ocaml/pull/1506) et
[`#2147`](https://github.com/ocaml/ocaml/pull/2147) (adjoint,
probablement, de quelques correctifs suivant la fusion de
l'implémentation). Cette généralisation augmente grandement la
flexibilité du terme `open`, rendant possible la mise en place de
quelques astuces pour contrôler finement l'importation de _composants
de modules_ dans un autre module.

> Certaines des astuces présentées sont reprises telles qu'elles du
> papier qui, en plus de présenter les stratégies d'implémentations,
> présente quelques cas d'usages (dont certains n'étant pas pertinents
> dans le cadre de cet article car ils ne concernent pas les
> stratégies d'importations).

Il est probable qu'une grande partie des _astuces_ présentées ne
deviennent pas _idiomatiques_ dans les bases de code OCaml. Selon moi,
leur présentation met essentiellement en lumière l'accroissement de
flexibilité de la primitive `open` sans devoir se reposer sur une
**extension gramaticale spécifique** dédiée à l'importation de
composants, tout en présentant quelques encodages un peu
_capilotractés_ ... pour le plaisir de la démonstration.

## Importation de composants de modules


Quand on décrit un programme OCaml, on construit des collections de
modules qui exportent des composants (des types, des _sous-modules_,
des exceptions et des fonctions). Il est donc crucial de contrôler
finement leurs accessibilités depuis d'autres modules, pour cela, on
dispose de deux primitives — `open` et `include` — dont la différence
est subtile. Pour décrire correctement les différences entre les deux
primitive, nous allons nous baser sur ce module (un peu artificiel)
que nous utiliserons dans les exemples qui suivent :

<div class="side-by-side">

```ocaml
module A = struct
  type a = T_a
  let a_a = 1
  let a_b = T_a
  module B = struct
    type b = T_b
    let b_a = T_b
    let b_b = T_a
  end
end
```

```ocaml
module A : sig
  type a = T_a
  val a_a : int
  val a_b : a
  module B : sig
    type b = T_b
    val b_a : b
    val b_b : a
  end
end
```
</div>


Comme vous pouvez le remarquer, l'implémentation — et _de facto_, la
signature — du module n'est pas très intéressant, il ne servira qu'a
illustrer mon propos.  Ce que l'on voudra, c'est utiliser, dans un
fichier `c.ml` (qui dénotera le module `C`), les composants décrits
dans `A`.

La première approche, et la plus évidente, est d'utiliser leurs noms
complets (un appel **totalement qualifié**) en utilisant le **chemin**
du module. Par exemple, créons un couple de `int` et de `A.a` :

```ocaml
let c_a = (A.a_a, A.B.b_b)
```

Par contre, il arrive que le fait d'utilisé les chemins complets
puisse être _rébarbatif_ (voire totalement illisible). C'est pour ça
que nous allons voir comment **importer les composants du module `A`
dans le module `C`**. Cependant, comme le but de l'article n'est pas
d'être un didacticiel sur l'ouverture et l'inclusion, mais d'explorer
les ouvertures généralisées pour décrire des schémas d'importations,
nous ne nous étendrons pas sur ces deux fonctionnalités qui sont déjà
fortemment décrites dans le [manuel du
langage](https://v2.ocaml.org/releases/5.1/htmlman/index.html) — dans
les sections dédiées [aux
modules](https://v2.ocaml.org/releases/5.1/htmlman/moduleexamples.html),
[à la surcharge liée aux
ouvertures](https://v2.ocaml.org/releases/5.1/htmlman/overridingopen.html)
et [aux ouvertures
généralisées](https://v2.ocaml.org/releases/5.1/htmlman/generalizedopens.html).


### Ouverture de modules

La primitive `open` permet _d'importer_ les composants d'un module
dans un autre module, **sans re-exporter** ces dernières dans le
module courant. Par exemple, utilisons `open` pour réécrire la
fonction `c_a` :

<div class="side-by-side">

```ocaml
open A

let c_a = (a_a, B.b_b)
```

```ocaml
val c_a : int * A.a
```
</div>


Comme on peut le voir dans la signature (inférée), **n'exporte pas**
les _composants_ du module `A` et référence le type `a` par son chemin
complet. Il serait aussi possible d'ouvrir `A.B` en utilisant `open
A.B` ou encore `open B` (car `A` est déjà ouvert).

De la même manière qu'il est possible d'ouvrir des modules dans
_l'implémentation_, il est aussi possible d'ouvrir des modules dans
_la signature_, permettant de réduire le chemin pour décrire des types
(ou des modules).


#### Ouverture locale de modules

Les cas d'ouvertures que nous avons observés précédemment étaient
**globales** au module dans lequelle elles étaient invoquées, ce qui
peut être un peu contraignant quand on veut ouvrir plusieurs modules —
exposant, par exemple, des opérateurs arithmétiques. Heureusement, il
est possible d'ouvrir **au niveau de l'expression**, de deux manières
différentes :

- `let open Module in ...` où dans l'expression suivant ce bloc — donc
  lexicalement borné — `Module` sera ouvert _localement_. Ce qui est
  très utile pour n'ouvrir un module que dans une fonction ;
  
- `Module.(...)` où `Module` ne sera ouvert — lexicalement borné aussi
  — uniquement entre les parenthèses. Ce qui est très utile pour
  n'ouvrir un module que dans une expression, par exemple, imaginons
  que le module `Float` expose un module `Infix`, exposant les
  opérateurs arithmétiques usuels pour l'arithmétique, il serait
  possible de décrire une opération entre des
  flottants de cette manière :  
  `let x = Float.Infix.(1.2 + 3.14 + 1.68)`.

L'absence d'ouverture locale peut être très handicapant. Par exemple,
le langage [`F#`](https://fsharp.org/) ne permet que des [ouvertures
globales](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/import-declarations-the-open-keyword)
ce qui rend la définition d'opérateurs dans un module dédié
laborieuse, préconisant l'utilisation de [surcharge
d'opérateurs](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/operator-overloading)
(ou encore de [Statically Resolved Type
Parameters](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters))
engendrant parfois beaucoup de complexité.


### Inclusion de modules

La primitive `include` ressemble très fort à la primitive `open` sauf
qu'elle — comme son _nom_ l'indique — inclus le contenu du module
ciblé dans le corps du module où elle est appelée. Par exemple, si
nous avions utilisé `include` au lieu de `open` dans notre exemple
précédent, observons l'incidence sur la signature inférée :

<div class="side-by-side">

```ocaml
include A

let c_a = (a_a, B.b_b)
```

```ocaml
type a = A.a = T_a
val a_a : int
val a_b : a
module B = A.B
val c_a : int * A.a
```
</div>

Même si la signature _varie légèrement_ de celle que nous avions
définie en introduction — il y a quelques subtilités concernant les
propagations **d'égalités de types et de modules**, décrites dans la
section ["Recovering the type of a
module"](https://v2.ocaml.org/releases/5.1/htmlman/moduletypeof.html),
liées au
[renforcement](https://discuss.ocaml.org/t/extend-existing-module/1389/7)
— on peut observer que le contenu du module `A` a été _inclus_,
_ajouté_ au module `C`. Au contraire de l'ouverture, il n'est **pas
possible de faire de l'inclusion locale**, ce qui est parfaitement
logique parce que **de l'inclusion au niveau local aurait exactement
le même effet qu'une ouverture**.


De mon expérience personnelle, je retire généralement deux cas d'usages
spécfiques à l'utilisation de `include` :

- l'extension d'un module existant (par exemple, ajouter une fonction
  au module `List` dans le cadre de mon projet, ou pour faire une
  extension à la bibliothèque standard) ;
  
- l'inclusion de sous-modules dans un module parent. Par exemple, il
  est assez courant que dans un module, on retrouve des opérateurs (où
  des [opérateurs de
  liaison](https://v2.ocaml.org/releases/5.1/htmlman/bindingops.html#start-section))
  qu'il est assez courant de _confiner_ dans des sous-modules dédiés
  (généralement `Infix` et `Syntax`). Pour des raisons d'API, les
  re-exporter au niveau du _module mère_ peut être une bonne
  idée. C'est d'ailleurs [intensivement utilisé dans
  Preface](https://github.com/xvw/preface/blob/master/lib/preface_specs/indexed_functor.mli#L72).

Les inclusions sont un outils puissant d'extension, mais aussi du
mutualisation de code et il y a **beaucoup à dire** car ça peut
souvent impliquer la présence de _substitution_, _substitution
déstructive_ ou de renforcement, ce qui impliquerait la rédaction d'un
article dédié !


### Ouverture VS inclusion avant OCaml `4.08`

Avant la fusion de la proposition de la **généralisation des
ouvertures**, il existait une différence **sensible** dans l'usage des
`open` contre `include` : le paramètre que prenait les deux
primitives.

- `open` prenait [un chemin de
  module](https://v2.ocaml.org/releases/4.07/htmlman/names.html#module-path),
  par exemple : `A` ou encore `A.B.C`
  
  
- `include` prenait [une expression de
  module](https://v2.ocaml.org/releases/4.07/htmlman/modules.html#module-expr),
  par exemple : des chemins comme `A` ou `A.B.C`, mais aussi des
  applications de foncteurs comme `F(X)`, des modules contraints par
  des signatures : `(M : S)` ou directement le corps d'un module :
  `struct ... end`.
  
Cette différence de flexibilité impliquait l'utilisation de détours
assez génants pour atteindre le même niveau d'expressivité pour les
ouvertures en comparaison aux inclusions. En effet, pour permettre aux
ouvertures de composer avec des applications de foncteurs ou des
contraintes, il fallait passer par des modules intermédiaires.

Dans le cas de l'utilisation d'un chemin, les deux appels sont — en
terme d'expressivité — identiques, parce qu'un chemin peut aussi être
une expression de module :

<div class="side-by-side">

```ocaml
include A.B.C
```

```ocaml
open A.B.C
```
</div>

Par contre, dès que l'on essaie d'ouvrir des cas un peu plus
complexes, nativement supportés par `include`, on devait rapidement
introduire des modules intermédiaires :

<div class="side-by-side">

```ocaml
include F(X)
include (M : S)
include struct
  let x = 10
end
```

```ocaml
module A = F(X)
open A

module B : S = M
open B

module C = struct
  let x = 10
end
open C
```
</div>

Même si, aux premiers abords, ça peut ne pas sembler dramatique,
l'introduction de modules intermédiaires impose de ne pas les exporter
dans la signature du module qui les ouvres (dans son `mli` ou sa
signature). En complément, alors que `open` et `include` sont souvent
présentés symétriquement, on ne pouvait que déplorer leur absence de
symétrie dans les paramètres qu'ils prenaient.  Heureusement, depuis
`4.08` (qui a tout de même été **libérée en Juin 2019**), grâce à la
généralisation des ouvertures, `open` prend maintenant une expression
de module arbitraire, exactement comme `include`, nous permettant de
l'utiliser pour mimer ces fameux schémas d'importation, évoqués en
introduction de cet article.

### Un premier bénéfice

Le fait que la primitive `open` puisse prendre des expressions de
modules arbitraires offre un premier bénéfice — _probablement futile
quand on aime écrire les signatures de ses modules_ : **la définition
d'expressions locales**.  En effet, l'ouverture d'un module n'exporte
pas son contenu, il est donc possible de décrire très facilement des
valeurs _top-level_ non-exportée en les définissant dans une
expression `open struct ... end`. Par exemple :


<div class="side-by-side">

```ocaml
open struct
  let x = 10
  let y = 20
end
let z = x + y
```

```ocaml
val z : int
```
</div>

Les fonctions `x` et `y` sont **confinées dans une ouverture**, elles
ne sont donc pas exportées, ce qui peut être très utiles quand on veut
définir des valeurs (des types ou des modules) localement. De plus
comme **une structure peut être contrainte par une signature**, il est
aussi, par exemple, possible d'encapsuler un état mutable partagé dans
l'ouverture locale, **ne s'échappant pas du périmètre de son
ouverture**. Voici deux exemples dans lesquels il est impossible de
modifier la cellule de référence sans passer par les _combinateurs
exportés_, le premier utilisant une contrainte, le second en utilisant
des ouvertures locales imbriquées :

<div class="side-by-side">

```ocaml
open (
  struct
    let cell = ref 0
    let incr () = cell := !cell + 1
    let decr () = cell := !cell - 1
  end :
    sig
      val incr : unit -> unit
      val decr : unit -> unit
    end)
```

```ocaml
open struct
  open struct 
    let cell = ref 0 
  end
  let incr () = cell := !cell + 1
  let decr () = cell := !cell - 1
end

```
</div>

Même si l'approche classique utilisée par un développeur OCaml est
d'utiliser des signatures pour des problématiques **d'encpasulation**,
utilisée comme telle, l'ouverture généralisée de modules permet de
cacher, de manière relativement élégante, certains _éléments de
plomberies_ nécéssaires à la construction d'un module (qui lui,
devrait exposer une API publique au moyen d'une signature).

Maintenant que nous avons observé _des exemples_ d'utilisation de
l'ouverture généralisée, voyons de quelle manière elle rend la
présence d'un langage dédié aux schémas d'importations
**discutablement utiles**.


## Schémas d'importation

Depuis que la **modularité** est devenue un des cheveaux de bataille
de la conception de logiciels — JavaScript a d'ailleurs [empilé les
propositions](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)
en faisant dépendre la stratégie de modularisation, et d'importation,
du _cadriciel_ ou du système de construction utilisé — les langages
(comme [Python](https://www.python.org/) ou encore
[Haskell](https://www.haskell.org/)) ont proposé des fonctionnalités
similaires à la primitive `open` de OCaml pour importer des composants
dans le module courant. Généralement, ces directives d'importation
sont _un tout petit langage à part entière_, régit par ses propres
règles et sa propre grammaire. Depuis que `open` est généralisé, on
peut _encoder_ une grande partie des constructions d'importation
usuelles — même si nous verrons que certaines, proposées par Haskell,
peuvent être un peu verbeuse à encoder.

Pour l'exemple, nous utiliserons le module suivant comme cible
d'importation :

```ocaml
module Foo : sig
  val x : int
  val y : string
  val z : char
end
```

Il existe cependant une **nuance essentielle** sur la notion
**d'importation qualifiée**, en effet, en Haskell, pour être utilisé,
un module **doit être importé**, alors qu'en OCaml, c'est la
description du schéma de compilation qui indique la présence ou non
d'un module. Dans nos différents exemples, nous supposerons que le
module `Foo`, que nous avons décrit précédemment, est présent dans
notre schéma de compilation. De ce fait, pour les importations
qualifiée — où les termes sont toujours préfixées par leur cheminm de
module, il n y a aucune cérémonie aditionnelle nécéssaire. Il est
importer de garder à l'esprit que les astuces présentées ci-dessous
peuvent se composer pour construit des schémas d'importations très
spécifiques (et probablement irréalistes), démontrant que, au coup
d'un peu de verbosité, l'approche _langage_ permet encore plus de
flexibilité qu'un _DSL_ dédié à l'importation rigide.


### Importation non-qualifiée

La première directive consiste simplement à importer les définition de
`Foo` dans le module courant, les fonctions `x`, `y` et `z` :


<div class="side-by-side">

```haskell
import * from Foo
```


```ocaml
open Foo
```

</div>

Il n y a pas de subtilité, importer toutes les termes exposés par
`Foo` consiste simplement à l'ouvrir. Il n y a pas grand chose à dire
de plus, on ne tire ici partit d'aucune subtilité du langage.


### Qualification renommée

Une autre directive commune consiste à renommer le module, par
exemple, importer `Foo` sous le nom `Bar` en rendant accessible dans
le module `Bar.x`, `Bar.y` et `Bar.z`, pour cela, on peut utiliser
[alias de module
_type-level_](https://v2.ocaml.org/releases/5.1/htmlman/modulealias.html).


<div class="side-by-side">

```haskell
import Foo as Bar
```


```ocaml
open struct module Bar = Foo end
```

</div>

On utilise la construction `open struct ... end` pour ne pas échapper
notre alias dans l'API publique de notre module — même si, en présence
d'une signature, cette coquetterie n'est pas nécéssaire car il suffit
de ne pas exporter le module `Bar` dans la signature.


#### Présence du module renommé

Le fait d'utiliser un **alias de module** laisse le module `Foo`
accessible, et dans certains cas, on voudrait le rendre
inaccessible. La solution la plus simple est de simplement _vider le
module_ et pour clarifier l'erreur lié à son utilisation non-désirée,
on peut ajouter une
[alerte](https://v2.ocaml.org/releases/5.1/htmlman/alerts.html#start-section)
indiquant que le module a été supprimé :


```ocaml
open struct
  module Bar = Foo
  module Foo = struct end [@@alert erased]
end
```

Rendant l'exploitation du module `Foo`, dans le module courant,
impossible.  Cependant, comme il est d'usage de fournir des signatures
de modules — et donc d'en contrôler son API publique, on trouvera plus
régulièrement des renommages de cette forme : `module Bar = Foo`. De
plus, je ne suis pas convaincu que l'interdiction d'accès au module
original soit réellement un problème.


#### Renommage imbriqué

On pourrait imaginer ce genre de renommage : `import Foo as Bar.Baz`,
mais OCaml ne permet pas de décrire des chemins complets de cette
forme `module Bar.Baz = Foo`, il faut donc décrire la hiérarchie
d'imbrication des modules, de cette manière, rendant les fonctions
`Bar.Baz.x`, `Bar.Baz.y` et `Bar.Baz.z` disponibles dans le module
courant :


```ocaml
open struct 
  module Bar = struct 
    module Baz = Foo 
  end 
end
```


Ce qui est, je vous l'accorde, un peu verbeux, mais si pour des
raisons obscures, vous voudriez renommer un module existant avec un
chemin composé, vous pouvez, en déclarant la hiérarchie des modules.


### Importation sélective

Il arrive parfois que l'importation **complète** du module soit
excessive et que l'on ne voudrait que quelques composants exposés par
ce dernier. C'est pour ça qu'il est possible de n'importer qu'une
partie d'un module. Dans cet exemple, ne nous voudrions n'importer que
`x` et `y` :

<div class="side-by-side">

```haskell
import {x, y} from Foo
```


```ocaml
open struct
  let x = Foo.x
  let y = Foo.y
end
```

</div>


Même si cette approche est, elle aussi, un peu verbeuse, elle
n'importe, dans le module courant, que les fonctions `x` et `y`. Il
est possible de simplifier cette écriture en utilisant des _n-uplet_
et des ouvertures locales :

```ocaml
open struct
  let (x, y) = Foo.(x, y)
end
```

Sinon, il est aussi possible de **contraindre l'ouverture** au moyen
d'une signature, ce qui implique de devoir le type des fonctions à
exporter :

```ocaml
open (Foo : sig
  val x : int
  val y : string end)
```

Plusieurs propositions
([`#10013`](https://github.com/ocaml/ocaml/pull/10013) et
[`#11558`](https://github.com/ocaml/ocaml/issues/11558#issuecomment-1255946104))
ont été faites pour permettre d'utiliser du
[_let-punning_](https://v2.ocaml.org/releases/5.1/htmlman/bindingops.html#ss%3Aletops-punning)
rendant la syntaxe moins lourde, cependant dans la première a été
délestée du _punning_ pour les membres de modules et la seconde est
toujours au stade de l'issue.


#### Importation sélective avec renommage

Comme les deux premières propositions laissent à l'utilisateurs un
contrôle sur le nom (ce n'est que de la _redéfinition_ de fonction),
on peut trivialement intégrer le renommage. Dans cet exemple, on
expose `x` et `new_y_name`, qui appelle `Foo.y` :

<div class="side-by-side">

```haskell
import {x, y as new_y_name} from Foo
```


```ocaml
open struct
  let (x, new_y_name) = Foo.(x, y)
end
```

</div>

Sans surprise, le renommage est assez simple, par contre, si l'on
voulait utiliser l'approche par signature, il faudrait utiliser un peu
plus d'astuce en couplant une ouverture et une inclusion :

```ocaml
open (struct
    include Foo
    let new_y_name = y
  end : sig
    val x : int
    val new_y_name : string end)
```

Cependant, cette dernière proposition est tellement verbeuse qu'elle
en devient un peu irrationnelle — surtout en comparaison avec la
précédente — que j'imagine que c'est le genre de code que l'on ne
verra jamais — ou du moins, que l'on ne voudrait jamais voir — dans
une base de code régulière. En revanche, même si la proposition est
lourde, je trouve qu'elle montre tout de même assez explicitement
comment **il est possible de composer les différentes constructions et
outils vu précédemment**.


### Importation par exclusion

Haskell possède un modificateur d'importation un peu particulier dont
j'ai longuement hésité à parler parce que je n'avais aucune idée de
comment l'implémenter, mais c'était sans compter, une fois de plus,
sur l'inestimable aide de [@octachron](https://github.com/Octachron)
et de [@xhtmlboi](https://github.com/xhtmlboi) qui m'ont tout deux
donné, _approximativement_, la même solution . Ce modificateur permet
d'importer tout un module, excepté une liste de composant. Dans cet
exemple, `x` et `y` seront importé parce que l'on importe **tout le
module `Foo`**, excepté la fonction `z`.

```haskell
import Foo hidding (z)
```

OCaml ne dipose pas, nativement, la possibilité de construire des
**intersections** ou des **différences** de modules. La solution
proposée par [@octachron](https://github.com/Octachron) et
[@xhtmlboi](https://github.com/xhtmlboi) repose sur de la réecriture
de fonction, adjoint à l'utilisation d'une alerte, d'une manière un
peu similaire à ce que nous avions fait pour évincer un module
renommé. Par contre, avant d'observer la solution proposée, faisons un
petit détour par le variant vide.


#### Le type somme vide

En OCaml, il est possible de définir un type somme qui ne contient
aucun constructeur, en utilisant [**le variant
vide**](https://v2.ocaml.org/releases/5.1/htmlman/emptyvariants.html#start-section)
et qui permet, dans les grandes lignes, de _décrire des valeurs non
représentables_. Pour le définir, il suffit de construire une somme
avec une branche vide (qui, **attention**, n'est pas le [type
bottom](https://en.wikipedia.org/wiki/Bottom_type), noté `⊥`) :


```ocaml
type empty = |
```

Pour se convaincre que le compilateur peut réfuter les cas contenant
une valeur de type `empty`, on peut très facilement l'expérimenter
avec de la correspondance de motifs, dans l'exemple qui suit, le
compilateur ne lève aucun avertissement car les motifs sont
exhaustifs. Comme il n'est pas possible de construire une valeur de
type `empty` (sauf en trichant, en utilisant, par exemple de la
sorcellerie comme l'inénarrable fonction `Obj.magic`), on peut
_réfuter_ le traitement du cas d'erreur :


```ocaml
let f : ('a, empty) result -> 'a = function
  | Ok x -> x
```

Mais dans notre cas d'usage, ce n'est pas la réfutation qui va nous
intéresser mais plutôt le fait qu'il n'est pas possible de décrire une
valeur de type `empty` pour permettre l'éviction de fonctions.


#### Suppression de fonctions

La solution qui m'a été proposée consiste à rendre les fonctions que
l'on veut expulser du module **impossible à appeler**. Pour ça, nous
allons d'abord créer une fonction _placeholder_ que nous utiliserons
pour écraser une fonction existante :

```ocaml
type empty = |
let expelled : empty -> unit = fun _ -> ()
```

A priori, notre fonction `expelled` est impossible à appeler car on ne
peut la provisionner d'une valeur de type `empty`, cette dernière
étant impossible à produire. Nous allons donc pouvoir **inclure le
module que l'on veut refiner** et ensuite **substituer les fonctions
que l'on veut exclure** avec notre fonction `expelled`, et nous les
associerons à une alerte pour clarifier l'erreur que l'utilisation
d'une fonction évincée produira :

```ocaml
open struct
  include Foo
  let (z [@alert expelled]) = expelled
end
```

_Et voila_, on peut être à peu près sûr que l'utilisation de `z`
provoquera une erreur de compilation, et la compilation d'un module
qui l'exploite soulèvera un avertissement. En revanche, la solution
est loin d'être parfait car elle **n'élimine pas** le composant du
module. Pour être très honnête, j'ai **très rarement** eu l'occasion
de regretter l'absence de cette fonctionnalité, nativement. De mon
point de vue, l'importation sélèctive suffit généralement largement.


## Ancrages de types

Avant de conclure cet article,
[@octachron](https://github.com/Octachron) m'a pointé du doigt
l'asymétrie partielle entre `open` et `include` en présence de modules
anonymes (donc d'expression de modules `struct ... end`), c'est un
problème auquel j'avais déjà été confronté théoriquement car j'avais
assisté à l'événement de [Mai
2023](https://www.meetup.com/ocaml-paris/events/292972153) du [OCaml
Users in Paris](https://oups.frama.io/) où [Clément
Blaudeau](https://clement.blaudeau.net/), dans sa présentation
[_Retrofitting OCaml
Modules_](https://www.irill.org/videos/OUPS/2023-05/blaudeau.html)
(qui était une synthèse de son papier [_OCaml modules: formalization,
insights and
improvements_](https://inria.hal.science/hal-03526068/file/main.pdf)).

Comme l'ouverture n'exporte pas les composants ouverts, sans
l'association à une signature explicite, certains termes ne peuvent
pas être typés. Par exemple :


```ocaml
open struct type t = A end
let x = A
```


Dans cet exemple, le type `t` (et son constructeur `A`) est présent
dans le _scope courant_, cependant, comme il n'est pas exporté, il est
impossible de _typer_ correctement `x`. Si le module disposait d'une
signature, on pourrait facilement se rendre compte qu'il n'existe pas
de type acceptable pour `x`et qu'il faudrait soit changer la directive
d'ouverture, soit ne pas exporter `x`.  C'est un problème que l'on
appelle **l'ancrage des types** qui est décrit expansivement dans le
papier cité en début de section.



## Conclusion

Je pense sincèrement que, dans une utilisation quotidienne de OCaml,
nous sommes très rarement confronté à ce genre de besoins. L'objectif
de l'article était, _essentiellement_, de montrer comment utiliser
certaines primitives liées au langage de modules en complément de la
_généralisation des ouvertures_ pour démontrer qu'avoir des primitives
expressives et composables permet de reproduire, parfois trivialement
(et parfois moins trivialement), des schémas d'importations
classiques, présents dans d'autres langages de programmation. Il
existe probablement d'autres encodages _rigolos_ — probablement à base
de _foncteurs_ — et n'hésitez pas à me les faire parvenirs pour que je
puisse compléter cet article !


Pour terminer, j'ajouterai que même si j'ai fièrement _fanfaronné_ en
prétendant que ce n'était pas commun de programmer de cette manière en
OCaml, la présence de paquet comme
[ppx_import](https://ocaml.org/p/ppx_import/latest) ou
[ppx_open](https://github.com/johnyob/ppx-open) indique que quelques
allègement syntaxique ne serait pas de trop, notamment pour les
importation sélectives.
