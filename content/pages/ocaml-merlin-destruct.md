---
title: Effective ML, au travers de la commande 'destruct'
creation_date: 2024-06-03
description: Explication de la commande destruct de Merlin
synopsis:
  Cet article est une réinterprétation francophone d'un article publié
  [le blog de Tarides](https://tarides.com/blog/2024-05-29-effective-ml-through-merlin-s-destruct-command/), en Anglais, qui présente l'utilisation de la commande `destruct` pour générer
  des motifs manquants dans du filtrage par motif.
tags:
  - programmation
  - emacs
  - editeur
  - merlin
  - ocaml
breadcrumb:
  - name: Programmation
    href: /programming.html
  - name: Notes
    href: /programming.html#index-notes
  - name: Emacs
    href: /emacs.html
  - name: OCaml
    href: /emacs.html#index-ocaml
---

Les serveurs [Merlin](https://github.com/ocaml/merlin) et [OCaml
LSP](https://github.com/ocaml/ocaml-lsp), deux serveurs de langage OCaml
étroitement liés (en effet, OCaml LSP utilise des bibliothèques décrites dans
Merlin), améliorent la productivité grâce à des fonctionnalités telles que
l'auto-complétion et l'inférence de types. Leur commande `destruct`, moins
connue mais très utile, simplifie l'utilisation du filtrage par motif en
générant des instructions de correspondance exhaustives, comme nous le
montrerons dans cet article. La commande a récemment bénéficié de quelques
améliorations, la rendant plus utilisable, et nous profitons de cette mise à
jour pour la présenter et illustrer quelques cas d'utilisation.

Un _bon_ IDE pour un langage de programmation doit fournir des informations
contextuelles, telles que des suggestions de complétion, des détails sur les
expressions comme les types, et des retours d'erreurs en temps réel. Cependant,
dans un monde idéal, il devrait également servir d'assistant à l'écriture de
code, capable de générer du code selon les besoins. Et bien qu'il existe
indéniablement des points communs entre un large éventail de langages de
programmation, permettant la "généralisation" des interactions avec un éditeur
de code via un protocole (tel que [LSP](https://github.com/ocaml/ocaml-lsp)),
certains langages possèdent des fonctionnalités rares ou même uniques qui
nécessitent un traitement spécial. Heureusement, il est possible de développer
des fonctionnalités adaptées à ces particularités. Celles-ci peuvent être
invoquées dans LSP via des **requêtes personnalisées** pour récupérer des
informations arbitraires et des **actions de code** pour transformer un document
selon les besoins. Splendide ! Cependant, une telle fonctionnalité peut être
plus difficile à découvrir, car elle dénormalise quelque peu l'expérience
utilisateur de l'IDE. C'est le cas de la commande `destruct`, qui est
immensément utile et fait gagner beaucoup de temps.

Dans cet article, nous allons tenter de comprendre l'utilité de cette commande
et son application à l'aide d'exemples quelque peu simplistes. Ensuite, nous
approfondirons avec quelques exemples moins artificiels que j'utilise dans mon
codage quotidien. J'espère que cet article sera utile et divertissant tant pour
les personnes qui connaissent déjà `destruct` que pour celles qui ne le
connaissent pas.

## `destruct`, dans les grandes lignes

OCaml permet l'expression de [types de données
algébriques](https://ocamlbook.org/algebraic-types/) qui, associés au [filtrage
par motif](https://ocaml.org/docs/basic-data-types), peuvent être utilisés pour
décrire des structures de données et effectuer une analyse de cas. Dans le cas
où un filtrage par motif n'est pas exhaustif, **l'avertissement 8**, connu sous
le nom de `partial-match`, sera levé lors de la phase de compilation. Il est
donc conseillé de maintenir des blocs de filtrage exhaustifs.


> Pour ceux qui ne connaissent pas le terme `destruct`, le filtrage par motif
> est une analyse de cas, et l'expression de la forme (un ensemble de motifs)
> sur laquelle vous effectuez le _filtrage_ est appelée **déstructuration**, car
> vous déballez des valeurs à partir de données structurées. C'est la même
> terminologie [utilisée en
> JavaScript](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment).


La commande `destruct` aide à atteindre cette exhaustivité. Lorsqu'elle est
appliquée à un motif (via `M-x merlin-destruct` dans Emacs, `:MerlinDestruct`
dans Vim, et `Alt + d` dans Visual Studio Code), elle génère des motifs. La
commande se comporte différemment selon le contexte du curseur :

- Lorsqu'elle est appelée sur une expression, elle la remplace par un filtrage
  par motif sur ses constructeurs.
  
- Lorsqu'elle est appelée sur un motif d'un filtrage non exhaustif, elle rend le
  filtrage exhaustif en ajoutant les cas manquants.
  
- Lorsqu'elle est appelée sur un motif générique (_wildcard_), elle le précisera
  si possible.

Examinons chacun de ces scénarios à l'aide d'exemples. J'utilise [Doom
Emacs](https://github.com/doomemacs/doomemacs), cependant, l'ensemble des
exemples devraient être parfaitement adaptables dans votre éditeur favori !

### Déstructuration sur une expression

La _déstructuration_ d'une expression fonctionne de manière assez évidente. Si le
vérificateur de types connaît le type de l'expression (dans notre exemple, il le
connaît par inférence), l'expression sera remplacée par un filtrage sur tous les
cas énumérables.

![exemple de destructuration sur une expression](/images/merlin-destruct-1.gif){ class=aered-centered-fig }

### Déstructuration sur une correspondance de motifs non-exhaustive

Le second comportement est, à mon avis, le plus pratique. Bien que j'aie
rarement besoin de remplacer une expression par un filtrage par motif, je veux
souvent effectuer une analyse de cas sur tous les constructeurs d'un type somme.
En implémentant juste un motif unique, comme `Foo`, mon expression de filtrage
n'est pas exhaustive, et si je fais une `destruct` sur celui-ci, elle générera
tous les cas manquants.

![exemple de destructuration sur une correspondance non-exhaustive](/images/merlin-destruct-2.gif){ class=aered-centered-fig }

### Déstructuration sur un motif _générique_

Le comportement final est très similaire au précédent ; lorsque vous appliquez
`destruct` à un motif générique (ou à un motif produisant un générique, par
exemple, une déclaration de variable), la commande générera toutes les branches
manquantes.

![exemple de destructuration sur un motif wildcarant](/images/merlin-destruct-3.gif){ class=aered-centered-fig }

### Déstructuration en présence de _nesting_

Lorsqu'elle est utilisée de manière interactive, il est possible de déstructurer
des motifs imbriqués pour atteindre rapidement l'exhaustivité. Par exemple,
imaginons que notre variable `x` soit de type `t option` :

- Nous commençons par déstructurer notre motif générique (`_`), ce qui produira
  deux branches, `None` et `Some _`.
  
- Ensuite, nous pouvons appliquer `destruct` sur le motif générique associé de
  `Some _`, ce qui produira tous les cas concevables pour le type `t`.
  
![exemple de destructuration sur des motifs nestés](/images/merlin-destruct-4.gif){ class=aered-centered-fig }

### Dans le cas de produits (plutôt que de sommes)

Dans les exemples précédents, nous avons toujours traité des cas dont les
domaines sont parfaitement définis, ne déstructurant que des cas de branches de
types somme simples. Cependant, la commande `destruct` peut également agir sur
des produits. Considérons un exemple très ambitieux où nous effectuerons un
filtrage par motif exhaustif sur une valeur de type `t * t option`, générant
tous les cas possibles en utilisant uniquement `destruct` :

![exemple de destructuration sur des produits](/images/merlin-destruct-5.gif){ class=aered-centered-fig }

Il est possible de constater que lorsqu'il est utilisé de manière interactive,
la commande permet de gagner beaucoup de temps, et associée aux retours en temps
réel de Merlin concernant les erreurs, on peut rapidement déterminer si notre
filtrage par motif est exhaustif. Dans un sens, c'est un peu comme un
"dérivateur" manuel.

La commande `destruct` peut agir sur n'importe quel motif, elle fonctionne donc
également dans les arguments de fonction (bien que leur représentation ait
légèrement changé pour la version `5.2.0`), et en plus de déstructurer les tuples,
il est également possible de déstructurer des enregistrements, ce qui peut être
très utile pour notre quête d'exhaustivité !

![exemple de destructuration sur des records](/images/merlin-destruct-6.gif){ class=aered-centered-fig }

### Quand l'ensemble des constructeurs est non-fini

Parfois, les types ne sont pas énumérables de manière finie. Par exemple,
comment pouvons-nous gérer les chaînes de caractères ou même les entiers ? Dans
de telles situations, `destruct` tentera de trouver un exemple. Pour les
entiers, ce sera `0`, et pour les chaînes de caractères, ce sera la chaîne vide.

![exemple de destructuration sur set non-finis](/images/merlin-destruct-7.gif){ class=aered-centered-fig }

Excellent ! Nous avons couvert une grande partie des comportements de la
commande `destruct`, qui sont très pertinents dans leur contexte. Il y en a
d'autres (comme les cas de destruction en présence de [GADTs](https://ocaml.org/manual/gadts-tutorial.html) qui ne génèrent que
des sous-ensembles de motifs), mais il est temps de passer à un exemple du monde
réel !


## La quête de l'exhaustivité: _Effective ML_

En 2010, [Yaron Minsky](https://x.com/yminsky) a donné une [excellente
présentation](https://www.youtube.com/watch?v=-J8YyfrSwTk) sur les raisons (et
les avantages) d'utiliser OCaml chez [Jane Street](https://www.janestreet.com/).
En plus d'être très inspirante, elle fournit des _insights_ spécifiques et des
pièges à éviter pour utiliser OCaml efficacement dans un contexte industriel
incroyablement sensible (d'où le nom "Effective ML"). C'est dans cette
présentation que la maxime "_Rendre les états illégaux non représentables_" a
été mentionnée publiquement pour la première fois, une phrase qui serait plus
tard fréquemment utilisée pour promouvoir d'autres technologies (comme
[Elm](https://www.youtube.com/watch?v=IcgmSRJHu_8)). De plus, la présentation
anticipe de nombreuses discussions sur la modélisation de domaine, chères à la
communauté du [Software
Craftsmanship](https://en.wikipedia.org/wiki/Software_craftsmanship), en
proposant des stratégies de réduction de domaine (plus tard largement
développées dans le livre [_Domain Modeling Made
Functional_](https://pragprog.com/titles/swdddf/domain-modeling-made-functional/)).

Parmi la liste des approches efficaces pour utiliser un langage ML, Yaron
présente un scénario où l'on pourrait trop rapidement utiliser le générique dans
une analyse de cas. L'exemple est étroitement lié à la finance, mais il est
facile de le transposer dans un exemple plus simple. Nous allons implémenter une
fonction `equal` pour un type très basique :

```ocaml
type t = 
  | Foo
  | Bar
```

La fonction `equal` peut être implémentée trivialement comme suit :

```ocaml
let equal a b = 
  match (a, b) with
  | Foo, Foo -> true
  | Bar, Bar -> true
  | _ -> false
```

Notre fonction fonctionne parfaitement et est exhaustive. Cependant, que se
passe-t-il si nous ajoutons un constructeur à notre type `t` ?

```diff
  type t
    | Foo
    | Bar
+   | Baz
```

Notre fonction, dans le cas de `equal Baz Baz`, renverra `false`, ce qui n'est
évidemment pas le comportement attendu. Comme le générique rend notre fonction
exhaustive, **le compilateur ne signalera aucune erreur**. C'est pourquoi Yaron
Minsky soutient que dans de nombreux cas avec une clause générique, c'est
probablement une erreur. Si notre fonction avait été exhaustive, l'ajout d'un
constructeur aurait levé un avertissement `partial-match`, nous obligeant à
décider explicitement comment nous comporter en présence du nouveau constructeur
! Par conséquent, utiliser un _wildcard_ dans ce contexte **nous prive de la
refactorisation sans crainte**, qui est une force d'OCaml. C'est en effet un
argument en faveur de l'utilisation d'un préprocesseur pour générer des
fonctions d'égalité, en utilisant, par exemple, [le dériveur standard
`eq`](https://github.com/ocaml-ppx/ppx_deriving?tab=readme-ov-file#plugins-eq-and-ord)
ou le plus hygiénique
[`Ppx_compare`](https://github.com/janestreet/ppx_compare). Mais parfois,
utiliser un préprocesseur n'est pas possible. Heureusement, la commande
`destruct` peut nous aider à définir une fonction d'égalité exhaustive !

Nous allons procéder étape par étape, en séparant spécifiquement les différents
cas et en utilisant un filtrage par motif imbriqué pour rendre les différents
cas faciles à exprimer de manière récurrente :

![exemple de destructuration pour une fonction d'égalité](/images/merlin-destruct-8.gif){ class=aered-centered-fig }

Comme nous pouvons le voir, `destruct` nous permet de mettre en œuvre rapidement
une fonction `equal` exhaustive **sans utiliser de motifs génériques**.
Maintenant, nous pouvons ajouter notre constructeur `Baz` pour voir comment se
déroule la refactoring ! En ajoutant un constructeur, nous détectons rapidement
un motif récurrent où nous essayons de donner à la commande `destruct` **autant
de liberté que possible** pour générer les motifs manquants !

![exemple de destructuration pour une fonction d'égalité avec ajout de constructeur](/images/merlin-destruct-9.gif){ class=aered-centered-fig }

Fantastique ! Nous avons pu mettre en œuvre rapidement une fonction `equal`.
Ajouter un nouveau cas est trivial, laissant `destruct` gérer tout le travail !

Associée à des fonctionnalités modernes d'édition de texte (par exemple,
l'utilisation de multi-curseurs), il est possible de gagner énormément de temps
! Un autre exemple de l'utilisation immodérée de `destruct` (mais trop long pour
être détaillé dans cet article) était l'implémentation du module
[Mime](https://github.com/xhtmlboi/yocaml/blob/main/lib/yocaml/mime.ml) dans
[YOCaml](https://github.com/xhtmlboi/yocaml) pour générer des flux RSS.


## En conclusion

Associé à un formateur comme
[OCamlFormat](https://github.com/ocaml-ppx/ocamlformat) (pour reformater
proprement les fragments de code générés), `destruct` est un outil peu
conventionnel dans le paysage des IDE. Il s'aligne avec les types algébriques et
le filtrage par motif pour simplifier l'écriture du code et progresser vers un
code plus facile à refactoriser et donc à maintenir ! Consciente de l'utilité de
la commande, l'équipe de [Merlin](https://github.com/ocaml/merlin) continue de
la maintenir, en optimisant les dernières fonctionnalités d'OCaml pour rendre la
commande aussi utilisable que possible dans le plus de contextes possible !

J'espère que cette collection d'exemples illustrés vous a motivé à utiliser la
fonction `destruct` si vous n'en aviez pas déjà connaissance. N'hésitez pas à
nous envoyer des idées d'améliorations, de correctifs et **de cas d'utilisation
amusants** via [X](https://twitter.com/tarides_) ou
[LinkedIn](https://www.linkedin.com/company/tarides) !

_Bon hacking_.
