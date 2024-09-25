---
title: Expansion d'abréviations avec YASnippet
creation_date: 2024-09-25
description: Une très brève introduction à l'utilisation de YASnippet pour l'expansion d'abréviations.
synopsis: 
  Quand on programme (ou que l'on rédige), il est assez courant de devoir saisir
  des séquences récurrentes (du _boilerplate_). C'est probablement plus observable
  quand on écrit de code, où certaines constructions du langages, disposant de
  niveau d'expressivité différents, doivent être répétées très régulièrement. Dans
  cet article, je vous propose de découvrir 
  [YASnippet](https://github.com/joaotavora/yasnippet) (pour 
  _**Y**et **A**n other **S**nippet extension_), un système de _template_
  pour Emacs, permettant l'expansion d'abréviations, de manière structurée.
toc: true
tags: [programmation, emacs, yasnippet]
breadcrumb:
  - name: Programmation
    href: /programming.html
  - name: Notes
    href: /programming.html#index-notes
  - name: Emacs
    href: /emacs.html
  - name: Astuces
    href: /emacs.html#index-astuces
mastodon_thread:
  instance: merveilles.town
  user: xvw
  id: "113199409470266941"
---

Quand on écrit du code, où que l'on rédige des documents, il est assez
courant de devoir répéter des instructions imposant une structure
fixe. Par exemple, dans beaucoup de langages de programmation, la
construction `if` respecte généralement ce motif : `if PREDICATE then
A else B`. [YASnippet](https://github.com/joaotavora/yasnippet) est un
système de _templates_ populaire dans le monde d'Emacs, pour permettre
la saisie interactive, tout en ajoutant une notion de **mouvements
structurés**. Le _greffons_ est très connu cependant, en essayant
d'augmenter ma maitrise de Emacs (qui est toujours tristounette), j'ai
commencé à l'utiliser et j'ai été très impressionné par son ergonomie
! Cet article n'est pas un _tutoriel en profondeur_, [la
documentation](http://joaotavora.github.io/yasnippet/snippet-development.html)
du greffon est très complète, mais un très rapide survol de quelques
fonctionnalités que j'utilise.

### Un petit détour par `abbrev-mode`

De mon point de vue, YASnippet est une version augmentée du mode de
saisie d'abréviations via de Emacs,
[`abbrev-mode`](https://www.emacswiki.org/emacs/AbbrevMode) qui permet
de produire une expansion pour une abréviation donnée. Par exemple, en
[OCaml](https://ocaml.org), la définition du corps d'un module, une
_structure_, est toujours close entre `struct` et `end`. On pourrait
donc imaginer une abréviation qui étend `struct` en `struct end` (à la
saisie de la touche `TAB`). Même si le mode d'abréviations est très
convaincant, j'ai trouvé que son minimalisme le rendait compliqué à
utiliser efficacement. En effet, dans l'exemple qui d'associer
`struct` et `end`, je voudrais que mon curseur se trouve entre
l'ouverture et la fermeture. Malheureusement, le contrôle de la
position du curseur et autres action _ad-hoc_, impose de passer par
des _hooks_, rendant la définition d'expansion d'abréviations, de mon
point de vue, laborieuse.

Heureusement, YASnippet permet de résoudre ce problème, d'une manière
que je trouve convaincante. Voyons comment s'en servrir pour résoudre
des petits cas pratiques.

## Installation et organisation des _snippets_

YASnippet n'est pas fourni par défaut dans Emacs, il est donc
nécéssaire de l'installer. Pour ma part, j'utilise la macro
[`use-package`](https://github.com/jwiegley/use-package), qui me
permet de décrire déclarativement ma configuration (et qui, depuis `>=
29`, est disponible par défaut) :

```scheme
(use-package yasnippet
  :config
  (setq yas-snippet-dirs '("~/scame/snippets"))
  (yas-global-mode 1))
```

L'installation est assez commune, je configure le répertoire où se
trouveront mes _snippets_ ([scame](https://github.com/xvw/scame) est
ma configuration Emacs) et j'active globalement le mode. Comme nous le
verrons plus en détail dans l'organisation des _snippets_, ils sont
_scopés_ par mode, ce qui ne pose donc, de mon point de vue, aucun
problème d'activer le mode globalement. Il est aussi possible de
modifier les liaisons de touches par défaut, mais pour mon usage,
`TAB` pour subsituer une abréviation est très confortable.

### Organisation du répertoire de _snippets_

Un _snippet_ est un fichier texte qui se trouvera dans un répertoire
enfant du répertoire que nous avons configuré par le biais de la
variable `yas-snippet-dirs`. Chaque sous-répertoire décrit un mode
pour lequel les _snippets_ sont accessibles. Par exemple, dans mon
cas, voici comment est structuré le répertoire `~/scame/snippets` :

```
└─📁 scame
   └─📁 snippets
     ├─📁 fundamental-mode
     ├─📁 html-mode
     ├─📁 markdown-mode
     └─📁 tuareg-mode
```

Les _snippets_, qui sont des fichiers textuels classiques, seront
enregistrés dans chacun des sous-répertoires, pour n'être actifs que
si l'on se trouve dans le mode référant. Dans mon exemple, j'ai des
abréviations pour les modes `html`, `markdown`, `tuareg` (pour OCaml)
et les abréviations localisées dans `fundamental-mode` seront communes
à tous les modes.

Quand le répertoire `yas-snippet-dirs` est correctement paramétré,
chaque création de _snippet_ lancera le mode `snippet` automatiquement
et chaque sauvegarde rechargera la table des _snippets_, ce qui est
très confortable !

## Création d'abréviations

Maintenant que nous avons installé YASnippet, et que nous avons
configuré son répertoire, créeons nos premiers _snippets_ !

Pour commencer, nous allons créer le _snippet_ `me`, qui quand on
écrit `!me`, à la saisie de `TAB`, remplace `!me` par `Xavier Van de
Woestyne <mon adresse email>`. Comme cette abréviation n'est pas
spécifique à un seul mode, on peut l'écrire dans
`snippets/fundamental-mode`. Créeons un fichier `me` (comme YASnippet
détecte si un fichier est créée dans un répertoire destiné à stocker
des abréviations, il n'est pas nécéssaire de donner une extension au
fichier, Emacs activera automatiquement le mode `snippet`). Dans ce
fichier, nous allons avoir 4 lignes:

```
# name: me
# key: !me
# --
Xavier Van de Woestyne <my email address>
```

Les lignes préfixées par `#` décrivent les métadonnées de
l'abréviation :

- `#name` est l'identifiant de l'abréviation, usuellement, c'est le
  nom du fichier, dans notre exemple, `me` ;
- `#key` décrit l'abréviation, ici `!me` sera le texte à substituer si
  la touche `TAB` est pressée ;
- `# --` décrit la fin de la section dédiée aux métadonnées de
  l'abréviation, et tout ce qui suit décrira comment substituer la clé
  (`#key`) par le contenu du _template_.

En sauvegardant le fichier, l'expansion sera disponible et il sera
possible de s'en servir de cette manière :
![Exemple d'expansion](/images/yas-1.gif){ class=aered-centered-fig }

Actuellement, notre abréviation ne fait pas beaucoup plus que ce qu'il
était possible de faire avec `abbrev-mode`, mais c'est déjà un très
bon début ! (Il existe des métadonnées aditionnelles, documentées
[ici](http://joaotavora.github.io/yasnippet/snippet-development.html#org5e87ae3),
permettant de paramétrer très finement une substitution d'abréviation).

### Contrôle du curseur après subsitution

Ce qui rend, de mon point de vue, YASnippet largement plus flexible et
agréable à utiliser que `abbrev-mode` est la possibilité **de décrire
la position du curseur après substitution**. Reprenons l'exemple
`struct` et `end`:

```
# name: structend
# key: !struct
# --
struct $0 end
```

Ici, `$0` dénotera la position du curseur après substitution. Une fois
que `!struct` sera remplacé par `struct end`, le curseur se trouvera
entre `struct` et `end`. Démonstration :

![Exemple d'expansion avec relocalisation du
curseur](/images/yas-2.gif){ class=aered-centered-fig }

Dans notre exemple, on observe qu'une fois que `!struct` a été
remplacé par `struct end`, le curseur se situe bel et bien entre les
deux membres de l'expression de module ! A ce niveau, je trouve que
YASnippet est déjà largement plus simple à utiliser que `abbrev-mode`,
ne demandant pas de viruosité particulière en `elisp` pour contrôler
efficacement la position du curseur après une expansion.

### Remplacements et navigation structurée

La raison pour laquelle YASnippet est _plus_ qu'une extension à
l'`abbrev-mode`, c'est que la description d'un _template_ permet de
construire des trous (des _placeholders_) tout en autorisant la
navigation de trous en trous et potentiellement d'appliquer des
fonctions Elisp.

Par exemple, reprenons l'exemple `me`, sauf que cette fois, je
voudrais construire un gabarit générique me permettant de naviguer
entre le nom et l'adresse email.

```
# name: email
# key: !email
# --
$1  <$2> $0
```

L'effet de la substitution de `!email` placera d'abord le curseur à la
position `$1` et l'utilisation de `TAB` déplacera le curseur sur `$2`,
permettant **la navigation entre les différents trous** du
gabarit. Une fois que la saisie est finie, `TAB` déplacera le curseur
à la fin de la substitution.

![Exemple d'expansion avec navigation](/images/yas-3.gif){
class=aered-centered-fig }

La définition de trous permet aussi l'association à des labels, pour
rendre la lecture de la substitution plus facile :

```
# name: email
# key: !email
# --
$1  <$2> $0
```

![Exemple d'expansion avec navigation et labels](/images/yas-4.gif){
class=aered-centered-fig }


#### Répétitions et exécution de Lisp

Allons un peu plus loin, dans un exemple plus réaliste que les
précédents. Il est très courant qu'un document
[Markdown](https://en.wikipedia.org/wiki/Markdown) commence par la
définition de métadonnées, par exemple, le titre du document,
l'auteur, et la date de publication.

Voyons un gabarit, situé dans `snippets/markdown-mode` (pour n'être
accessible que depuis le mode Markdown), nous permettant d'automatiser
l'écritue du prélude de notre document :

```
# name: prelude
# key: !prelude
# --
---
title: ${1:Article title}
author: Xavier Van de Woestyne <xaviervdw@gmail.com>
date: ${2:`(current-time-string)`}
---

# $1

$0
```

Dans ce gabarit, on observe deux choses intéressantes. Premièrement,
le champ `date` est construit en définissant comme valeur par défaut
l'expression Elisp `(current-time-string)`. Ensuite, on répète
l'utilisation du trou `$1` pour pré-remplir le titre de niveau 1 :

![Exemple d'expansion de prélude Markdown](/images/yas-5.gif){
class=aered-centered-fig }

L'exemple est déjà plus ambitieux (et potentiellement réaliste) que
ceux que nous avions vu précédemment et, selon moi, démontre l'utilité
de YASnippet ! Je vous invite à lire [la documentation du langage de
gabarits](http://joaotavora.github.io/yasnippet/snippet-development.html#org9801aa7)
pour prendre pleinement connaissance des possibilités offertes et
potentiellement pour trouver des cas d'usages amusants !

## Une collection de snippets pour OCaml

Pour démontrer l'intérêt, et la versatilité des gabarits, voici un
dernier exemple qui applique une fonction sur un trou. En OCaml, un
[module](https://ocaml.org/docs/modules) doit commencer par une
majuscule, et il est courant de nommer les [types de
modules](https://ocaml.org/manual/5.2/moduleexamples.html#s%3Asignature)
_tout en majuscule_ (c'est une convention implicite). On peut donc
imaginer ces 3 gabarits :

Premièrement, on permet la construction structurée d'un module, où le
nom du module remplace automatiquement les espaces par des `_` et où
le nom du module est automatiquement captialisé, donc `foo bar baz`
devient `Foo_Bar_Baz` (pour parfaitement faire les choses, il ne
faudrait ne capitaliser **que le premier mots** mais je voulais garder
l'exemple en _one-liner_) :

```
# name: impl
# key: !impl
# --
module ${1:$$(capitalize (string-replace " " "_" yas-text))} = struct
  $0
end
```

On applique la même logique pour décrire une signature :

```
# name: intf
# key: !intf
# --
module ${1:$$(capitalize (string-replace " " "_" yas-text))} : sig
  $0
end
```

Et on applique `upcase`, plutôt que `capitalize` pour les types de
modules, transformant le texte `foo bar baz` en `FOO_BAR_BAZ` :

```
# name: modtype
# key: !modtype
# --
module type ${1:$$(upcase (string-replace " " "_" yas-text))} = sig
  $0
end
```

En ajoutant quelques abréviations supplémentaires, pour décrire `let`
par exemple, on peut construire un _workflow_ d'écriture de code très
interactive, de mon point de vue :

![OCaml workflow](/images/yas-6.gif){ class=aered-centered-fig }

Il est évidemment possible d'aller largement plus loin, et d'améliorer
drastiquement l'ergonomie de nos gabarits. Le but de cette rubrique
était de montrer de quelle manière il est possible, au moyen de
YASnippet, de décrire une manière de naviguer structurellement dans
une expression, ce qui se marie assez bien avec les [fonctionnalités
de
navigation](https://ocaml.github.io/merlin/editor/emacs/#source-browsing)
dans le code [Merlin](https://github.com/ocaml/merlin).

## Pour conclure

Le _mode_, au vue de ses [statistiques
MELPA](https://melpa.org/#/yasnippet), est **incroyablement
populaire** et je comprend pourquoi :

- Le paquet est facile à installer, à personnaliser et à utiliser
- Son expérience utilisateur est agréable (il est très facile
  d'ajouter des abréviations)
- Il offre un **grand nombre de fonctionnalités**.

Je vais continuer à utiliser YASnippet pour simplifier certaines
tâches récurrentes et la fonctionnalités que je préfère est sans aucun
doute la possibilité de décrire des trous, rendant la navigation
structurelle envisageable ! Si jamais vous avez des chouettes gabarits
à partager, n'hésitez surtout pas, je serais ravi de lire vos
propositions !

Une fois de plus, un article qui semblera évident pour les
utilisateurs de Emacs aguerris ! Cependant, si, comme moi, vous avez
toujours utilisé Emacs _sans réellement essayer de comprendre comment
efficace_, j'espère que cet article aura été utile !
