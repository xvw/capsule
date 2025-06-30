---
page_title: OCaml, modules, and import schemes
description:
  Using the module system open and include statements to reproduce common 
  import patterns from other languages
tags: [programming, ocaml, modules]
section: programming
published_at: 2025-06-30
display_toc: true
origin: /pages/modules-import.html
synopsis:
  The [OCaml](https://ocaml.org) module system can be intimidating, and it 
  typically involves the use of many keywords—for example, `open` and `include`,
  which allow importing definitions into a module. Since version OCaml `4.08`, 
  the `open` primitive has been *generalized* to allow the opening of 
  **arbitrary module expressions**. In this article, we’ll explore how 
  to use this generalization to reproduce a common practice in other 
  languages, what I somewhat pompously call _import strategies_, to describe 
  patterns like `import {a, b as c} from K`, without relying on a 
  (_sub-_)language dedicated specifically to importing.
---

The generalization of `open` is documented in the paper [_"Extending
OCaml's_
`open`"](https://www.cl.cam.ac.uk/~jdy22/papers/extending-ocamls-open.pdf),
presented at the [OCaml Workshop
2017](https://ocaml.org/workshops/ocaml-users-and-developers-workshop-2017),
and implemented—in OCaml version `4.08`, in pull requests
[`#1506`](https://github.com/ocaml/ocaml/pull/1506) and
[`#2147`](https://github.com/ocaml/ocaml/pull/2147) (likely followed
by a few fixes after merging). This generalization greatly increases
the flexibility of the `open` construct, making it possible to use
various tricks to finely control the import of _module components_
into another module.

> Some of the techniques shown here are directly adapted from the
> paper, which, beyond discussing implementation strategies, also
> explores various use cases—though some of them fall outside the
> scope of this article, as they don't relate to _import strategies_.

It's likely that many of the _tricks_ presented here won't become
_idiomatic_ in OCaml codebases. In my view, their main purpose is to
highlight the increased flexibility of the `open` primitive, without
relying on a **dedicated syntactic extension** for importing
components—while also showcasing a few somewhat _far-fetched_
encodings... just for the sake of demonstration.

## Importing Module Components

When describing an OCaml program, one constructs collections of
modules that export components (types, _submodules_, exceptions, and
functions). It is therefore crucial to finely control their
accessibility from other modules. For this, we have two primitives —
`open` and `include` — whose difference is subtle. To clearly describe
the differences between these two primitives, we will base ourselves
on this (somewhat artificial) module, which we will use in the
following examples:

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

As you may notice, the implementation—and _de facto_, the signature —
of the module is not very interesting; it will only serve to
illustrate my point. What we want is to use, in a file `c.ml` (which
will denote the module `C`), the components described in `A`.

The first approach, and the most obvious one, is to use their full
names (a **fully qualified** call) by using the module **path**. For
example, let's create a pair of `int` and `A.a`:

```ocaml
let c_a = (A.a_a, A.B.b_b)
```

However, using fully qualified paths can sometimes be *tedious* (or
even completely unreadable). That’s why we’ll look at how to **import
components from module `A` into module `C`**. However, since the goal
of this article is not to be a tutorial on `open` and `include`, but
to explore generalized opens to describe import schemes, we won’t go
into detail about these two features, which are already thoroughly
documented in the [language
manual](https://v2.ocaml.org/releases/5.1/htmlman/index.html) — in the
sections dedicated to
[modules](https://v2.ocaml.org/releases/5.1/htmlman/moduleexamples.html),
[overriding through
opens](https://v2.ocaml.org/releases/5.1/htmlman/overridingopen.html),
and [generalized opens](https://v2.ocaml.org/releases/5.1/htm)

### Module Opening

The `open` primitive allows _importing_ the components of a module
into another module, **without re-exporting** them in the current
module. For example, let's use `open` to rewrite the function `c_a`:

<div class="side-by-side">

```ocaml
open A

let c_a = (a_a, B.b_b)
```

```ocaml
val c_a : int * A.a
```
</div>

As we can see from the (_inferred_) signature, it **does not export**
the _components_ of module `A` and references the type `a` by its full
path. It would also be possible to open `A.B` using `open A.B` or even
`open B` (since `A` is already open).

In the same way that it's possible to open modules in the
_implementation_, it's also possible to open modules in the
_signature_, allowing shorter paths when referring to types (or
modules).

#### Local module opening

The opening cases we previously observed were **global** to the module
in which they were invoked, which can be somewhat restrictive when you
want to open multiple modules, exposing, for example, arithmetic
operators. Fortunately, it's possible to open **at the expression
level**, in two different ways:

- `let open Module in ...` opens the module _locally_ — lexically
  scoped — within the following expression block. This is very useful
  when you want to open a module only within a function;


- `Module.(...)` opens the module — also lexically scoped — only
  within the parentheses. This is very useful when you want to open a
  module just within a single expression. For example, imagine the
  `Float` module exposes a submodule `Infix` providing the usual
  arithmetic operators; you could describe a floating-point operation
  like this: `let x = Float.Infix.(1.2 + 3.14 + 1.68)`.

The absence of local opening can be very limiting. For example, the
language [`F#`](https://fsharp.org/) only allows [global
openings](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/import-declarations-the-open-keyword),
which makes defining operators in a dedicated module cumbersome. This
encourages the use of [operator
overloading](https://learn.microsoft.com/en-us/dotnet/csharp/language-reference/operators/operator-overloading)
(or even [Statically Resolved Type
Parameters](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters)),
sometimes resulting in considerable complexity.


### Module inclusion

The `include` primitive is very similar to the `open` primitive except
that it — as its name suggests — includes the contents of the targeted
module into the body of the module where it is called. For example, if
we had used `include` instead of `open` in our previous example, let’s
observe the impact on the inferred signature:

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


Even though the signature _varies slightly_ from the one we defined
earlier — there are some subtleties regarding the propagation of
**type and module equalities**, described in the section ["Recovering
the type of a
module"](https://v2.ocaml.org/releases/5.1/htmlman/moduletypeof.html),
related to
[strengthening](https://discuss.ocaml.org/t/extend-existing-module/1389/7)
— we can see that the contents of module `A` have been _included_,
_added_ to module `C`. Unlike opening, it is **not possible to do
local inclusion**, which makes perfect sense because **inclusion at a
local level would have exactly the same effect as opening**.

From my personal experience, I generally identify two specific use
cases for using `include`:

- Extending an existing module (for example, adding a function to the
  `List` module within my project, or to extend the standard library);

- Including submodules within a parent module. For example, it is
  quite common that within a module, there are operators (or [binding
  operators](https://v2.ocaml.org/releases/5.1/htmlman/bindingops.html#start-section))
  which are often _confined_ in dedicated submodules (usually `Infix`
  and `Syntax`). For API reasons, re-exporting them at the _parent
  module_ level can be a good idea. This is, in fact, [intensively
  used in
  Preface](https://github.com/xvw/preface/blob/master/lib/preface_specs/indexed_functor.mli#L72).

Inclusions are a powerful tool for extension, but also for code
sharing, and there is **much to say** because it often involves
_substitution_, _destructive substitution_, or _strengthening_, which
would require writing a dedicated article!

### Opening VS Inclusion before OCaml `4.08`

Before the merge of the proposal for **generalizing opens**, there was
a **significant** difference in the usage of `open` versus `include`:
the parameter each primitive accepted.

- `open` took a [module
  path](https://v2.ocaml.org/releases/4.07/htmlman/names.html#module-path),
  for example: `A` or even `A.B.C` ;
  
- `include` took [a module
  expression](https://v2.ocaml.org/releases/4.07/htmlman/modules.html#module-expr),
  for example: paths like `A` or `A.B.C`, but also functor
  applications like `F(X)`, modules constrained by signatures `(M :
  S)`, or directly the module body `struct ... end`.

This difference in flexibility involved rather cumbersome workarounds
to achieve the same level of expressiveness for `open` compared to
`include`. Indeed, to allow `open` to work with functor applications
or constraints, it was necessary to use intermediate modules.

In the case of using a path, the two calls are — in terms of
expressiveness — identical, because a path can also be a module
expression:

<div class="side-by-side">

```ocaml
include A.B.C
```

```ocaml
open A.B.C
```
</div>


However, as soon as we try to open somewhat more complex cases,
natively supported by `include`, we quickly had to introduce
intermediate modules:

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

Even if at first glance it may not seem dramatic, introducing
intermediate modules requires not exporting them in the signature of
the module that opens them (in its `mli` or signature). Additionally,
although `open` and `include` are often presented symmetrically, their
asymmetry in the parameters they take was regrettable. Fortunately,
since version `4.08` (released in June 2019), thanks to the
generalization of openings, `open` now accepts an arbitrary module
expression, just like `include`, allowing us to use it to mimic those
import schemes mentioned at the beginning of this article.

### A first benefit

The fact that the `open` primitive can take arbitrary module
expressions offers a first benefit — _probably trivial if you like
writing your module signatures_: **the definition of local
expressions**. Indeed, opening a module does not export its contents,
so it is possible to very easily define non-exported top-level values
by defining them inside an `open struct ... end` expression. For
example:

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

The functions `x` and `y` are **confined within an open block**, so
they are not exported, which can be very useful when you want to
define values (types or modules) locally. Moreover, since **a
structure can be constrained by a signature**, it is also possible,
for example, to encapsulate shared mutable state within the local
open, **preventing it from escaping the scope of its opening**. Here
are two examples where it is impossible to modify the reference cell
without going through the exported combinators, the first using a
constraint, the second using nested local opens:

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

Even though the classic approach used by an OCaml developer is to use
signatures for **encapsulation** concerns, when used as such, the
generalized module opening allows you to hide, in a relatively elegant
way, certain _boilerplate elements_ necessary for building a module
(which should expose a public API via a signature).

Now that we have looked at _some examples_ of using generalized
opening, let's see how it makes having a dedicated language for import
schemes **questionably useful**.

## Import Schemes

Since **modularity** has become a cornerstone of software design —
JavaScript, for example, has [layered many
proposals](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Modules)
where the modularization and import strategy depends on the framework
or build system used — languages like
[Python](https://www.python.org/) and
[Haskell](https://www.haskell.org/) have introduced features similar
to OCaml's `open` primitive to import components into the current
module. Generally, these import directives form _a small language of
their own_, governed by specific rules and grammar. Since `open` has
been generalized in OCaml, it is possible to _encode_ much of the
usual import patterns — even though some, like those proposed by
Haskell, may be somewhat verbose to encode.

For the example, we will use the following module as the import
target:

```ocaml
module Foo : sig
  val x : int
  val y : string
  val z : char
end
```

However, there is an **essential nuance** regarding the notion of
**qualified import**: in Haskell, to use a module, it **must be
imported**, whereas in OCaml, it is the build system (compilation
scheme) that indicates whether a module is present or not. In our
various examples, we will assume that the module `Foo`, which we
described earlier, is present in our compilation scheme. Therefore,
for qualified imports — where terms are always prefixed by their
module path — no additional ceremony is necessary. It is important to
keep in mind that the tricks presented below can be combined to build
very specific (and probably unrealistic) import schemes, demonstrating
that with a bit of verbosity, the _language_ approach still allows
more flexibility than a rigid import _DSL_.


### Unqualified Import

The first directive simply imports the definitions from `Foo` into the
current module, namely the functions `x`, `y`, and `z`:

<div class="side-by-side">

```haskell
import * from Foo
```


```ocaml
open Foo
```

</div>

There is no subtlety here; importing all the terms exposed by `Foo`
simply consists of opening it. There isn't much more to say, as we are
not leveraging any particular language subtlety here.

### Renamed Qualification

Another common directive consists of renaming the module, for example,
importing `Foo` under the name `Bar` so that `Bar.x`, `Bar.y`, and
`Bar.z` are accessible in the module. For this, one can use
[type-level module
aliases](https://v2.ocaml.org/releases/5.1/htmlman/modulealias.html).

<div class="side-by-side">

```haskell
import Foo as Bar
```


```ocaml
open struct module Bar = Foo end
```

</div>

We use the `open struct ... end` construct to keep our alias hidden
from the module's public API. This ensures that the alias doesn’t leak
outside the module. However, if the module has an explicit signature,
this is less critical, as simply omitting `Bar` from the signature
will prevent it from being exposed.

#### Presence of the renamed module

Using a **module alias** leaves the module `Foo` accessible, and in
some cases, we might want to make it inaccessible. The simplest
solution is to simply _empty the module_ and, to clarify the error
related to its undesired use, we can add an
[alert](https://v2.ocaml.org/releases/5.1/htmlman/alerts.html#start-section)
indicating that the module has been removed:

```ocaml
open struct
  module Bar = Foo
  module Foo = struct end [@@alert erased]
end
```

Making the use of the module `Foo` within the current module
impossible by raising an alert.  However, since it is common practice
to provide module signatures — and thereby control the public API — you
will more often encounter renamings like: `module Bar = Foo`.
Furthermore, I am not convinced that restricting access to the
original module is truly problematic.


#### Nested renaming

One might imagine renaming like this: `import Foo as Bar.Baz`, but
OCaml does not allow full path descriptions of the form `module
Bar.Baz = Foo`. Instead, you need to describe the module nesting
hierarchy explicitly, like this, making the functions `Bar.Baz.x`,
`Bar.Baz.y`, and `Bar.Baz.z` available in the current module:

```ocaml
open struct 
  module Bar = struct 
    module Baz = Foo 
  end 
end
```

Which, I admit, is a bit verbose, but if for some obscure reason you
want to rename an existing module using a composed path, you can do so
by explicitly declaring the module hierarchy.


### Selective Import

Sometimes, importing the **entire** module is overkill, and we only
want a few components exposed by it. That’s why it’s possible to
import just a part of a module. In this example, we want to import
only `x` and `y`:

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

Although this approach is also somewhat verbose, it imports only the
functions `x` and `y` into the current module. It’s possible to
simplify this syntax by using _tuples_ and local openings:

```ocaml
open struct
  let (x, y) = Foo.(x, y)
end
```

Alternatively, it is also possible to **constrain the opening** using
a signature, which requires specifying the types of the functions to
export:

```ocaml
open (Foo : sig
  val x : int
  val y : string end)
```

Several proposals
([`#10013`](https://github.com/ocaml/ocaml/pull/10013) and
[`#11558`](https://github.com/ocaml/ocaml/issues/11558#issuecomment-1255946104))
have been made to enable the use of
[_let-punning_](https://v2.ocaml.org/releases/5.1/htmlman/bindingops.html#ss%3Aletops-punning),
which would make the syntax less verbose. However, the first proposal
dropped punning for module members, and the second is still at the
issue stage.

#### Selective import with renaming

Since the first two proposals leave the user in control of naming
(it’s just _function redefinition_), renaming can be trivially
integrated. In this example, we expose `x` and `new_y_name`, which
calls `Foo.y`:

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

Unsurprisingly, renaming is quite straightforward. However, if we
wanted to use the signature-based approach, it would require a bit
more trickery by combining an `open` with an `include`:

```ocaml
open (struct
    include Foo
    let new_y_name = y
  end : sig
    val x : int
    val new_y_name : string end)
```

However, this last proposal is so verbose that it becomes somewhat
irrational — especially compared to the previous one — and I imagine
it’s the kind of code you’ll never see — or at least never want to see
— in a regular codebase. That said, even though it’s heavy, I find it
still quite clearly demonstrates **how it is possible to compose the
different constructions and tools we’ve seen earlier**.


### Import by Exclusion

Haskell has a somewhat special import modifier that I hesitated to
mention for a long time because I had no idea how to implement it. But
once again, thanks to the invaluable help of
[@octachron](https://github.com/Octachron) and
[@xhtmlboi](https://github.com/xhtmlboi), who both gave me roughly the
same solution, here it is. This modifier allows importing an entire
module **except** for a list of components. In this example, `x` and
`y` will be imported because we import **the whole `Foo` module**,
except for the function `z`.

```haskell
import Foo hidding (z)
```

OCaml does not natively support constructing **intersections** or
**differences** of modules. The solution proposed by
[@octachron](https://github.com/Octachron) and
[@xhtmlboi](https://github.com/xhtmlboi) relies on function rewriting
combined with the use of an alert, in a way somewhat similar to what
we did to exclude a renamed module. However, before examining their
solution, let's take a brief detour into the **empty variant**.

#### Empty Variant

In OCaml, it is possible to define a sum type with no constructors
using [**the empty
variant**](https://v2.ocaml.org/releases/5.1/htmlman/emptyvariants.html#start-section),
which essentially allows you to _describe unrepresentable values_. To
define it, you simply create a sum type with an empty branch (which,
**important**, is not the [bottom
type](https://en.wikipedia.org/wiki/Bottom_type), denoted `⊥`):

```ocaml
type empty = |
```

To convince yourself that the compiler can reject cases containing a
value of type `empty`, you can easily experiment with pattern
matching. In the example below, the compiler raises no warnings
because the patterns are exhaustive. Since it's impossible to
construct a value of type `empty` (except by cheating, for instance
using sorcery like the infamous `Obj.magic` function), we can _refute_
handling the error case:

```ocaml
let f : ('a, empty) result -> 'a = function
  | Ok x -> x
```

But in our use case, it’s not the refutation that interests us, rather
the fact that it’s impossible to describe a value of type `empty`,
which we can leverage to exclude certain functions.


#### Function Suppression

The solution proposed to me is to make the functions we want to remove
from the module **impossible to call**. To do this, we will first
create a _placeholder_ function that we will use to override an
existing function:

```ocaml
type empty = |
let expelled : empty -> unit = fun _ -> ()
```

At first glance, our `expelled` function is impossible to call because
it requires a value of type `empty`, which cannot be
produced. Therefore, we can **include the module we want to refine**
and then **override the functions we want to exclude** with our
`expelled` function, associating them with an alert to clarify the
error triggered by using a removed function:

```ocaml
open struct
  include Foo
  let (z [@alert expelled]) = expelled
end
```

_And there you have it_, we can be pretty sure that using `z` will
cause a compilation error, and compiling a module that uses it will
raise a warning. However, the solution is far from perfect because it
**does not remove** the component from the module. To be honest, I've
**very rarely** found myself missing this feature natively. From my
perspective, selective importation usually suffices quite well.

## Type Anchoring

Before concluding this article,
[@octachron](https://github.com/Octachron) pointed out to me the
partial asymmetry between `open` and `include` when it comes to
anonymous modules (i.e., module expressions `struct ... end`). This is
an issue I had already encountered theoretically, having attended the
May 2023 event of [OCaml Users in Paris](https://oups.frama.io/) where
[Clément Blaudeau](https://clement.blaudeau.net/) gave his talk
[_Retrofitting OCaml
Modules_](https://www.irill.org/videos/OUPS/2023-05/blaudeau.html),
which was a summary of his paper [_OCaml modules: formalization,
insights and
improvements_](https://inria.hal.science/hal-03526068/file/main.pdf).

Since `open` does not export the opened components, without
associating an explicit signature, some expressions cannot be
typed. For example:

```ocaml
open struct type t = A end
let x = A
```

In this example, the type `t` (and its constructor `A`) is present in
the current scope; however, since it is not exported, it is impossible
to correctly type `x`. If the module had a signature, one could easily
realize that there is no acceptable type for `x` and that one should
either change the `open` directive or avoid exporting `x`. This issue
is known as **type anchoring**, which is extensively described in the
paper cited at the beginning of this section.

## Conclusion

I sincerely believe that in daily OCaml use, we very rarely encounter
such needs. The goal of this article was essentially to show how to
use certain primitives related to the module system, alongside the
generalized `open` feature, to demonstrate that having expressive and
composable primitives allows one to reproduce, sometimes trivially
(and sometimes less so), common import patterns found in other
programming languages. There are probably other _fun_ encodings —
likely based on _functors_ — so don’t hesitate to share them with me
so I can update this article!

To conclude, I would add that even though I proudly *boasted* that
programming this way in OCaml is uncommon, the existence of packages
like [ppx_import](https://ocaml.org/p/ppx_import/latest) or
[ppx_open](https://github.com/johnyob/ppx-open) shows that some
syntactic sugar wouldn’t hurt—especially for selective imports.
