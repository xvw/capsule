---
title: Lister les lignes trop longues
creation_date: 2024-04-09
description: Une petite astuce pour rapidement les lignes qui dépassent 80 caractères
synopsis: 
  Une petite astuce qui explique comment utiliser 
  [occur](https://www.emacswiki.org/emacs/OccurMode) et 
  [l'argument universel](https://www.gnu.org/software/emacs/manual/html_node/emacs/Arguments.html)
  pour énumérer, dans un _buffer_, l'ensemble des lignes qui dépassent un nombre donné 
  de caractères.
toc: true
tags:
  - programmation
  - emacs
  - astuce
  - occur
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
  id: "112247126969336928"
---

Il est très courant de programmer avec un nombre de caractères maximum par
lignes. Par exemple, comme je travaille essentiellement sur un écran 13 pouces,
le code que j'écris — sur mes projets personnels, pour les projets
professionnels, je m'adapte à la convention en vigueur — ne dépasse **jamais**
80 caractères, me permettant d'avoir, sur un seul écran, deux _buffers_
verticaux adjacents.

## Mise en contexte

Comme les _formaters/linters_ de code sont devenu légion dans l'industrie
informatique (permettant aux développeurs de ne plus se soucier de ce genre de
détails), il est assez rare de s'embarrasser de ce genre de détails. Cependant,
il arrive que pour certains projets, pour des raisons divers et variées, aucun
formatteur de code n'est mis en place. Comme j'ai perdu l'habitude de réfléchir
au formattage de mon code (utilisant, en [OCaml](https://ocaml.org), l'excellent
[ocamlformat](https://github.com/ocaml-ppx/ocamlformat)), limiter la taille de
mes lignes n'est plus un automatisme !

En ce moment, je travaille, [professionnellement](https://tarides.com), sur
[Merlin](https://github.com/ocaml/merlin), et la base de code n'utilise pas
`ocamlformat`, j'ai donc soumis un _patch_ en n'oubliant de vérifier que je
n'introduisais pas de ligne trop longue.

Pour éviter de vérifier chaque ligne (je suis aussi très nul avec `grep`), j'ai
cherché une solution dans Emacs, et je suis tombé sur la page [_Find Long
Lines_](https://www.emacswiki.org/emacs/FindLongLines) expliquant très
précisemment comment trouver les lignes trop longues. Cependant, à la lecture
des propositions, je me suis rendu compte que ... je ne comprenais pas les
solutions que l'on me proposait ... (_la honte_). La raison de mon
incompréhension était que je n'avais aucune idée de ce qu'était le [paramètre
universel](https://www.gnu.org/software/emacs/manual/html_node/emacs/Arguments.html).

## Le paramètre universel

Le **paramètre universel** — un très mauvais nom, selon moi — invoqué au moyen
de la commande `C-u +nombre +command` permet essentiellement deux choses :

- facilement passer un argument numérique à une commande. Et le traitement de ce
  nombre dépend de la commande (_sigh_). Très souvent, cela répète la commande
  `n` fois (si le nombre passé est `n`)
- faire alterner le comportement d'une commande (l'altération dépendandra, elle
  aussi, de la commande)
  
Comme il semblerait que ce soit généralement les commandes **qui décident de ce
qu'elle font** d'un argument numérique, ce paramètre peut sembler compliqué à
utiliser efficacement. Par exemple, utilisé avant `C-y` (pour coller) cela
naviguera dans l'historique du _presse-papier_. 

### Répéter un caractère

Cependant, couplé avec un caractère : `C-u +nombre +caractère` va insérer `n`
fois le caractère. Par exemple: `C-u 12 f` produira ce résultat :
`ffffffffffff`.

## Occur

J'étais largement plus familier à la commande
[occur](https://www.emacswiki.org/emacs/OccurMode) (`M-x occur` ou `M-s o`), qui
permet de chercher un _motif_ et énumérer les lignes capturées par le motif, de
manière interactive (rendant possible depuis l'énumération de _sauter_ vers la
location d'une ligne), dans un _buffer_ `*Occur*`. En général, c'est au-dessus
de cette commande que sont implantées les fonctions qui reposent sur de la
recherche d'identifiants.

Comme il est possible de chercher des lignes qui **capturent un motif** (donc
une expression régulière), on voudrait **capturer une ligne contenant au moins
81 caractères arbitraires**, ce qui pourrait s'écrire : `.\{81,\}`. Ça
fonctionne parfaitement mais, c'est un peu laborieux à écrire.

## Solution

Nous allons utiliser **le paramètre universel**, couplé avec **occur** pour
énumérer toutes les lignes faisant plus de 80 caractères. Donc plutôt que
d'utiliser une expression régulière compliquée, nous allons simplement **générer
81 points** :

- `M-s o`, on invoque `occur`
- `C-u 81 .` on rempli le motif avec `81` points
- `[RET]` on exécute la commande.

![example occurs](/images/occurs-81.gif){ class=centered-fig }

Et voila ! Expliqué de cette manière, ma solution semble parfaitement stupide,
je vous l'accorde. Mais elle est, de mon point de vue, **largement plus rapide**
à écrire que celle invoquant l'expression régulière et j'ai enfin,
partiellement, utilisé le paramètre universel.

### Alternative

Quand on a, _enfin_, compris comment utiliser le paramètre universelle, on peut
aussi expérimenter une autre solution, elle aussi proposée sur la page [_Find
Long Lines_](https://www.emacswiki.org/emacs/FindLongLines) qui, plutôt que
d'utiliser `occur` pour recenser les lignes trop longue, les surlignes : 

- `M-s h r` qui invoque le surlignage de ligne
- `C-u 81 .` qui rempli le motif avec 81 points
- `[RET]` qui exécute la commande.

Personnellement, je préfère l'utilisation de `occur`, que je trouve plus
agréable à utiliser, mais chacun ses préférences.

## Pour conclure

C'était un tout petit article qui témoigne de l'immensité des progrès que je
dois faire avec Emacs ! Mais c'est très amusant de voir comment les commandes
s'enchainent et je me réjouis de découvrir d'autres petites astuces comme
celle-là !
