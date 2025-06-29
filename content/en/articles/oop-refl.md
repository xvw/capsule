---
page_title: Guarded methods in OCaml
description: 
   Implementation of "guarded methods" using type equality witnesses
tags: [programming, type, oop, ocaml, gadt]
section: programming
published_at: 2025-06-29
display_toc: true
synopsis:
  "**Guarded methods** allow attaching **constraints** to the receiver 
  (`self`) **only for certain methods**, thus allowing these methods to be 
  called only if the receiver satisfies these constraints (these _guards_). 
  [OCaml](https://ocaml.org) does not syntactically allow defining this kind 
  of method _directly_. In this note, we will see how to encode them using 
  a **type equality witness**."
origin: /pages/oop-refl.html
---

**Guarded methods** make it possible to attach **constraints** to the
receiver (`self`) **only for certain methods**, meaning these methods
can only be called if the receiver satisfies those constraints (these
_guards_). [OCaml](https://ocaml.org) does not, syntactically, allow
defining this kind of method _directly_. In this note, we’ll look at
how to encode them using a **type equality witness**.


## Problem presentation

When a language (where type checking is done before the program runs,
like in Java or OCaml) introduces **parametric polymorphism** (Java's
_generics_), it's sometimes possible to constrain type variables. For
example:

```java
class MyClass<T extends S> { ... }
```

We make `MyClass` generic by assuming that the type variable `T` is a
subtype of `S`. The problem is that the constraint applies to **the
entire class**. Yet sometimes, we’d like to have constraints apply
**only to certain methods**. For example, let’s say we have a class
`MyList` describing a list:


```java
class MyList<A> extends ArrayList<A> {
   public int length() {
     return this.size();
   }
}
```

How can we define a `flatten` method that, for a list like `[[1, 2,
3], [4, 5]]`, would produce the list `[1, 2, 3, 4, 5]`? If we place
the constraint at the class level, we force our list to be "_always a
list of lists_," which is very limiting. To implement such a method,
we have three theoretical approaches available.



### Moving the method outside the class

The first solution is the most obvious: simply "_cheat_" by moving the
method outside the class body (for example, into the static context or
a _companion object_):


```java
class MyList<A> extends ArrayList<A> {
   public static <A> MyList<A> flatten(MyList<MyList<A>> list) {
      // Flatten's implementation
   }
   public int length() {
     return this.size();
   }
}
```

This approach works and doesn’t require any special ceremony. However,
it forces the developer to keep track of which methods are in the
class body and which are in the static context. Moreover, it breaks
the systematic approach of sending messages to an instance (often
presented as one of the key arguments in favor of object-oriented
programming).


### Extension methods


[Kotlin](https://kotlinlang.org/) (and others, like
[C#](https://docs.microsoft.com/en-us/dotnet/csharp/)) offer
[extension methods](https://kotlinlang.org/docs/extensions.html)
which, in addition to allowing **the extension of an already existing
class** (which can be very useful for adding behavior to the `String`
class, which is `final` in Java), also provide more flexibility in
defining the _receiver_. For example, we could write `flatten` like
this (in Kotlin):


```kotlin
class MyList<A> : ArrayList<A> { ... }
fun <A> MyList<MyList<A>>.flatten() = ...
```


Even though this solution seems nearly perfect, it still requires the
method to be defined **outside the class**, which might potentially
mean having to make certain members of the class _public_ in order to
be accessible from an extension (looks like potentials _leaky
abstractions_). However, it still **preserves the systematic
message-sending approach while allowing for more fine-grained
qualification of the receiver**.



### Guarded methods


The final approach is probably the most ideological, as it keeps the
method definition within the class. It doesn't force any escaped
abstractions. This is the idea of **guarded methods**, the ability to
add constraints on the generic parameter at the method definition
level. In an **imaginary** syntax (this code compiles because it's not
syntactically invalid, but it doesn’t produce the intended effect):


```kotlin
class MyList<A> : ArrayList<A>() {
    fun length() = size
    fun <B> MyList<MyList<B>>.flatten() =
        // Implémentation de flatten
}
```

Even though this doesn’t seem significantly different from classic
extension methods (as evidenced by their syntax, which **inside the
class body** seems sufficient), it addresses all the issues raised
earlier:

- we can characterize the receiver more precisely than in a _normal_ method
- we don’t break the regular message sending
- we still benefit from available members (so we don’t escape
  representations)

Although guarded methods seem necessary, unfortunately, I don’t know
of any _mainstream_ languages that allow their definition. That’s very
sad. Fortunately, in OCaml, it is possible to _encode_ them.


### OOP/FP symmetry: theory and practice

Since guarded methods are quite rare in popular programming languages,
I discovered their existence fairly recently while reading the
[slides](http://gallium.inria.fr/~scherer/doc/oo-fp-symmetry-bob-2020.org)
from the presentation "_[The Object-Oriented/Functional-Programming
symmetry: theory and
practice](https://www.youtube.com/watch?v=TrameN7BTCQ)_" by [Gabriel
Scherer](http://gallium.inria.fr/~scherer/).


I recommend this presentation, which showcases a **symmetry** between
the tools of statically typed functional programming and
object-oriented programming. Even though this symmetry has been
observed and studied many times, the presentation is comprehensive and
accessible (and relatively unbiased, discussing the pros and cons of
both approaches). Unfortunately not covered during the presentation
(_time is often the enemy of a presenter_), an entire section on
guarded methods is included in the slides. The original example offers
a symmetrical observation between the implementation of the `flatten`
function in a classic functional style:


```ocaml
type 'a list = ...
let rec length : 'a list -> int = ...
let rec concat : 'a list -> 'a list -> 'a list = ...

let rec flatten : 'a list list -> 'a list = function
  | [] -> []
  | x::xs -> x @ flatten xs
```


And the implementation of a `flatten` method if we were in the
object-oriented world, posing exactly the problem introduced in this
note. The question is: what type should `flatten` have?


```ocaml
class type ['a] olist = object
  method length : int
  method concat : 'a olist -> 'a olist

  method flatten : ???
end
```

He therefore proposes this syntax, which implies a guard on the
`flatten` method:


```ocaml
method flatten : 'b olist with 'a = 'b olist
```

This syntax allows describing a guarded method and could be
generalized like this: `method method_name : return_type with
generic_type = other_type`. Similar to **substitutions** in modules,
we could specify constraints on multiple generics using `and`. For
example: `method foo : string with 'a = string and b = int` for a
class parameterized by two types: `class ['a, 'b] t`.


Additionally, this syntax would also allow defining specific behaviors
elegantly. For example, for our `olist` type, we could provide a `sum`
method if the elements of the list are integers:


```ocaml
class type ['a] olist = object
  method length : int
  method concat : 'a olist -> 'a olist
  method flatten : 'b olist with 'a = 'b olist
  method sum : int with 'a = int
end
```

All of this sounds extraordinary, **but unfortunately, this syntax is
not available** in OCaml. That’s annoying! Don’t worry, it is possible
to **encode it** using a few small tools.


## Guarded methods in OCaml


> Even though I had a fairly clear idea of the tools to use for
> encoding guarded methods, after running into a few _corner cases_, I
> decided to call on someone in the OCaml community who never asks
> questions but always answers them expansively: [Florian
> Angeletti](https://github.com/Octachron), also known as
> **Octachron**. (A fun little note: `octachron` is the name of a MIDI
> drum sequencer, so when I searched his nickname on _Google_, the
> suggestions immediately included `octachron ocaml`).


Our goal is to allow adding a constraint to certain methods so that
they are only accessible if the receiver’s type satisfies it. Without
modifying the language syntax, modeling a constraint can **consist of
providing an additional parameter that enforces it**. In other words,
we want to provide **evidence**.



### Provide a type equality witness

Since the introduction of [generalized algebraic data
types](https://v2.ocaml.org/releases/4.14/htmlman/gadts-tutorial.html#sec63)
in the language, there is a fairly straightforward way to define a
type equality witness:


```ocaml
type (_, _) eq =
  | Refl : ('a, 'a) eq
```

The `eq` type, which has only one constructor: `Refl`, allows
representing type equalities **not known by the
_type-checker_**. Since we can only construct `Refl` values that
associate two equal types, instantiating `Refl` within a _scope_
guarantees that those types are equivalent. For example:


```ocaml
type other_int = int
let _ : (int, other_int) eq = Refl
(* Now, we have a proof of [int = other_int]. *)
```

This example is somewhat artificial because here the compiler knows
perfectly well that `int = other_int`. However, there are cases where
the compiler cannot know this. For example, when data is provided at
runtime, where it makes perfect sense that the _type-checker_ has no
information about a type, or when the type’s representation is hidden
by abstraction.

The goal of this note is not to delve into `eq`, so let’s just keep in
mind that if we can construct a `Refl` value, we have a guarantee that
two _syntactically different_ types are actually equal.


### Constrain with `eq`

Let’s return to our example that provides an object API for a
list. Here is its interface:



```ocaml
class type ['a] obj_list =
  object ('self)
    method length : int
    method append : 'a list -> 'a obj_list
    method uncons : ('a * 'self) option
    method flatten : ???
  end
```

To give a type to `flatten`, we want to impose that `'a` (the type
parameter of the `obj_list` class) is a list. In other words, we want
**a proof that `'a` is of type `'b list`**. That is, to guarantee that
`'a` and `'b list`, though syntactically different, are equal. It’s
simple: just require a value of type `('a, 'b list) eq` to be
provided:


```ocaml
method flatten : ('a, 'b list) eq -> 'b list
```

Now that we have an interface describing a list with a `flatten`
method that constrains the receiver to be `a list of something`, let’s
concretely implement a class that implements `obj_list`.


#### Implementing the interface `obj_list`

The first methods (`length`, `append`, and `uncons`) are
straightforward to implement:



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

Now, let’s focus on `flatten`. We will recursively traverse the list,
concatenating each element to the previous one. For example, `[[1];
[2]; [3]]` will become `[1] @ [2]; [3]`. Beyond the somewhat noisy
annotations, the entire trick lies in instantiating `Refl` to provide
evidence that `'a = 'b list`.


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

#### Adding a guarded method `sum`

Now that we’re able to constrain certain methods, let’s try adding a
`sum` method that produces the sum of a list of integers! First, let’s
add `sum` to our interface. This time, we want to constrain our type
parameter to be `int`. To do that, we simply take `('a, int) eq` as a
type equality witness:


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

Next, we can implement the `sum` method, which is just a use of the
`fold_left` function.


```ocaml
method sum : ('a, int) eq -> int =
  let aux : type a. a list -> (a, int) eq -> int = fun list Refl ->
    List.fold_left (fun acc x -> acc + x) 0 list
  in aux l
```

The implementation of `sum` is logically simpler than that of
`flatten` because it doesn’t introduce additional type variables. And
we can test our different methods: we can invoke `flatten` on an
object of type `'a list obj_list` and `sum` on an object of type `int
obj_list`.



```ocaml
let a = my_list [ [ 1 ]; [ 2 ]; [ 3 ] ]
let _ = assert ([ 1; 2; 3 ] = a#flatten Refl)
let b = my_list [ 1; 2; 3; 4 ]
let _ = assert (10 = b#sum Refl)
```

If we try to apply a guarded method with the wrong type, for example,
trying to sum our list `a` (which is of type `'a list obj_list`), the
program will not compile. This makes sense, as we are trying to call a
guarded method **without respecting the imposed constraint**.


```ocaml
1 | let _ = a#sum Refl
                  ^^^^
Error: This expression has type (int list, int list) eq
       but an expression was expected of type (int list, int) eq
       Type int list is not compatible with type int
```


Exactly the expected behavior! We can now define methods that
**constrain the receiver’s type** by means of a type equality
witness. **Mission complete**!




## To conclude

It is surprising that guarded methods are not present in all
statically typed OOP languages, since they allow expressing more
methods while **preserving the message-passing semantics** so dear to
object-oriented programming. Not being a heavy user of object-oriented
programming languages (OCaml is the only one I use regularly), I’m not
aware of languages offering syntactic support for guarded
methods. However, I recently learned, pointed out by [Nicolas
Rinaudo](https://twitter.com/NicolasRinaudo), that the language
[Scala](https://www.scala-lang.org/) uses a similar encoding, but
where the type equality witness is provided _implicitly_, thus
lightening the call and not forcing the user to manually provide
`Refl`.

Even though the encoding is somewhat heavy, and one could imagine
native language support to simplify the definition of guarded methods,
**explicitly manipulating a type equality witness allows us to encode
them**. Is it useful? Since OOP programming is rarely encouraged in
OCaml, _probably not_, but it was still fun to present a concrete and
practical use case for equality witnesses!

