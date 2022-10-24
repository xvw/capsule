---
title: Méthodes gardées
creation_date: 2022-05-29
description: 
  Implémentation de "méthodes gardées" en utilisant des témoins d'égalités
  de types.
synopsis:
  Les **méthodes gardées** permettent d'attacher des **contraintes** 
  au receveur (`self`) **uniquement pour certaines méthodes**, permettant 
  donc de n'appeler ces méthodes que si le receveur satisfait ces contraintes 
  (ces _guards_). [OCaml](https://ocaml.org) ne permet pas, syntaxiquement, 
  de définir _directement_ ce genre de méthodes. Dans cette note, nous allons 
  voir comment les encoder en utilisant un **témoin d'égalité de type**.
tags:
  - programmation
  - type
  - oop
  - ocaml
  - gadt
breadcrumb:
  - name: Bribes & Encodages
    href: /capsule/tricks.html#index-ocaml
---

Les _défenseurs_ de la **programmation orientée objets** défendent souvent cette
dernière en affirmant que c'est "_la manière normale de raisonner (sur)
l'ensemble des objets du métier_" et qu'elle permet de modèliser efficacement
l'ensemble des structures de données de manière uniforme. Pourtant, beaucoup de
critiques sont parfois formulées à l'encontre de cette approche ("_beaucoup_"
est à prendre avec des pincettes car l'OOP est encore et toujours l'approche la
plus populaire aujourd'hui, du moins selon leur représentation sur
[Github](https://github.com) ou [StackOverflow](https://stackoverflow.com/)).
Dans les critiques formulées, nous allons nous intéresser tout particulièrement
à **l'absence de méthodes gardées**, qui n'est pas, objectivement, reliée à
l'orienté objets, car il serait envisageable de les intégrer, mais qui manque
dans beaucoup de langages OOP populaires.


## Présentation du problème

Quand un langage (dont les vérification des types est effectuée avant
l'exécution du programme, comme en Java ou en OCaml) introduit du
**polymorphisme paramétrique** (les _génériques de Java_), on peut parfois
contraindre les variables de types. Par exemple :

```java
class MyClass<T extends S> { ... }
```

On rend `MyClass` générique en admettant que la variable de type `T` est un
sous-type de `S`. Le problème est que la contrainte agit **sur toute la
classe**. Pourtant, parfois, nous voudrions pouvoir n'avoir des contraintes
que **sur certaines méthodes**. Par exemple, admettons que nous ayons une
classe `MyList` décrivant une liste: 

```java
class MyList<A> extends ArrayList<A> {
   public int length() {
     return this.size();
   }
}
```
Comment décrire une méthode `flatten` qui pour une liste `[[1, 2, 3], [4, 5]]`
produirait la liste `[1, 2, 3, 4, 5]` ? Si on place la contrainte au niveau
de la classe on force notre liste à être "_tout le temps une liste de liste_"
ce qui est très contraignant. Pour implémenter une telle méthode, on dispose
de trois approches théoriques :

### Déplacer la méthodes en dehors de la classe

La première solution est la plus évidente, il suffit de "_tricher_" en déplaçant
la méthode en dehors du corps de classe (par exemple dans le contexte statique
ou l'objet _compagnon_) :

```java
class MyList<A> extends ArrayList<A> {
   public static <A> MyList<A> flatten(MyList<MyList<A>> list) {
      // Implémentation de flatten
   }
   public int length() {
     return this.size();
   }
}
```

Cette approche fonctionne et ne nécéssite pas de cérémonie particulière par
contre, elle force le développeur à garder en tête les méthodes présentent dans
le corps de la classe et dans son contexte statique. En plus, cela casse
l'approche systématique de l'envoi de message à une instance (souvent présentée
comme un des arguments en faveur de la programmation orientée objets).

### Les méthodes d'extension

[Kotlin](https://kotlinlang.org/) (et d'autres, comme
[C#](https://docs.microsoft.com/en-us/dotnet/csharp/)) proposent des [méthodes
d'extension](https://kotlinlang.org/docs/extensions.html) qui, en plus de
permettre **l'extension d'une classe déjà existante** (ce qui peut être très
pratique pour ajouter du comportement à la classe `String` qui, en Java, est
finale), permet plus de finesse dans la définition du _receveur_. Nous
pourrions, par exemple, écrire `flatten` de cette manière (en Kotlin):

```kotlin
class MyList<A> : ArrayList<A> { ... }
fun <A> MyList<MyList<A>>.flatten() = ...
```

Même si la solution semble proche de la perfection, elle impose tout de même la
définition de la méthodes **en dehors de la classe** ce qui pourrait
potentiellement impliquer de devoir rendre certaines membres de la classe
_publiques_ en vue d'être exploitable par une extension. Cependant elles
permettent tout de même **de garder l'approche systèmatique de l'envoi de
messages tout en offrant la possibilité de qualifier plus finement le
receveur**.

### Les méthodes gardées

La dernière approche est probablement la plus idéologique car elle ne sort pas
la définition de la méthode en dehors de la classe. Elle ne force donc pas
d'abstractions échappée. Il s'agit des **méthodes gardées**, soit la possibilité
d'ajouter, au niveau de la définition de la méthode, des contraintes sur le
paramètre générique. Dans une syntaxe **imaginaire** (ce code compile parce
qu'il n'est pas syntaxiquement faux par contre, il ne produit pas l'effet
désiré) :

```kotlin
class MyList<A> : ArrayList<A>() {
    fun length() = size
    fun <B> MyList<MyList<B>>.flatten() =
        // Implémentation de flatten
}
```

Même si ça ne semble pas sensiblement différent des méthodes d'extensions
classiques (pour preuve, la syntaxe de ces dernières, mais **dans le corps de la
classe** semble suffire), on corrige tous les soucis révélés précédemment:

- on peut caractériser plus finement que dans une méthode _normale_ le receveur
- on ne casse pas l'envoi de messages réguliers
- on bénéficie toujours des membres disponnibles (donc on n'échappe pas de
  représentations)
  
Même si les méthodes gardées semblent être nécéssaires, je ne connais
malheureusement pas de langages _mainstream_ qui permettent leur définition.
Voila qui est très triste. Heureusement, en OCaml, il est possible de les
_encoder_.


### La symétrie OOP/FP : théorie et pratique

Comme les méthodes gardées sont assez rares dans les langages de programmation
populaires j'ai découvert leur existence assez récemment, en lisant les
[transparents](http://gallium.inria.fr/~scherer/doc/oo-fp-symmetry-bob-2020.org)
de la présentation "_[The Object-Oriented/Functional-Programming symmetry: theory
and practice ](https://www.youtube.com/watch?v=TrameN7BTCQ)_" de [Gabriel
Scherer](http://gallium.inria.fr/~scherer/). 

Je recommande cette présentation qui présente une **symétrie** entre les outils
de la programmation fonctionnelle statiquement typée et la programmation
orientée objets. Même si cette symétrie à éte de très nombreuse fois observée et
étudiée, la présentation est exhaustive et accessible (et relativement peu
biaisée, posant les avantages et inconvénients des deux approches).
Malheureusement non couvertes pendant la présentation (_le temps est souvent
l'ennemi d'un présentateur_), toute une section est dédiée aux méthodes gardées
dans les transparents. L'exemple original propose une observation symétrique
entre l'implémentation de la fonction `flatten` dans un style fonctionnel
classique : 

```ocaml
type 'a list = ...
let rec length : 'a list -> int = ...
let rec concat : 'a list -> 'a list -> 'a list = ...

let rec flatten : 'a list list -> 'a list = function
  | [] -> []
  | x::xs -> x @ flatten xs
```

Et l'implémentation d'une méthode `flatten` si nous étions dans le monde
objet, posant exactement le problème introduit dans cette note. Soit quel
type donner à `flatten`:

```ocaml
class type ['a] olist = object
  method length : int
  method concat : 'a olist -> 'a olist

  method flatten : ???
end
```

Il propose donc cette syntaxe, qui implique une garde sur la méthode `flatten`:

```ocaml
method flatten : 'b olist with 'a = 'b olist
```

Cette syntaxe permet de décrire une méthode gardée et pourrait se généraliser de
cette manière : `method method_name : return_type with generic_type = other_type`.
Un peu à la manière des **substitution** dans les modules, on pourrait décrire
des contraintes sur plusieurs génériques au moyen de `and`. Par exemple : 
`method foo : string with 'a = string and  b = int` pour une classe paramétrée
par deux types : `class ['a, 'b] t`.

En complément, cette syntaxe permettrait aussi de définir des comportements spécifiques
de manière élégante, par exemple, pour notre type `olist`, nous pourrions proposer
une méthode `sum` si les habitants de la liste sont des entiers:

```ocaml
class type ['a] olist = object
  method length : int
  method concat : 'a olist -> 'a olist
  method flatten : 'b olist with 'a = 'b olist
  method sum : int with 'a = int
end
```

Tout ceci semble extraordinaire, **malheureusement, cette syntaxe n'est pas disponnible**
en OCaml. Voila qui est ennuyant ! Pas de panique, il est possible de **l'encoder**
au moyen de quelques petits outils.

## Méthodes gardées en OCaml

> Même si j'avais une idée assez précises des outils à mettre en oeuvre dans
> l'encodage des méthodes gardées, en me heurtant à quelques _corner-cases_,
> j'ai décidé de faire appel à celui qui, dans la communauté OCaml, ne pose
> jamais de questions mais y répond toujours de manière expansive : [Florian
> Angeletti](https://github.com/Octachron), aussi connu sous le nom de
> **Octachron**. (Petite note amusante, `octachron` est le nom d'un séquenceur
> de batterie midi, donc en cherchant son pseudonyme sur _Google_, j'ai tout de
> suite eu, dans les suggestions: `octachron ocaml`.)

Notre objectif est de permettre d'ajouter une contrainte à certaines méthodes pour 
ne les rendres accessibles que si le type du receveur la satisfait. Sans passer par
de la modification syntaxique du langage, modeliser une contrainte peut **consister
à donner un paramètre additionnel qui l'enforce**. En d'autres mots, on voudrait
fournir une **évidence**.

### Fournir un témoin d'égalité de types

Depuis l'introduction des [types algébriques
généralisés](https://v2.ocaml.org/releases/4.14/htmlman/gadts-tutorial.html#sec63)
dans le langage, il existe une manière assez directe de définir un témoins
d'égalité de types:

```ocaml
type (_, _) eq = 
  | Refl : ('a, 'a) eq
```

Le type `eq`, qui n'a qu'un seul constructeur: `Refl`, et permet de représenter
des égalité de types **non connues par le _type-checker_**. Comme on ne peut que
construire des valeurs `Refl` qui associent deux types égaux, l'instanciation
de `Refl` dans un _scope_ garantit qu'ils sont équivalent. Par exemple : 

```ocaml
type other_int = int
let _ : (int, other_int) eq = Refl
(* Dès lors, on possède une preuve que [int = other_int]. *)_
```

Cet exemple est assez artificiel car ici, le compilateur sait parfaitement que
`int = other_int`, cependant, il existe des cas où le compilateur ne peut pas
le savoir. Par exemple, si une donnée est fournie à l'exécution du programme, où
il est parfaitement logique que le _type-checker_ n'ai aucune information sur
un type ou encore quand la représentation du type est cachée par l'abstraction.

L'objectif de cette note n'est pas de nous étendre sur `eq` donc ne retenons que
le fait que si on peut construire une valeur `Refl`, on peut avoir une garantie
que deux types _syntaxiquement différents_ sont en fait égaux. 

### Contraindre avec `eq`

Reprenons notre exemple qui fournit une API objet à une liste. Voici son interface:

```ocaml
class type ['a] obj_list = 
  object ('self)
    method length : int
    method append : 'a list -> 'a obj_list
    method uncons : ('a * 'self) option
    method flatten : ???
  end
```

Pour donner un type à `flatten`, ou voudrait imposer que `'a` (le paramètre de
type de la classe `obj_list`) soit une liste. En d'autre mot, nous voudrions
**une preuve que `'a` est de type `'b list`**. Soit garantir que `'a` et `'b
list`, bien que syntaxiquement différents, soient égaux. Rien de plus simple, 
il suffit de demander d'en fournir une valeur de type `('a, 'b list) eq`:

```ocaml
method flatten : ('a, 'b list) eq -> 'b list
```

Maintenant que nous avons une interface qui décrit une liste avec une méthode
`flatten` qui contraint le receveur à être `une liste de quelque chose`,
implémentons concrètement une classe qui implémente `obj_list`. 

#### Implémentation de l'interface `obj_list`

Les premières méthodes (`length`, `append` et `uncons`) sont triviales à
implémenter :

```ocaml
let my_list (list : 'a list) =
  object (self : 'a obj_list)
    val l = list
    method length = List.length l
    method append x = {<l = List.append l x>}
    method uncons = match l with [] -> None | x :: xs -> Some (x, {<l = xs>})
    
    method flatten = ???
  end
```

Maintenant, intéressons-nous à `flatten`. On va récursivement parcourir
la liste en concaténant chaque élément au précédent. Par exemple : 
`[[1]; [2]; [3]]` donnera `[1] @ [2]; [3]`. Au delà des annotations un
peu bruyante, toute l'astuce réside dans l'instanciation de `Refl` pour
nous fournir une évidence sur le fait que `'a = 'b list`.

```ocaml
method flatten : 'b. ('a, 'b list) eq -> 'b list =
  let rec aux : type a b. a #obj_list -> (a, b list) eq -> b list =
  fun list witness -> match list#uncons with
    | None -> []
    | Some (head_list, xs) ->
        let flatten_list : b list =
          let Refl = witness  in head_list
        in flatten_list @ aux xs witness
  in aux self
```

#### Ajout d'une méthode gardée `sum`

Maintenant que nous sommes capable de contraindre certaines méthodes, essayons
d'ajouter une méthode `sum` qui produit la somme d'une liste d'entiers !
Premièrement ajoutons `sum` à notre interface. Cette fois, on veut contraindre
notre paramètre de type à être `int`. Pour cela, il suffit de prendre 
`('a, int) eq` comme témoin d'égalité:

```ocaml
class type ['a] obj_list = 
  object ('self)
    method length : int
    method append : 'a list -> 'a obj_list
    method uncons : ('a * 'self) option
    method flatten : ('a, 'b list) eq -> 'b list
    method sum : ('a, int) eq -> int
  end
```

Ensuite, on peut implémenter la méthode `sum`, qui n'est qu'une utilisation
de la fonction `fold_left`.

```ocaml
method sum : ('a, int) eq -> int =
  let aux : type a. a list -> (a, int) eq -> int = fun list Refl -> 
    List.fold_left (fun acc x -> acc + x) 0 list
  in aux l
```

L'implémentation de `sum` est logiquement plus simple que celle de `flatten`
parce qu'elle n'introduit pas de variables de type complémentaires. Et on peut
tester nos différentes méthodes, on peut invoquer `flatten` sur un objet de type
`'a list obj_list`et `sum` sur un objet de type `int obj_list`.

```ocaml
let a = my_list [ [ 1 ]; [ 2 ]; [ 3 ] ]
let _ = assert ([ 1; 2; 3 ] = a#flatten Refl)
let b = my_list [ 1; 2; 3; 4 ]
let _ = assert (10 = b#sum Refl)
```

Si l'on tente d'appliquer une méthode gardée avec un mauvais type, par exemple, essayer
de faire la somme de notre liste `a` (qui est de type `'a list obj_list`), le pogramme
ne compilera pas, logique, nous essayons d'appeler une méthode gardée **sans respecter
la contrainte qu'elle impose**.

```ocaml
1 | let _ = a#sum Refl
                  ^^^^
Error: This expression has type (int list, int list) eq
       but an expression was expected of type (int list, int) eq
       Type int list is not compatible with type int
```

Soit exactement le comportement attendu ! Nous pouvons maintenant définir des
méthodes qui **contraignent le type du receveur** au moyen d'un témoin
d'égalité. **mission complete** !

## Conclusion

Il est surprenant que les méthodes gardées ne soient pas présentes dans tous les
langages OOP, possédant une vérification statique des types, parce qu'elles
permettent d'exprimer plus de méthodes, tout en **préservant la sémantique
d'envoi de message**, si chère à la programmation orientée objets. N'étant pas
un grand utilisateur de langages de programmation orientée objets (OCaml est le
seul que je pratique régulièrement), je ne suis pas aux faits de langages
fournissant un support syntaxique des méthodes gardées. Je sais par contre,
depuis peu, pointé par [Nicolas Rinaudo](https://twitter.com/NicolasRinaudo),
que le langage [Scala](https://www.scala-lang.org/) utilise un encodage
similaire à celui proposé dans cette note mais où le témoin d'égalité est
fournit _implicitement_, allégant ainsi l'appel, n'obligeant pas l'utilisateur à
fournir manuellement `Refl`.

Même si l'encodage est un peu lourd, et que l'on pourrait imaginer un support
natif dans le langage pour simplifier la définition de méthode gardée, 
**manipuler explicitement un témoin d'égalité de type permet de les encoder**.
Est-ce utile ? Comme la programmation OOP est rarement encouragée en OCaml, 
_probablement pas_, mais c'était tout de même amusant de présenter un cas
d'usages concret et pratique à l'utilisation de témoins d'égalités !
