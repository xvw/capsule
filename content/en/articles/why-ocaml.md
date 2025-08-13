---
page_title: Why I chose OCaml as my primary language
origin: /pages/why-ocaml.html
description: 
  A detailed explanation of why I chose OCaml
  as the ‘default’ programming language for every project.
tags: [programming, ocaml, opinion]
section: programming
published_at: 2025-08-13
display_toc: true
synopsis:
  I started using the [OCaml](https://ocaml.org) language regularly 
  around 2012, and since then, my interest and enthusiasm for this language 
  have only grown. It has become my preferred choice for almost all my 
  personal projects, and it has also influenced my professional choices.

  Since 2014, I have been actively participating in public conferences 
  dedicated to programming and software development, where I often express 
  my enthusiasm for OCaml in ways that may be a bit over the top 
  (but always passionate). This has earned me, in a friendly way, the 
  nickname _OCaml evangelist_ — a title that, I admit, I find very 
  flattering.
  
  Moreover, I’m not alone in thinking this. Despite the common misconception 
  that OCaml wouldn’t be a pragmatic choice for industry, major companies 
  such as [Meta](https://engineering.fb.com/?s=ocaml), 
  [Microsoft](https://www.microsoft.com/en-us/research/project/slam/?from=https://research.microsoft.com/en-us/projects/slam/&type=exact), 
  [Ahref](https://tech.ahrefs.com/tagged/ocaml), 
  [Tarides](https://tarides.com), 
  [OCamlPro](https://ocamlpro.com/), 
  [Bloomberg](https://www.bloomberg.com/company?s=ocaml), 
  [Docker](https://github.com/moby/vpnkit), 
  [Janestreet](https://www.janestreet.com/technology/), 
  [Citrix](https://xapi-project.github.io/), 
  [Tezos](https://tezos.com), and 
  [many others](https://ocaml.org/industrial-users) actively use it.

---

In this _opinion piece_, I will try to briefly share my encounter with
the language and list its advantages — organized into several sections
covering _the language itself_, its ecosystem, and its community. I
will also attempt to _debunk_ some popular myths (or misconceptions)
found on the Internet. For the sake of transparency, it is important
to note that, at the time of writing, my [professional
work](https://tarides.com) **involves working for and on the OCaml
ecosystem**. However, readers who have followed me for several years
can attest that I was promoting the language long before I was paid to
work on the OCaml ecosystem, _sometimes rather immoderately_.

## Foreword

First, this article will explain why I **personally** believe that
OCaml is a relevant choice in many contexts. My goal is not
specifically to convince you—although that would be a very welcome
_side effect_ — and it’s quite likely that many of the arguments I
present will also apply to other languages!

Also, very often, when I suggest OCaml to people who want to explore
new languages or try out solutions written in OCaml, I’m kindly told
that _I’m always promoting OCaml_. It’s amusing to notice that when
the suggestions involve languages adopted _by default_, like
JavaScript, or more recent ones like
[Rust](https://www.rust-lang.org/) or [Go](https://go.dev/), they tend
to trigger fewer reactions. This is probably because people
_implicitly_ assume that proposing a _lesser-known_ language leans
toward irrationality and personal preference. From my point of view,
**suggesting OCaml is, in many cases where fine-grained memory control
is not needed, just as relevant as suggesting Rust** (and probably
more so).

To wrap up this preface, many people first encountered OCaml (or [Caml
Light](https://caml.inria.fr/caml-light/release.fr.html)) during their
undergraduate studies or in preparatory classes, often using it in
contexts far removed from industry. As for me, I started getting
interested in OCaml much earlier, thanks to the [Site du
Zéro](http://sdz.tdct.org/), where a small community of functional
programming enthusiasts promoted less _mainstream_ languages like
[OCaml](https://ocaml.org), [Erlang](https://www.erlang.org/), and
[Haskell](https://www.haskell.org/). My interaction with OCaml at
university was **just a bonus**.

### Other resources

I’m not the first to document the reasons for choosing OCaml. There
are many other resources that, in my opinion, are also worth checking
out, and they show that OCaml users are generally very satisfied — so
much so that they’re motivated to share _how and why_ we chose the
language as our main technology:

- ["**Why
  OCaml?**"](https://dev.realworldocaml.org/prologue.html#why-ocaml),
  the prologue of the book [Real World
  OCaml](https://dev.realworldocaml.org/toc.html), which presents
  factual advantages of using OCaml (and whose introduction includes a
  timeline). While the book is excellent in many respects, I’ve gotten
  into the habit of not recommending it because I find its usage
  approach quite biased, suggesting libraries by default that aren’t
  necessarily widely accepted in the community.

- ["**Better Programming Through
  OCaml**"](https://cs3110.github.io/textbook/chapters/intro/intro.html),
  the prologue of the book (accompanied by videos) [OCaml Programming:
  Correct + Efficient +
  Beautiful](https://cs3110.github.io/textbook/cover.html), which
  mainly explains how learning OCaml can improve a developer’s skills
  in other, more popular technologies. The book is fairly recent, and
  it’s the one I **now recommend as the go-to resource** for getting
  started with OCaml.

- [**Talk: "Why
  OCaml?"**](https://www.youtube.com/watch?v=v1CmGbOGb2I), a
  presentation by [Yaron Minsky](https://twitter.com/yminsky), CTO of
  [Jane Street](https://blog.janestreet.com/)—an industrial user of
  OCaml and one of the global leaders in finance. Yaron is also one of
  the authors of _Real World OCaml_ and the originator of the widely
  quoted phrase in the statically typed programming languages world,
  "_Make illegal states unrepresentable_". The talk offers plenty of
  insights into Jane Street’s motivations for choosing OCaml.

- ["**OCaml for Fun & Profit: An Experience
  Report**"](https://www.youtube.com/watch?v=TxuLrsQZprE), presented
  by [Tim McGilchrist](https://lambdafoo.com/) at [Yow
  2023](https://yowcon.com/melbourne-2023). After a rich introduction
  to the language, it covers some very concrete use cases of OCaml in
  production — _with fun and profit_.

- ["**Replacing Python for
  0Install**"](https://roscidus.com/blog/blog/categories/0install/) by
  [Thomas Leonard](https://roscidus.com/blog/). This series of
  articles is, in my view, **incredibly interesting**. The author of
  [0Install](https://0install.net/), a decentralized, cross-platform
  software installation system (a slightly older alternative to
  [Nix](https://nixos.org/)), was looking for a language other than
  [Python](https://www.python.org/) for a new version’s implementation
  (the reasons for replacing Python are also [documented
  here](https://roscidus.com/blog/blog/2013/06/09/choosing-a-python-replacement-for-0install/#why-replace-python))
  and carried out a thorough, methodical comparison of several
  candidates: [ATS](https://www.cs.bu.edu/~hwxi/atslangweb/),
  [C#](https://learn.microsoft.com/en-us/dotnet/csharp/),
  [Haskell](https://www.haskell.org/), [Go](https://go.dev),
  [Rust](https://www.rust-lang.org/), and [OCaml](https://ocaml.org),
  alongside Python. Years later, I’m still impressed by the rigor and
  nuance of this series, which I **highly recommend**.

There are probably other resources and testimonials, notably on the
[official website](https://ocaml.org/), which features both
[industrial](https://ocaml.org/industrial-users) and
[academic](https://ocaml.org/academic-users) case studies. There are
also articles expressing the frustration OCaml can cause. I’m aware
that OCaml is not perfect—nor do I believe any technology is
perfect. I’ll likely refer to some of these articles (implicitly or
explicitly) in the section on _myths_ and in the conclusion, where
I’ll try to explain in which contexts I don’t find OCaml to be a
relevant choice.

## OCaml as a language

Before diving into the **features** offered by the language, I’d like
to start with a point that I believe is essential. OCaml is a
programming language that originated from
[research](https://ocaml.org/about#history) and is used by [industrial
users](https://ocaml.org/industrial-users). This duality is important
because it provides the language with two key advantages:

- Guidance on _desirable_ features as interesting language concepts,
  supported by advanced research. For example, to my knowledge, OCaml
  is the first _mainstream_ language to offer native support for
  [user-defined effects](https://v2.ocaml.org/manual/effects.html),
  which is the result of cutting-edge research, illustrated by
  numerous
  [publications](https://arxiv.org/search/cs?searchtype=author&query=Sivaramakrishnan,+K).

- Guidance on _desirable_ features as tools for industrialization,
  also backed by research and motivated by practical use cases. For
  instance, recently, [Jane Street](https://blog.janestreet.com/), a
  major industrial OCaml user, proposed the integration of _affine
  sessions_, enabling [linear resource
  management](https://blog.janestreet.com/search/?query=oxidizing)
  (somewhat _Rust-like_).

This intertwining of industrial and academic motivations allows OCaml
to offer a collection of solid, useful, and well-defined features. In
other words, OCaml is a **living** language, and since I’ve been using
it, I’ve witnessed many developments and additions that I consider
highly desirable and that *debunk* a common assertion against OCaml:
**the language is only useful for theory or for implementing
[Coq/Rocq](https://coq.inria.fr/)**.

Although this was historically true, the motivations provided by
industrial users justify the label "_An industrial-strength functional
programming language with an emphasis on expressiveness and safety_."
The opening keynote of the [OCaml Workshop
2021](https://ocaml.org/conferences/ocaml-workshop-2021) by [Xavier
Leroy](https://xavierleroy.org/), titled "[*25 Years Of
OCaml*](https://watch.ocaml.org/w/tU8wR9EcAcyFHHVcX4GS46)," presents
an exhaustive timeline of OCaml’s continuous design, showing the
various phases of evolution the language has undergone.

In broad terms, OCaml is a programming language from the [ML
family](https://en.wikipedia.org/wiki/ML_%28programming_language%29),
**high-level** (here, meaning it features [garbage
collection](https://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29)),
**statically typed** (types are checked at compile time with no
implicit conversions), with **[type
inference](https://en.wikipedia.org/wiki/Type_inference)** (also
called _type synthesis_), allowing the compiler to deduce the type of
an expression in most cases. This enables programming in both
[**functional**](https://en.wikipedia.org/wiki/Functional_programming)
and
[**imperative**](https://en.wikipedia.org/wiki/Imperative_programming)
styles.

OCaml also provides an **object-oriented programming model** and a
very rich **module system**. The language has two compilation schemes:
`ocamlc`, which compiles to a _bytecode_ executable by a **virtual
machine** (portable and efficient), and `ocamlopt`, which compiles to
**native machine code** (runnable on a wide [variety of
architectures](https://github.com/ocaml/ocaml?tab=readme-ov-file#overview)).

Moreover, OCaml allows **conversion of its bytecode to JavaScript**
using
[Js\_of\_ocaml](https://ocsigen.org/js_of_ocaml/latest/manual/overview),
enabling _very fast_ interoperability within the OCaml ecosystem
(which I use _extensively_ on this website). The [same approach is
used to produce
WebAssembly](https://github.com/ocaml-wasm/wasm_of_ocaml). For deeper
interoperability with the JavaScript ecosystem,
[Melange](https://melange.re/) takes a somewhat different approach
than Js\_of\_ocaml to generate robust JavaScript.

OCaml is a **highly versatile** language, and I will now try to
present the features and strengths that make it — _for me_ — an ideal
tool for building both personal and professional projects, starting
with a brief detour into static typing.

### On static type checking

When I was preparing, with [Bruno](https://twitter.com/bibear), the
episode of [If This Then Dev](https://www.ifttd.io/liste-des-episodes)
dedicated to OCaml — which, in the end, was
[recorded](https://www.ifttd.io/episodes/le-langage-de-tous-les-langages)
with [Didier](https://github.com/d-plaindoux) — he asked me a question
that I found surprising:

> “Is it really worth bothering with types when working on a _personal
> project_ quickly?  Even though I can perfectly see the value for
> _production_ code, for a _personal project_ it seems like a waste of
> time to me.”

I think there are two main angles to answer this. The first, and most
obvious, is that, **in principle, I don’t see why a personal project
should be any less disciplined than a professional one**. When I write
software _for myself_, I could indeed get away with ignoring the
_corner cases_ of my implementation. Sure, that’s possible. But that’s
probably not what I actually want to do. So, if a language and its
compiler let me set up safety nets that force me to account for all
the cases in my software, _I take them_ — just like writing _unit
tests_ **makes development easier**, and I don’t see them as a
constraint.

But beyond considerations of hygiene in a personal project, I think
the negative reputation of static type checking usually stems from a
bad experience. Indeed, in languages like C or Java, types are
**mostly a constraint** that can be easily circumvented. In languages
that place a strong emphasis on typing — like
[OCaml](https://ocaml.org), [Haskell](https://www.haskell.org),
[F#](https://fsharp.org), [Scala](https://www.scala-lang.org/), or
[Rust](https://www.rust-lang.org) — **types act as safeguards**. More
importantly, in my view, **types also serve as a tool for expressive
*design***. Using them provides safety while also offering an
incredibly rich, versatile, and concise way to describe data.

From my experience, even though it’s common to move from a
_poorly-typed_ (sorry, the temptation is too strong) to a _dynamically
typed_ language — I, for instance, happily transitioned from Java to
Ruby — moving from a language with a rich type system, like OCaml or
Haskell, makes switching to a _dynamically typed_ language much
harder. At present, **I don’t know anyone who has seriously used
languages like OCaml or Haskell and was happy to return to languages
with less sophisticated type systems** (though an interesting project
can sometimes justify such a technological regression).

This is **not just a personal observation**; static type checking is
central to the broader debate about the evolution of programming
languages. Historical languages evolve (or attempt to evolve) to
integrate more type checking. For instance,
[Erlang](https://www.erlang.org/), as early as the 1980s (before its
compiler source was released), experimented with [integrating a type
system](https://homepages.inf.ed.ac.uk/wadler/papers/erlang/erlang.pdf). Java,
version by version, enhances features aimed at improving static type
verification, such as incorporating [sealed
families](https://openjdk.org/jeps/409).

Many languages are experimenting with type systems: [Ruby with
RBS](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/),
[Crystal](https://crystal-lang.org/) (a statically typed language
heavily inspired by Ruby), [Python with Mypy](https://mypy-lang.org/),
[Elixir](https://www.irif.fr/_media/users/gduboc/elixir-types.pdf)
(which revisits Erlang’s past experiments, offering a viable gradual
typing approach), and, of course,
[TypeScript](https://www.typescriptlang.org/), which has become
**widely adopted** in the JavaScript community.

While all these initiatives are encouraging and clearly move in the
right direction, for now, they primarily **add safeguards** but do not
yet serve as expressive **design tools**.

When it comes to increasingly rich type systems, **the White House**
recently published a
[report](https://bidenwhitehouse.archives.gov/oncd/briefing-room/2024/02/26/press-release-technical-report/)
emphasizing the importance of *memory safety* in software design and…
*endorsing* the use of the [Rust](https://www.rust-lang.org) language
(historically [written in
OCaml](https://users.rust-lang.org/t/understanding-how-the-rust-compiler-is-built/87237/7)
before becoming *self-hosted*) over C++, clearly showing that even
official bodies (often considered outdated) highlight the value of
rich type systems. Moreover, the [response from
Tarides](https://tarides.com/blog/2024-03-07-a-time-for-change-our-response-to-the-white-house-cybersecurity-press-release/),
the company I work for at the time of writing this article, also
presents compelling arguments in favor of using OCaml for building
critical systems.

In conclusion, static type checking is really valuable and highly
recommended, and it’s worth exploring languages with sophisticated
type systems (like OCaml) and, why not, going even further by
increasingly delving into formal methods.

### Features of the _language_

Even though it’s very tempting to create a massive OCaml tutorial, the
goal of this section is to present what makes **OCaml**, **for me**, a
**highly relevant** choice for both learning and production. The
advantages will therefore be presented (and _defended_), but **this is
not a tutorial**.

#### A _multi-paradigm_ language

Nowadays, talking about **multi-paradigm** languages might seem
unnecessary, since a large majority of programming languages _favored
by industry_ are already multi-paradigm. However, OCaml is a
**functional programming** language that also supports **imperative
programming**, **modular programming**, **object-oriented
programming**, and, since version `5.0.0`, **multi-core programming**.

Just as [Haskell](https://www.haskell.org/) is widely recognized in
the functional programming world, it’s often assumed that adding
imperative mechanisms to a language is a bad idea — especially if one
is convinced of the benefits of the functional style. From my
perspective, there are several perfectly legitimate reasons to use
imperative programming when the language allows it:

- **Readability of an implementation.** Sometimes, avoiding mutability
  requires adding extra plumbing (for example, a [State
  Monad](https://wiki.haskell.org/State_Monad)), which can make
  reading and understanding a program more cumbersome.

- **Performance.** Adding such plumbing can introduce overhead, making
  the execution of implementations more costly.

- **Ease of use.** A few years ago, [Arthur
  Guillon](https://twitter.com/rtguillon) ceremoniously told me that
  "_OCaml is a lambda calculus that trivially allows effects_," which
  makes it very effective for tasks like debugging, where printing
  messages to standard output is simple. While I acknowledge that this
  is probably not the _best way_ to implement logging, it undeniably
  provides a comfortable user experience and enables rapid
  prototyping.

In general, OCaml's dual nature — both imperative and functional —
allows you to leverage the advantages of both paradigms in different
situations and, of course, to combine them. For example, hidding a
module's imperative nature behind a functional API.

##### Syntax _à la ML_

Although syntax is often considered a minor detail, languages in the
[ML
family](https://en.wikipedia.org/wiki/ML_%28programming_language%29)
have a concise, expressive, and readable syntax. Even though _this
family of syntax_ can be confusing when coming from more conventional,
C-inspired syntax, one gets used to it fairly quickly and can soon
realize that it is very consistent and relatively
unambiguous. However, if OCaml’s syntax is problematic for you, don’t
hesitate to look into [ReasonML](https://reasonml.github.io/), an
alternative syntax that uses braces.

##### Closely related to research

OCaml is a language that originates from French research, as shown by
the [history of Caml](https://caml.inria.fr/about/history.en.html),
primarily designed to implement the proof assistant
[Coq/Rocq](https://coq.inria.fr/). This origin — and the initial
motivations, implementing Coq while also serving as a programming
language taught in preparatory classes—creates a certain duality:

- The core features were not initially designed with industry in
  mind. However, this assertion is no longer true, primarily because
  OCaml **has** become a language used in industrial contexts. While
  in the language’s genesis, there were more tools for building a
  language itself (facilitating the teaching of compiler mechanisms)
  than tools for building "enterprise" applications, projects from the
  community motivated by industrial use have enriched the language and
  its ecosystem, making it a versatile tool suitable for industry. For
  example, creating a *binding* with the
  [Tk](https://en.wikipedia.org/wiki/Tk_%28software%29) library led to
  the integration in the language of [named
  arguments](https://ocaml.org/manual/lablexamples.html), [optional
  arguments](https://ocaml.org/manual/lablexamples.html#s%3Aoptional-arguments),
  and [polymorphic
  variants](https://ocaml.org/manual/polyvariant.html).

- The set of paradigms and language features are **carefully thought
  out and well-theorized**. Generally, the integration of a feature
  (or collection of features) results from meticulous research, based
  on solid theoretical foundations and reviewed by numerous experts in
  the field (often
  [recognized](https://www.inria.fr/fr/avec-xavier-leroy-linformatique-confirme-sa-presence-au-college-de-france)
  by the scientific community). This rigor can sometimes slow the
  introduction of new features but generally ensures their proper
  functioning and theoretical stability.

This theoretical rigor, stemming from OCaml’s undeniable closeness to
the research world, means that its various aspects are well
documented, illustrated by [a large number of
publications](https://arxiv.org/search/?query=ocaml&searchtype=all&source=header),
and exhibit **predictable behavior**. From my point of view, this
makes OCaml a very wise choice for understanding these different
features _in depth_. For example, I believe OCaml has allowed me to
**much better understand** certain traits or paradigms of programming
languages.

Moreover, a great example of how meticulous and rigorous research can
support the integration of a language feature is OCaml’s
implementation of an [object
model](https://ocaml.org/manual/objectexamples.html). Indeed, the
thesis of [Jérôme Vouillon](https://www.irif.fr/~vouillon/), *[Design
and Implementation of an Extension of the ML Language with
Objects](https://www.irif.fr/~vouillon/publi/these.ps.gz)*, proposes
an innovative object model that integrates very well with type
inference by [separating the notions of inheritance and
subtyping](https://caml.inria.fr/pub/docs/oreilly-book/html/book-ora144.html)
— inheritance being a **syntactic notion** and subtyping a **semantic
notion** — using [row
polymorphism](https://en.wikipedia.org/wiki/Row_polymorphism) to
describe [structural subtyping
relationships](https://en.wikipedia.org/wiki/Structural_type_system),
as opposed to [nominal
subtyping](https://en.wikipedia.org/wiki/Nominal_type_system), used by
Java, C#, and most popular OOP languages. OCaml’s object model fully
adheres to the [SOLID principles](https://en.wikipedia.org/wiki/SOLID)
without any [additional
ceremony](https://spring.io/projects/spring-boot).

#### Algebraic types

I’ve been quite expansive about the reasons why I value a language
with static type checking. However, in my experience, for a statically
typed language to be truly usable, the presence of [algebraic
types](https://cs3110.github.io/textbook/chapters/data/algebraic_data_types.html)
is necessary:

- **Product types**: These allow grouping values of heterogeneous
  types (thus creating a **conjunction** of heterogeneous types). They
  are generally present in all _mainstream_ languages (for example,
  _objects_, which introduce additional concepts, or tuples and
  records).

- **Sum types**: These allow constructing a **disjunction** of
  heterogeneous value types, with different _cases_ indexed by
  constructors. While some _special cases_ of sums exist in mainstream
  languages—like _booleans_ (which are a disjunction of two cases:
  `true` and `false`, i.e., two parameterless constructors) — support
  for full sum types is often cumbersome in popular languages. For
  example, Kotlin and Java (and _de facto_ C#) use a construct
  associated with inheritance relations called
  [sealing](https://docs.oracle.com/en/java/javase/17/language/sealed-classes-and-interfaces.html). The
  integration of [dedicated sum type
  syntax](https://docs.scala-lang.org/scala3/reference/enums/adts.html)
  also took some time in Scala, which, prior to recent versions,
  relied on sealed families, making the expression of sums verbose
  and, in my view, harder to reason about.

- **Exponential types**: These allow describing functions that express
  types for higher-order functions (functions that can be passed as
  arguments or returned as results).

Coupled with [pattern
matching](https://ocaml.org/manual/5.2/patterns.html) and [parametric
polymorphism](https://en.wikipedia.org/wiki/Parametric_polymorphism)
(or _generics_), an algebraic type system is an incredibly expressive
tool for describing data structures, the state machine of a program,
or modeling a [business
domain](https://pragprog.com/titles/swdddf/domain-modeling-made-functional/)
with an appropriate cardinality. Even in the 21st century, where
products and exponentials are common, when I use _very popular_
languages, I am often frustrated by the lack of sum types, which
forces me to use verbose encodings (increasing the domain’s
cardinality). This is particularly noticeable when working with
[Go](https://go.dev/) and
[TypeScript](https://www.typescriptlang.org/).

The appeal of this triad is, in fact, probably one of the reasons
(combined with a very ergonomic ecosystem and toolchain) behind the
success of [Rust](https://www.rust-lang.org/). In short, if you intend
to build a new programming language with static type checking,
_please_, do not hesitate to include algebraic types!

Finally, there are aspects of OCaml's type system that I haven’t
covered, but which probably deserve dedicated articles. For example,
[generalized algebraic data types
(GADTs)](https://ocaml.org/manual/gadts-tutorial.html), which allow
expressing even more invariants.

#### Modular programming and module language

OCaml, through its ancestor [Caml
Light](https://caml.inria.fr/pub/docs/manual-caml-light/), was among
the first languages to offer a module system, similar to [Standard
ML](https://smlfamily.github.io/), providing **encapsulation and
abstraction** while supporting **separate compilation**, in the style
of [Modula-2](https://en.wikipedia.org/wiki/Modula-2). OCaml’s module
system is a **fundamental aspect** of the language, although its
complexity can be intimidating. Indeed, in OCaml, it is possible to
clearly distinguish the interface (the _signature_) from the
implementation (the _structure_), thus facilitating encapsulation and
documentation, while also allowing **function application within the
module language**.

I find it particularly difficult to address the topic of modules
briefly (it’s a subject I’ve wanted to explore on my blog for
_years_). However, here is a list of advantages I see in OCaml’s
_highly modular_ approach:

- **Separate compilation**: A key feature that allows efficient
  compilation of large programs by identifying junction points to
  optimize parallel and incremental compilation. This approach is
  leveraged by [dune](https://dune.build/), the recommended build
  system for OCaml.

- **Systematic separation of implementation and interface**: Offers
  several significant advantages, including encapsulation and placing
  documentation in the interface. In my programming workflow, I find
  this very convenient because I can implement my _structure_ (the
  module’s implementation) while _being guided by type inference_ and
  specify its API in the _signature_ (the module’s interface),
  deciding on the display order and providing clear documentation that
  doesn’t pollute the implementation space. Additionally,
  encapsulation allows me to freely define intermediate types inside
  the structure, for example, to represent a program’s state machine,
  [without letting it
  escape](https://en.wikipedia.org/wiki/Leaky_abstraction).

- **A powerful tool for describing data structures**: By abstracting
  types (hiding their implementation) and combining this with
  encapsulation, it is possible to describe data structures that
  **maintain invariants**. This is why it is common to have a
  structure/signature pair for each data structure, hiding
  implementation details through abstraction and encapsulation.

- **Reusability and sharing**: Just as it is possible to describe
  types in the value language (as seen with algebraic types), it is
  also possible to describe types in the module language, called
  **translucent signatures**, which allow defining the type of a
  signature without associating it with a structure. These signatures
  are structurally typed, and coupled with
  [functors](https://ocaml.org/docs/functors) (functions in the module
  language), it is possible to _share behavior_ between modules.

- **Advanced forms of polymorphism**: Including [Higher Kinded
  Polymorphism](https://okmij.org/ftp/ML/higher-kind-poly.html),
  available in the module language. In broad terms, you can describe
  "_generics parameterized by generics_". This limitation in languages
  like F# or Java often motivates the use of [heavy
  encodings](https://github.com/yallop/higher?tab=readme-ov-file#implementations-in-other-languages)
  to work around the lack.

The theory behind module languages in ML-family languages is a vast
subject, [still evolving](https://dl.acm.org/doi/10.1145/3649818), and
very difficult to summarize in a single paragraph. However, the
introduction of [Derek Dreyer’s
thesis](https://people.mpi-sws.org/~dreyer/thesis/main.pdf),
_Understanding and Evolving the ML Module System_, provides an
excellent explanation of the purpose and use of modules, illustrated
with many examples. I hope to take the time in the coming weeks or
months to write more extensively about the module language than I have
[already attempted](/en/articles/modules-import.html), because it could
be very educational and, in my view, the topic is extremely
interesting!

#### Dependency injection and inversion

Briefly touching on object-oriented programming in OCaml, I mentioned
that OCaml allows, through its language features, a straightforward
way to meet the prerequisites for writing **SOLID** code. The final
point I’d like to emphasize is the ease of dependency inversion,
achievable through **language-provided features**. In broad terms, the
principle of dependency inversion involves describing dependency
lattices using **abstractions** rather than **implementations**. This
way, dependencies can be _injected afterward_ — making context
changes, for example in unit testing, trivially implementable.

OCaml provides (_at least_) two tools that facilitate this inversion,
each useful in different contexts. We will draw inspiration from the
very popular teletype example to show how to invert dependencies:

```ocaml
let program () =
  let () = print_endline "Hello World" in
  let () = print_endline "What is your name?" in
  let name = read_line () in
  print_endline ("Hello " ^ name)
```

Even if it might not seem obvious, this program depends on **concrete
implementations** — namely, interactions with standard input and
output.

##### Through modules

The most straightforward approach is to use modules, either as
[first-class values](https://ocaml.org/manual/firstclassmodules.html)
or by construction, using
[functors](https://ocaml.org/docs/functors). The duality between
signatures and structures makes dependency inversion obvious. For
example, to revisit our example, here’s how, using [*first-class
modules*](https://ocaml.org/manual/firstclassmodules.html), it becomes
**very easy** to depend on an abstract set of interactions. We start
by describing the abstract representation of possible interactions:

```ocaml
module type IO = sig
  val print_endline : string -> unit
  val read_line : unit -> string
end
```

We can now expect our `program` function to take a module of type `IO`
as an argument (we’ll call this _a handler_) and use the functions
exported by the module, which in our example is named `Handler`:

```ocaml
let program (module Handler: IO) =
  let () = Handler.print_endline "Hello World" in
  let () = Handler.print_endline "What is your name?" in
  let name = Handler.read_line () in
  Handler.print_endline ("Hello " ^ name)
```

For example, in the context of unit testing, it’s possible to provide
an implementation that logs all the operations called (and _mocks_ the
`read_line` call to fix the returned result). This makes expressing
unit tests that _verify business logic_ very easy to implement.

Passing a concrete implementation as an argument to our function
amounts to **interpreting the program**.

##### Through _user-defined effects_

OCaml version 5 arrived with a host of new features. However, the
biggest advancement is the complete redesign of the OCaml **runtime**
to support multi-core execution. There are several ways to describe
concurrent algorithms — for example, using
[actors](https://en.wikipedia.org/wiki/Actor_model) or
[channels](https://go101.org/article/channel.html). OCaml has chosen
to rely on
[effects](https://github.com/ocaml-multicore/ocaml-effects-tutorial),
which simplify the management of the program's _control flow_.  In
fact, OCaml allows users to define their own effects, logically called
[user-defined effects](https://ocaml.org/manual/effects.html). While
they are a powerful tool for describing concurrent programs, they also
make it easier to inject dependencies when you want to maintain
control, _at the handler level_, over the execution flow of a program.

> Note: In my example, I am using an experimental syntax, [just
> merged](https://github.com/ocaml/ocaml/pull/12309) into the OCaml
> main branch, which will likely be available in version `5.3.0` of
> the language.

As with our previous improvement, we first need to describe the set of
operations that can be performed. We use the `effect` construct:

```ocaml
effect Print_endline : string -> unit
effect Read_line : unit -> string
```

Next, we can write our program in a direct style, by _producing
effects_:

```ocaml
let program () =
  let () = Effect.perform (Print_endline "Hello World") in
  let () = Effect.perform (Print_endline "What is your name?") in
  let name = Effect.perform (Read_line ()) in
  Effect.perform (Print_endline ("Hello " ^ name))
```

It is then possible to **interpret our program afterward**, using a
construction similar to pattern matching, to give a specific meaning
to each effect.

Currently, it should be noted that **effect propagation is not tracked
by the type system**. However, this is an experimental feature, which
is used extensively in the [new version of
YOCaml](https://github.com/xhtmlboi/yocaml). I am aware that resources
are being devoted to developing an **efficient type system to track
effect propagation**!

In general, when I don’t care about controlling the program’s flow, or
I don’t need to add effects _after the fact_, I use modules. But in
the case of YOCaml, the new effect system was leveraged to [introduce
effects dedicated to unit
testing](https://github.com/xhtmlboi/yocaml/commit/d78bb21077272ae86f7b6b3017509596de0a5a27),
allowing, for example, the _mocking of time passing_.

Once again, it’s really difficult not to go on at length about
_user-defined effects_, which are a brand-new and very exciting
feature of the language. I’ll conclude by simply sharing two articles
written by [Arthur Wendling](https://github.com/art-w) that explain
the use of effects in a very pedagogical way, along with a
comprehensive bibliography on the literature related to effect
abstraction in functional programming:

- [Scopes and effect
  handlers](https://hackmd.io/@yF_ntUhmRvKUt15g7m1uGw/Bk-5NXh15)
- [Roguelike with effect
  handlers](https://hackmd.io/@yF_ntUhmRvKUt15g7m1uGw/BJBZ7TMeq)
- [Effect bibliography](https://github.com/yallop/effects-bibliography)

It’s worth noting that this inversion/injection could also be done
using _records_ or _objects_. However, my experience with OCaml
suggests that approaches using modules or effects (when you want to
manipulate the program’s control flow) are often more straightforward
and easier to reason about.

### Regarding the future

OCaml is a _constantly evolving_ language that changes with each
version. In the section on dependency inversion, I briefly mentioned
the recent inclusion of effects in the language to describe a
_multi-core runtime_, reflecting the ongoing evolution of OCaml over
the years. One can also note the integration of [binding
operators](https://ocaml.org/manual/bindingops.html), which make the
use of the triad
[Functors](https://en.wikipedia.org/wiki/Functor_%28functional_programming%29),
[Applicative
Functors](https://en.wikipedia.org/wiki/Applicative_functor), and
[Monads](https://en.wikipedia.org/wiki/Monad_%28functional_programming%29)
more convenient — similar to [computation
expressions](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/computation-expressions)
in F#.

Currently, many very exciting projects are underway to further improve
the language:

- A deep work on the expression of effects, with a newly added syntax,
  and a collection of research on the separation between [operations
  and effects](https://github.com/ocaml/ocaml/pull/12736) and, of
  course, on the [propagation of effects in the type
  system](https://arxiv.org/abs/2407.11816).

- [Jane Street](https://opensource.janestreet.com/) proposed [a
  non-intrusive resource management
  model](https://antonlorenzen.de/mode-inference.pdf), inspired by
  Rust, introducing _modalities_ and _a bit of linearity_.

- A genuine [foundational
  work](https://clement.blaudeau.net/assets/pdf/blaudeau_ocaml_modules.pdf)
  has been initiated on the module language, making the implementation
  of [Modular
  Implicits](https://www.cl.cam.ac.uk/~jdy22/papers/modular-implicits.pdf)
  more smoothly achievable.

We can also note the development of a [hygienic macro
system](https://xnning.github.io/papers/icfp23.pdf), the gradual
integration of a [staged metaprogramming
system](https://okmij.org/ftp/ML/MetaOCaml.html), and the
implementation of an [_optimization
back-end_](https://ocamlpro.com/blog/tag/flambda2/), reflecting
OCaml’s strong activity in the innovation sector and making its
development in the coming years very motivating and exciting!

### Weaknesses

Even though I’m convinced that OCaml is an **excellent language**,
claiming it is perfect would probably be _disingenuous_ — after all,
_nothing is perfect_. Here are, in my opinion, a few points that cast
a shadow on OCaml as a language:


- **Lack of [ad-hoc
  polymorphism](https://en.wikipedia.org/wiki/Ad_hoc_polymorphism).**
  Although it is possible to work around it, for example using local
  module openings, the absence of _ad-hoc polymorphism_ (via [type
  classes](https://en.wikibooks.org/wiki/Haskell/Classes_and_types) —
  as in Haskell, or
  [traits](https://doc.rust-lang.org/book/ch10-02-traits.html)/[implicit
  objects](https://docs.scala-lang.org/tour/implicit-parameters.html)
  — as in Rust and Scala, or [canonical
  structures](https://coq.inria.fr/doc/v8.18/refman/language/extensions/canonical.html)
  — as in Coq) can sometimes make certain situations tricky. Even
  though I tend to prefer explicit relationships, over the years I’ve
  found several cases where this absence can be problematic:

  - The inability to describe type parameter constraints on
    polymorphic functions, leading to polymorphic equality and
    comparison functions in the standard library, which has caused
    [much
    debate](https://blog.janestreet.com/the-perils-of-polymorphic-compare/)
    and, for example, required specialized versions of arithmetic
    operators for different numeric representations (`int`, `int64`,
    `float`).

  - Risk of combinatorial explosion when describing many relationships
    between modules. This is why the
    [Preface](https://github.com/xvw/preface) library proposes a
    somewhat [complex modular
    decomposition](https://github.com/xvw/preface/blob/master/guides/option_instantiation.md).

  However, even though the arrival of [implicit
  modules](https://www.cl.cam.ac.uk/~jdy22/papers/modular-implicits.pdf)
  is probably not in the short-term roadmap, recent work on the module
  language, as discussed in the “future of OCaml” section, is
  promising.

- **Cumbersome interaction between the module language and the value
  language.**  The module language is **a different language** with
  its own type system. Whether this counts as a weakness is debatable,
  but this distinction can be intimidating. It comes from the fact
  that OCaml’s module system was a pioneer in module theory and
  predates more recent innovations (e.g.,
  [1ML](https://people.mpi-sws.org/~rossberg/1ml/1ml-extended.pdf)).
  In practice, besides being _complex to grasp_, certain parts of the
  language are hard to specify correctly, for example [recursive
  modules](https://www.ocaml.org/manual/5.2/recursivemodules.html#s%3Arecursive-modules).

- **A language comfortable for functional programming, but impure.**
  While I consider impurity **a feature**, importing idioms from
  purely functional languages (e.g., Haskell) can cause difficulties
  related to type inference, such as the [_value
  restriction_](https://en.wikipedia.org/wiki/Value_restriction).
  Even though OCaml has
  [relaxed](https://caml.inria.fr/pub/papers/garrigue-value_restriction-fiwflp04.pdf)
  this restriction, its implications on polymorphic function inference
  can still be intimidating — for very good reasons.

* **Syntax.** Personally, I really like OCaml’s syntax and believe
  syntax should rarely be a major issue, but some choices can be
  confusing. For instance, type parameters prefix the type name: a
  list of `a` is written `'a list`. Many of these choices aim to
  _reduce syntactic ambiguity_, and you get used to them
  quickly. However, coming from another language, some of these
  conventions may seem surprising.

I think these weaknesses are generally debatable (because they are
often justified), but I completely understand that they can be
unsettling. However, I believe they are not enough to make OCaml
unusable and **should not be a major barrier to getting started with
OCaml**! The benefit of having an _improvable_ language is that it
constantly offers a range of potential improvements, motivating work
that can also benefit other languages. And, to be entirely honest,
being aware of these _rough edges_, I’ve more often found myself
frustrated by the absence of language features **that exist in OCaml**
in other languages, rather than complaining about these rough edges
while writing OCaml itself. For these rough edges, there are usually
workarounds (sometimes only partially satisfying, I admit) that allow
one to work calmly and effectively.

### To conclude on language

I have, in very broad strokes, outlined **reasons** why, in my
opinion, learning OCaml is a **very relevant** choice. This language
allows one to _fundamentally understand_ certain _very_ popular
programming idioms (often poorly defined). Moreover, some aspects of
the language perfectly serve industrial purposes, making good
practices sometimes trivial to express! Much of this appeal can be
experimented with in other languages, but OCaml's _strongly
multi-paradigm_ nature allows one to centralize this learning in a
single language. To my knowledge, in the jungle of _partially popular_
languages, only Scala seems to cover as many topics, although, from my
point of view, its object model is, essentially for interoperability
with other JVM languages, far less interesting.

Since the goal of this article is not to be a tutorial, I deliberately
skimmed over certain concepts,
[modules](https://ocaml.org/docs/modules) and
[effects](https://ocaml.org/manual/ffects.html). I hardly mentioned
[objects](https://ocaml.org/docs/objects), [polymorphic
variants](https://ocaml.org/manual/polyvariant.html), or [generalized
algebraic types](https://ocaml.org/manual/gadts-tutorial.html). If
these topics interest you, I encourage you to read in detail the
excellent [Using, Understanding, and Unraveling The OCaml
Language](https://caml.inria.fr/pub/docs/u3-ocaml/index.html) by
[Didier Rémy](http://cristal.inria.fr/~remy/), along with the books I
presented in the introduction, which is a goldmine for anyone wishing
to deepen their knowledge of OCaml.

In conclusion, OCaml offers a diverse and rich set of language-level
tools for learning programming, building industrial-grade programs
that follow standards, as well as implementing [complex data
structures](https://github.com/art-w/deque) and [category-theory-based
abstractions](https://github.com/xvw/preface) such as a functional
core, imperative traits, a rich and expressive inferred type system
(allowing the expression of algebraic types and facilitating clear
domain modeling), a module system for abstraction, reusability, and
defining compilation units, an object model, the ability to express
effects that can be propagated and interpreted _a posteriori_, and
other advanced features. Even just to _grasp advanced programming
concepts_, OCaml is an **excellent candidate** — which is why OCaml
has been an obvious inspiration for many more recent languages, [with
Rust being a notable
example](https://doc.rust-lang.org/reference/influences.html).

## OCaml as an ecosystem

Having an expressive language is very beneficial for _building things_
(the phrasing is deliberately naive). However, in different contexts,
both professional and personal, this is not enough:

- In a professional context, it is obvious that if I want my team and
  I to be productive, it is probably not very relevant to have to
  build a whole tool stack before being able to start addressing the
  problem we are tasked with.

- In a personal context, even though one could _argue_ that building
  your technology stack is **very educational**, it changes the set of
  skills you actually want to _develop_. If, to build a small web
  application to get started with OCaml as a web language, I have to
  build my entire HTTP stack, it is very likely that OCaml is not the
  right choice. Rest assured, however, that OCaml has [a rich tooling
  ecosystem](https://ocaml.org/docs/is-ocaml-web-yet) for building web
  applications!

That’s why the features offered by the language are not a sufficient
metric to describe its viability for building and maintaining
projects. The ecosystem is also a very important factor. It is for
these reasons that [.NET](https://dotnet.microsoft.com/en-us/) and the
[JVM](https://en.wikipedia.org/wiki/Java_virtual_machine), through
relatively less expressive (but improving) languages like Java and C#,
are also so popular. To assess the relevance of an ecosystem, I think
it is important to consider several criteria:

- The relevance of the _runtime_ (or compilation targets) for the
  project. It’s likely that I wouldn’t recommend OCaml for embedding
  in a tiny, exotic _hardware_ — though, knowing nothing about
  low-level programming (because it’s not my field at all), I could be
  wrong.

- Its **platform**. Is its entire _toolchain_ complete and ergonomic?
  From my point of view, this includes a package manager, a _build
  system_, good _editor support_ (agnostic as possible), a solid
  documentation generator, and a collection of additional tools, such
  as a _formatter_ (and many others).

- The relevance of the **available libraries** (and their level of
  maintenance and discoverability, which generally implies having a
  package manager) with particular consideration for their
  ergonomics. For example, if I don’t have any cryptography
  primitives, I probably wouldn’t choose this technology to build a
  _blockchain_. There is a whole class of problems that are **very
  difficult** to _solve in isolation_ or in a professional context.

In this section, we will try to overview these different points to see
if the OCaml ecosystem lives up to the language. I want to clarify
that **I am somewhat biased** because I have been convinced of OCaml’s
relevance since 2012, back when the ecosystem was **drastically
poorer**. At that time, I tried to build projects by patching the
gaps, which probably created a [survivorship
bias](https://en.wikipedia.org/wiki/Survivorship_bias). Nowadays,
thanks in part to industrial users, the OCaml ecosystem is much richer
and more extensive, making it much easier to defend, although when
some gaps still exist, the bad faith _of the old user_ can resurface.

### Compilation, _runtimes_, and additional targets

Since its inception, OCaml has had two compilation targets:

- Native compilation, which produces highly efficient executables
  compiled for a specific architecture (and supports a [large number
  of
  architectures](https://github.com/ocaml/ocaml?tab=readme-ov-file#overview)). Moreover,
  whereas Windows was historically largely neglected, [a special
  effort](https://tarides.com/blog/2024-05-22-launching-the-first-class-windows-project/)
  has been made to support it (also note the [DkMl
  project](https://github.com/diskuv/dkml-installer-ocaml), an
  independent initiative).

- Compilation to _bytecode_ (for a virtual machine), producing
  portable executables.

The presence of a virtual machine enabled the development of the
venerable
[Js\_of\_OCaml](http://ocsigen.org/js_of_ocaml/latest/manual/overview),
which allows [transforming OCaml bytecode into
JavaScript](https://www.irif.fr/~vouillon/publi/js_of_ocaml.pdf),
making OCaml perfectly viable for developing applications in the
browser as well as in the [Node](https://nodejs.org/en) runtime, and
it is extensively used for this website. Using a similar approach,
[WebAssembly](https://webassembly.org/) support was made possible very
recently through the
[Wasm\_of\_OCaml](https://github.com/ocaml-wasm/wasm_of_ocaml)
project. Supporting compilation to _WASM_ for a language with a
[garbage
collector](https://en.wikipedia.org/wiki/Garbage_collection_%28computer_science%29)
was a _serious challenge_, but with the recent specification of
interaction between _WASM_ and [*garbage
collectors*](https://github.com/WebAssembly/gc), **OCaml now has
perfectly decent WebAssembly compilation** (and many ambitious web
projects, like [Ocsigen](https://ocsigen.org), are beginning to
support _WASM_ natively).

Moreover, the [Melange](https://melange.re) project (historically
[BuckleScript](https://discuss.ocaml.org/t/a-short-history-of-rescript-bucklescript/7222))
offers a way to _transpile_ — mapping the OCaml _AST_ to the
JavaScript _AST_ — as an alternative for producing JavaScript. If I
were to compare
[Js\_of\_OCaml](http://ocsigen.org/js_of_ocaml/latest/manual/overview)
and [Melange](https://melange.re), beyond the different underlying
methods used to produce JavaScript (compiling to _bytecode_ and then
transforming that _bytecode_ into JavaScript versus syntactic
transformation from OCaml to JavaScript), I would say that
**Js\_of\_OCaml** integrates better with the OCaml ecosystem and is
therefore likely **intended for OCaml developers** who want to make
their projects accessible from a browser — indeed, interaction with
the existing JavaScript ecosystem can be more cumbersome. **Melange**
fits better with the JavaScript ecosystem (`npm` and co) and is
therefore likely **intended for JavaScript developers** seeking to
bring more safety to their JS projects (or an existing codebase).

Nowadays, it is common to find _multi-backend_ languages like
[Idris](https://www.idris-lang.org/) or
[Nim](https://nim-lang.org/). However, _at the time_, I was very
impressed that OCaml could, _from the moment I started using it_, also
compile to JavaScript. Back then, the only language I knew that
offered multiple compilation targets was [Haxe](https://haxe.org/),
which were so different (incidentally, Haxe is [written in
OCaml](https://github.com/HaxeFoundation/haxe)).

Indeed, in 2024, producing JavaScript has become standard, but the
[first traces of Js\_of\_OCaml date back to
2006](https://www.irif.fr/~balat/publications/2006mlworkshop-balat-ocsigen.pdf),
making OCaml a pioneer in the field!

#### A quick detour via MirageOS

In the _lattice formed by the different OCaml execution and
compilation contexts_, having libraries that work well in _the
majority of contexts_ is a challenging task. Fortunately, the
[MirageOS](https://mirage.io/) project — a set of libraries designed
to build an **operating system dedicated to running only a single
application** via virtualization (a
[*unikernel*](https://en.wikipedia.org/wiki/Unikernel)) — introduced a
true discipline for producing multi-context libraries.

In the _near future_, I would like to spend more time writing about
Mirage, a fascinating project that we are trying to integrate into our
projects, for example in [YOCaml](https://github.com/xhtmlboi/yocaml),
our static site generator. Moreover, in addition to providing a sound
approach to distributing _intelligently compartmentalized_ libraries,
Mirage offers a solid foundation of libraries for building OCaml
projects, which I will discuss more _extensively_ in the section
dedicated to libraries.

### The OCaml platform

The [OCaml platform](https://ocaml.org/platform) is a set of tools,
maintained within an explicit lifecycle (`active`, `incubating`,
`maintained`, and `deprecated`), designed to support the compiler with
a coherent toolchain for OCaml code production. It includes many tools
serving different purposes; however, in this section, I will focus
only on certain aspects of the platform, leaving you free to consult
its [page](https://ocaml.org/platform) and
[roadmap](https://ocaml.org/tools/platform-roadmap) for more detailed
information. In this section, we will look at, _in broad strokes_, 4
main specific points:

- The package manager
- The build system (_build-system_)
- Editor support (including code formatting)
- The documentation generator

When using OCaml for some time, this is probably the most exciting
part of the article, because, in my opinion, it is the one that has
benefited the most from progress. And the
[roadmap](https://ocaml.org/tools/platform-roadmap) is, in my view,
promising!

#### OPAM, the package manager

Even though _language-specific package managers_ have become very
popular (if not essential) in reducing adoption friction for a
language, at the time OCaml was designed, they were rare. Indeed,
apart from [CTAN](https://en.wikipedia.org/wiki/CTAN), for
distributing [TeX](https://en.wikipedia.org/wiki/TeX) packages,
[CPAN](https://en.wikipedia.org/wiki/CPAN), inspired by CTAN, for
distributing [Perl](https://www.perl.org/) packages, and
[PEAR](https://en.wikipedia.org/wiki/PEAR) for
[PHP](https://www.php.net/), it would take until
[Gems](https://en.wikipedia.org/wiki/RubyGems) for development
technologies to consider adopting a package manager as axiomatic for a
programming language.

[OPAM](https://opam.ocaml.org), for **O**Caml **Pa**ckage **M**anager,
is a
[proposal](https://raw.githubusercontent.com/ocaml/opam/30598a59c98554057ce2beda80f0d31474b94150/specs/roadmap.pdf)
from 2012 (the [official site *About*
page](https://opam.ocaml.org/about.html) presents a small
timeline). In addition to installing packages, OPAM allows you to
install different versions of OCaml and create _potentially sandboxed
environments_, called
[switches](https://ocaml.org/docs/opam-switch-introduction). You can
use the public resource repository, [hosted on
GitHub](https://github.com/ocaml/opam-repository), but it is also
perfectly possible to create your own package index.

> Having already published several packages on OPAM, I must admit that
> the [CI](https://check.ci.ocaml.org/) for package addition
> validation is incredibly efficient and user-friendly (each error
> provides a Dockerfile to reproduce the issue locally), and that the
> team of people who moderate and manage package additions/changes are
> extraordinarily responsive and kind.

Even though, in the light of modern standards, one could point out several criticisms of OPAM, for example:

- terminology that can be cumbersome to grasp (_switch_, _invariant_,
  etc.)
- duplication of all packages and compilers across multiple _switches_
  (this is a known issue for which [work has already been
  done](https://www.youtube.com/watch?v=5JDSUCx-tPw))
- and probably some ergonomic issues (notably the interaction with
  `dune` could be smoother, for which [work is also currently
  underway](https://discuss.ocaml.org/t/ann-dune-developer-preview-updates/15160))
- some complications when managing packages in development,
  referencing them from a source repository rather than from OPAM

I must admit that coming from an era when OPAM did not exist, I have
learned to live with some of these minor pitfalls, and on a daily
basis, I have little reason to complain about the tool, which has
never really let me down in my everyday use. However, if you have
encountered usage issues, I encourage you to discuss them on [one of
the communication spaces](https://ocaml.org/community) so that the
development team can take your feedback into account and guide you.

There is also [esy](https://esy.sh/) as an alternative package
manager, which draws inspiration from [Nix](https://nixos.org/) to
build a reusable *store*, in the same way it is possible to use Nix
with OCaml. However, being somewhat conventional, I am not really
familiar with these practices, and being satisfied with my *workflow*
with OPAM, I have, unfortunately, never taken the time to seriously
experiment with **esy**.

#### Dune, the _build-system_

As with package management, historically, OCaml had **several**
_build-systems_: the venerable
[ocamlbuild](https://github.com/ocaml/ocamlbuild),
[oasis](https://github.com/ocaml/oasis),
[ocp-build](https://github.com/OCamlPro/ocp-build),
[Jenga](https://ocaml.org/p/jenga/latest), and other variations around
[Make](https://www.gnu.org/software/make/). However, since 2018, the
community has strongly adopted [Dune](https://dune.build/), a
_build-system_ initially developed at
[Janestreet](https://www.janestreet.com/).

In many aspects, Dune can be intimidating. Indeed, its
[documentation](https://dune.readthedocs.io/en/stable/) is **very
dense** — but it has greatly improved in terms of structure over the
past few months. And, while many tools choose rule description
languages like [YAML](https://en.wikipedia.org/wiki/YAML),
[TOML](https://en.wikipedia.org/wiki/TOML), or even
[JSON](https://en.wikipedia.org/wiki/JSON), Dune has opted for
[S-expressions](https://en.wikipedia.org/wiki/S-expression). It is
also regrettable that Dune, _by default_, treats [all
warnings](https://ocaml.org/manual/5.2/comp.html#s%3Acomp-warnings) as
fatal.

Before explaining some of its choices (such as **S-expressions**), it
is very important to highlight the points that have made Dune a
standard:

- Dune is **very fast** and offers a **highly efficient** execution
  model
- it builds the necessary artifacts for configuration _automatically_
- it generates some redundant files (such as OPAM description files)
- it trivializes the
  [*vendoring*](https://en.wikipedia.org/wiki/S-expression) of
  libraries
- it allows invoking [read–eval–print
  loops](https://en.wikipedia.org/wiki/Read%E2%80%93eval%E2%80%93print_loop)
  correctly provisioned by the context
- one becomes familiar very quickly with **S-expressions**, which
  allow rules to be described schematically and rapidly
- it is relatively agnostic and can execute arbitrary tasks (similar
  to `make`)
- it is constantly evolving and improving from version to version
- paired with [dune-release](https://github.com/tarides/dune-release),
  it makes publishing packages on OPAM incredibly simple

Perhaps I’m biased, but in my opinion, Dune is one of the most generic
and pleasant _build-systems_ I’ve ever used — even if, at first
glance, it can seem intimidating and some choices may be hard to
justify.

##### On the choice of S-expressions

At first glance, using a _Lisp-like_ syntax to describe binaries,
libraries, and projects may seem surprising. However, this decision
has several advantages:

- The AST of **S-expressions** being **drastically simple**, parsing
  is very straightforward and can be made highly efficient, which does
  not penalize compilation speed.
- The language has _termination_, making it easier to inspect in case
  of errors (anyone who has tried to handle errors in large YAML files
  will have faced this kind of problem).
- The language is very easy to learn and to describe.
- It allows describing **real programs**, making Dune relatively
  generic and enabling additional tasks.

So, from my point of view, the choice of **S-expressions** is
relevant: it allows describing complex, readable programs without
being too verbose, does not significantly slow down compilation, and
enables very concise descriptions of highly complex build rules. And
to be completely honest, you get used to it very quickly!

##### Contribution to the state of the art: Selective Applicative Functor

In addition to being a very pleasant _build-system_, Dune has
contributed to the state of the art in research by highlighting a new
construction _inspired by category theory_. Indeed, in 2018, [Andrey
Mokhov](https://blogs.ncl.ac.uk/andreymokhov/about/), [Neil
Mitchell](https://ndmitchell.com/) and [Simon Peyton
Jones](https://simon.peytonjones.org/) proposed, in the excellent
paper ["*Build Systems à la
Carte*"](https://dl.acm.org/doi/10.1145/3236774), a collection of
abstractions to re-implement — modularly — various
_build-systems_. However, for reasons related to **static dependency
analysis**, these models were not compatible with Dune. After several
investigations and experiments, a new construction, similar to an
[Applicative](https://hackage.haskell.org/package/base-4.20.0.1/docs/Control-Applicative.html),
a [Selective Applicative
Functor](https://dl.acm.org/doi/10.1145/3341694), capturing Dune's
prerequisites was proposed. This information may seem anecdotal, but,
in my view, it reinforces the value (and importance) of being at **the
intersection of research and industry**.

##### Alternatives

Although widely adopted by the community, OCaml offers alternative
systems (sometimes using Dune _under the hood_), for example,
[Obazl](https://obazl.github.io/docs_obazl/) which provides OCaml
rules for [Bazel](https://bazel.build/),
[Onix](https://github.com/rizo/onix) which allows building projects
with [Nix](https://nixos.org), [Buck2](https://buck2.build/) which is
an ambitious and generic project competing with Bazel, and
[Drom](https://github.com/OCamlPro/drom) which offers an experience
similar to [Cargo](https://doc.rust-lang.org/stable/cargo/), unifying
package management and project building.

#### LSP and Merlin for editors

In the previous sections, we saw how much OCaml has progressed in
areas necessary for industrialization. On the other hand, in terms of
editor support, OCaml has had excellent support for
[Vim](https://www.vim.org/) and
[Emacs](https://www.gnu.org/software/emacs/) for over 10 years through
the [Merlin](https://github.com/ocaml/merlin) project, which provides
editor services enabling **completion**, **diagnostics**, **code
navigation** features, tools related to **value deconstruction**,
**value construction**, management (and navigation) of **typed
holes**, **polarity-based search**, precise information (with
verbosity control) on **value types**, ***jump-to-definition***, etc.

In my opinion, IDE support via Merlin has been excellent in OCaml for
a very long time. Coupled with
[ocp-indent](https://github.com/OCamlPro/ocp-indent), which calculates
the cursor position after an action in the editor, and
[OCamlformat](https://github.com/ocaml-ppx/ocamlformat), which allows
on-the-fly (configurable) formatting of OCaml files, writing code in
Emacs or Vim is an absolute joy!

##### The advent of VSCode, LSP as standard

In 2015, [Visual Studio
Code](https://en.wikipedia.org/wiki/Visual_Studio_Code) arrived,
introducing the [Language Server
Protocol](https://en.wikipedia.org/wiki/Language_Server_Protocol),
which abstracts how editors interact with a language through a server,
following a uniform protocol. OCaml has a [very good LSP
server](https://github.com/ocaml/ocaml-lsp) that itself relies on
well-established libraries in the OCaml ecosystem, notably
Merlin. Since LSP has become _relatively standard_ in the editor world
(Vim, Emacs, and, in fact, almost all free editors I know can interact
with an LSP server), the plan is to deprecate the Merlin server,
moving entirely to LSP, making Merlin a low-level library that
provides tooling used by LSP. This is one of the projects the `Editor`
team at [Tarides](https://tarides.com) (which I’m part of) is working
on: making `ocaml-lsp` feature-compatible with Merlin’s historic
server to reduce maintenance for alternative clients (Emacs and Vim),
only worrying about OCaml-specific requests and actions (which,
logically, are not part of the protocol).

Currently, the [OCaml platform for Visual Studio
Code](https://marketplace.visualstudio.com/items?itemName=ocamllabs.ocaml-platform)
and [OCaml-eglot](https://github.com/tarides/ocaml-eglot) are the two
canonical implementations (which extend the LSP protocol for OCaml),
respectively for VSCode and Emacs. We are currently considering the
implementation of a NeoVim plugin.

A bit like with Dune, in my opinion, the tooling state is excellent,
and the roadmap is motivating! However, since this is **my work**, I’m
probably biased.


#### Odoc, the documentation generator

OCaml is distributed with a documentation generator, the venerable
[OCamldoc](https://ocaml.org/manual/5.2/ocamldoc.html); however, it is
no longer recommended by/for the community. Indeed, the tool being
promoted is [Odoc](https://ocaml.github.io/odoc/), a new tool that
exists outside the compiler and offers several very interesting
features:

- a _rich markup_ language, supporting cross-references
- the ability to write "manual" pages, ephemeral, while still
  benefiting from cross-references
- very good integration with Dune
- a type-based search bar (implemented via
  [Sherlodoc](https://doc.sherlocode.com/))
- inclusion of source code (written in the documentation or documented
  modules)
- implementation of _drivers_ allowing the generation of large sets of
  documentation (used to implement [the documentation of all packages
  on OPAM](https://ocaml.org/packages))
- support for [_doctest_](https://en.wikipedia.org/wiki/Doctest) via
  [mdx](https://github.com/realworldocaml/mdx)

Even though the _look'n feel_ of documentation generated by Odoc is,
in my view, **far superior** to that produced by OCamldoc, there is
still (once again, in my view) a bit of work needed on the UI for the
tool to be truly **perfect**!

I clearly have a certain fondness for the documentation of the
[Elixir](https://elixir-lang.org/) language,
[HexDoc](https://hexdocs.pm/) (in terms of _design_ and features), and
personally, I would like OCaml to move toward that example. However,
it must be acknowledged that the documentation generated by Odoc is
superior to that of many other languages. Moreover, due to the highly
modular nature of the language, a good documentation generator that
effectively supports _cross-references_ is quite an achievement!

### Available libraries

We have seen that the language is _cool_, and that it has tooling
which, although still evolving, is effective and pleasant to
use. Could its lack of popularity be due to a too limited set of
libraries? To be completely honest, **I don’t know**. What I do know
is that whenever I have had to write OCaml projects, both professional
and personal, I have often found everything I needed in the [package
list](https://ocaml.org/packages). I think the reasons why OCaml is
mature enough for many typical projects can be summarized in several
points:

- Companies like [Lexifi](https://www.lexifi.com/) and
  [Janestreet](https://www.janestreet.com/) have strongly contributed
  to the ecosystem by releasing many libraries necessary for their
  daily use.
- Ambitious research projects, such as, in the case of the Web,
  [Ocsigen](https://ocsigen.org/home/intro.html), used industrially in
  the [BeSport](https://www.besport.com) project, have generated a
  collection of useful libraries.
- As mentioned earlier, [MirageOS](https://mirage.io), with its
  [*Clean
  Slate*](https://blog.container-solutions.com/all-about-unikernels-part-1-what-they-are)
  approach, naturally produced many robust libraries.
- Like in popular languages such as JavaScript or Rust, motivated
  contributors have provided excellent libraries.
- The language is old and has been used industrially for a long time.

For my part, I have sometimes _re-created_ libraries for the
**pleasure of reinventing the wheel**, but also, at times, to offer an
alternative interface. Moreover, OCaml allows interfacing with, among
other languages, C, enabling the creation of _bindings_ for a large
number of libraries and tools. However, if there is a library that you
find _objectively_ missing, I encourage you to join [the
community](https://ocaml.org/community).

It is important to note that my use of OCaml has focused primarily on
three areas:

- **Web development** (heavily driven by Mirage, Ocsigen, and
  independent projects like [Dream](https://aantron.github.io/dream/),
  [YOCaml](https://github.com/xhtmlboi/yocaml), and many
  [others](https://ocaml.org/packages/search?q=web))
- **Blockchain development** and, by extension, the use of
  cryptography libraries, provided once again by Mirage, as well as by
  the [HACL\*](https://github.com/hacl-star/hacl-star) project, a
  formally verified library written in [F\*](https://fstar-lang.org/)
  and extracted to OCaml
- **Development of [Merlin](https://github.com/ocaml/merlin)** and
  [OCaml-LSP](https://github.com/ocaml/ocaml-lsp)

All these areas still require good testing tooling, and OCaml offers
several complementary libraries to implement robust test
suites. Indeed, within the OCaml ecosystem, you can find tools to
write [doctests](https://github.com/realworldocaml/mdx), classic [unit
tests](https://github.com/mirage/alcotest), [property-based
tests](https://github.com/c-cube/qcheck),
[fuzzing](https://github.com/stedolan/crowbar), as well as [output
observation
tests](https://dune.readthedocs.io/en/stable/tests.html#inline-expectation-tests),
[inline
tests](https://dune.readthedocs.io/en/stable/tests.html#inline-tests)
(which allow testing, among other things, private components), and
[cram
tests](https://dune.readthedocs.io/en/latest/reference/cram.html).

I continue to find everything I need among the available packages, and
I’m still very impressed to see the number of packages and
alternatives grow _year after year_. Of course, there are some gaps,
but they have not invalidated my choice of OCaml.

#### Side note on the standard library

A recurring criticism of OCaml is the _modesty_ of its standard
library. Historically, it was designed only to implement the language
itself, so it didn’t include certain features useful for end
users. This situation has led to the emergence of alternative standard
libraries, the most popular of which are:

- [Batteries](https://github.com/ocaml-batteries-team/batteries-included),
  an alternative to the standard library that is somewhat
  _dated_. Historically, it was a _fork_ of
  [Extlib](https://github.com/ygrek/ocaml-extlib).
- [Base](https://opensource.janestreet.com/base/), an alternative
  developed by [Janestreet](https://janestreet.com), used _quite
  extensively_ in the book [Real World
  OCaml](https://dev.realworldocaml.org/). The library enforces strong
  conventions, such as _labeling_ higher-order functions (typically
  with the name `f`).
- [Core](https://opensource.janestreet.com/core/) is an extension of
  Base.
- [Containers](https://github.com/c-cube/ocaml-containers) is an
  extension of the standard library (in the sense that `open
  Containers` at the beginning of a module does not break code written
  with the standard library).

In addition to these alternative standard libraries, there are
specialized libraries that address general problems, such as
[Bos](https://github.com/dbuenzli/bos), which provides tools to
interact with an operating system, and
[Preface](https://github.com/xvw/preface) — _shameless plug_ — which
allows you to _realize abstractions from category theory_.

The stance of the maintainers on the standard library has evolved over
the years, and it is now possible to consider extending it. However,
additions to the standard library are often subject to debate, and
adding new modules can sometimes take a long time. Personally, I would
have preferred that the standard library **continue to serve only the
development of the language** and that a library under the OCaml
community umbrella be published. This separation allows the releases
of the language and its standard library to be desynchronized and also
likely simplifies compatibility between the library and the language.

### Ecosystem Conclusion

Unfortunately, I don’t have the opportunity to cover all the tools of
the platform, nor the fundamental building blocks that make OCaml
enjoyable to use for personal projects as well as for industrial
projects (for example, the various existing
[debuggers](https://github.com/hackwaly/ocamlearlybird)). However, I
hope I’ve been able to give an overview of some tools that form a
solid foundation for using OCaml.

In my use of the language, I’ve sometimes had to build my own library;
however, it’s not an exercise I regret. I think, unfortunately, that
if one decides never to use a language just because 100% of the
necessary libraries aren’t available, it feels—perhaps awkwardly—to me
like **leveling down**, trapping us behind languages backed by
_wealthy companies_, like Java or C#, and **that’s a bit sad**.

## On the community

Even though I’ve used many different programming languages, I think
OCaml is the only one with which I’ve had strong community
interaction. So, I’m not fully aware of how things work in other
communities, which makes my feedback _somewhat irrelevant_. But from
my experience, I find that the OCaml community, besides being very
productive, is:


- **Very accessible**: Like many other languages, OCaml has a [strong
  online presence](https://ocaml.org/community). On these platforms,
  you can find highly experienced contributors to the language and its
  ecosystem and benefit from expert (or sometimes less technical)
  advice. I’d like to give a special mention to [Gabriel
  Scherer](http://gasche.info) and [Florian
  Angeletti](https://perso.quaesituri.org/florian.angeletti), whose
  answers are always thoughtful and interesting.

- **Very kind**: I often need to ask for help, and I’ve always
  received clear and precise answers, whether in private or in public.

- **Very brilliant**: OCaml is the product of work by _brilliant
  researchers_, and having the chance to interact with them is
  incredible (and potentially a bit intimidating). Being able to ask
  questions directly to people behind some of the major discoveries in
  language design is a fantastic opportunity.

To conclude on the community aspect, even though I’m not fully aware
of how other communities interact, I find it a pleasure to be part of
the OCaml developer community. It’s a welcoming space, conducive to
sharing and learning.

## Some myths about OCaml

I’m finally reaching the most fun part of this overly long article: I
get to **debunk** some persistent myths about OCaml. I still can’t
promise complete objectivity, but know that my intentions are good. On
the internet, you often see various criticisms or remarks about OCaml,
and I often find it tiresome to respond. However, what better way than
an article meant to share my enthusiasm for the language to take the
time to address some of these critiques and try to provide a response?

I’ve selected a few, but it’s likely that in the future I’ll write
somewhat longer articles—similar to the members of [HeyPlzLookAtMe
(fr)](https://www.heyplzlookat.me/articles/critique-de-la-raison-pure.gmi)
— about articles I find unfair.

### OCaml and F\#

[F#](https://fsharp.org/) is a programming language [historically very
inspired](https://fsharp.org/history/hopl-final/hopl-fsharp.pdf) by
OCaml that runs on the [.NET](https://dotnet.microsoft.com) platform
(and, de facto, integrates very well with C#). I find the language — 
which I have professionally used at
[DernierCri](https://derniercri.io/) and
[D-Edge](https://www.d-edge.com) — very pleasant. Historically, since
.NET was exclusively for Windows environments, OCaml didn’t suffer
much by comparison. However, since the arrival of [.NET
Core](https://github.com/dotnet/core), a cross-platform implementation
of .NET, I increasingly see statements on the internet like:

> "Why continue using OCaml when you can have the same language, F#,
> with the entire .NET ecosystem, more features, and a syntax that’s
> more pleasant to use?"

First, I do think that having the .NET (Core) ecosystem is a huge
advantage. Regarding the syntax, I’m more reserved. Indeed, I find
that indentation-based syntax sometimes makes moving code around more
cumbersome, and even though there are criticisms of OCaml’s syntax, I
must admit it hasn’t let me down. The last point seems a bit more
insidious. Indeed, F# has been equipped with features not present in
OCaml, for example:

- [Computation
  expressions](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/computation-expressions)
  (which are syntactically a more general form than [binding
  operators](https://ocaml.org/manual/5.2/bindingops.html))
- [Type
  providers](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/computation-expressions)
  (which can, unfortunately, sometimes cause issues with .NET Core in
  certain name/path resolution cases)
- [Active
  patterns](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/active-patterns)
- [Statically resolved type
  parameters](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters)
- The ability to assign methods to sums and products, which makes
  sense for interoperability reasons but significantly breaks type
  inference
- And probably other features that I don’t know well (or are linked to
  interoperability with the .NET platform, notably
  [reflection](https://learn.microsoft.com/fr-fr/dotnet/fsharp/language-reference/attributes))

These evolutions arrived gradually in the language. It would be naive
to think that OCaml hasn’t evolved as well. Indeed, although
historically the two languages seemed very similar, from the very
beginning of F#’s proposal, certain features were missing:

- The absence of a **module language**. Indeed, the `module` keyword
  exists in F#, but it is only used to describe static classes (and it
  integrates rather awkwardly with namespaces).

- A **drastically different object model** (for interoperability with
  C#, of course).

These two reasons alone would be enough to consider OCaml and F# as
_cousin_ languages but **very different**, and in my opinion, strongly
justify preferring one over the other. In my case, OCaml over F# makes
the introductory sentence of this section moot. However, like F#,
OCaml has also evolved, and in addition to these two fundamental
differences, OCaml offers many features that are absent in F#:

- **Local and generalized `open`s**: In OCaml, you can open a module
  locally within a scope, whereas in F# you can only open a module at
  the _top-level_, which can be quite frustrating in some cases.
- **Row polymorphism**: OCaml supports row polymorphism on products
  (via objects) and sums (via [polymorphic
  variants](https://ocaml.org/manual/5.2/polyvariant.html)).
- **Generalized Algebraic Data Types (GADTs)**: One of the most missed
  features (after the module system) for expressing precise type
  constraints.
- **User-defined effects**: OCaml allows defining custom effect
  handlers, which can simplify complex control flow and concurrency
  patterns.
- **Open sums**: Extensible variants allow for sum types that can be
  extended, though similar behavior can sometimes be simulated using
  objects and inheritance.

To conclude, even though F# is a really nice language and using it
brings many advantages (notably the .NET platform), it is **not just a
better version of OCaml**. The two languages are very different, and
from my point of view, OCaml has a more sophisticated type system,
which makes me prefer it over F#. In my opinion, saying that F# is
just a prettier OCaml is as reasonable as saying that
[Kotlin](https://kotlinlang.org/) is nothing more than
[Scala](https://www.scala-lang.org/) with a lighter syntax.

### Doubled operators for floats

The standard library contains the following arithmetic operators on
integers:

```ocaml
val ( + ) : int -> int -> int
val ( - ) : int -> int -> int
val ( * ) : int -> int -> int
```

But also arithmetic operators for floating point numbers:

```ocaml
val ( +. ) : float -> float -> float
val ( -. ) : float -> float -> float
val ( *. ) : float -> float -> float
```

At first glance, this may seem confusing. However, it makes perfect
sense. If we wanted to have generic operators, we would need [ad-hoc
polymorphism](https://en.wikipedia.org/wiki/Ad_hoc_polymorphism), like
in Haskell, for example, where arithmetic operators reside in the
`Num` type class:

```haskell
class  Num a  where
  -- more code
  (+), (-), (*) :: a -> a -> a
  -- more code
```

Without some form of ad-hoc polymorphism (via classes, traits, or
implicits) to describe a constraint on our operators, e.g., `op :: Num
a => a -> a -> a`, what can we do? A suggestion I’ve often seen online
is to use _the same trick_ as with the `=` operator, whose type is
`val (=) : 'a -> 'a -> 'a -> bool`. That doesn’t work, because while
we can hope that _everything is comparable_ (at worst, we can return
`false`), how can we generalize something like addition?

Support for arithmetic operators is a tricky problem, which is
actually the original motivation behind [type
classes](https://en.wikipedia.org/wiki/Type_class) (and the reason for
[statically resolved type
parameters](https://learn.microsoft.com/en-us/dotnet/fsharp/language-reference/generics/statically-resolved-type-parameters)
in F#). From my perspective, _while waiting for [modular
implicits](https://www.cl.cam.ac.uk/~jdy22/papers/modular-implicits.pdf)_,
duplicating operators to work with integers and floats seems like a
_reasonable_ approach. And if, for some strange reason, suffixing
operators with dots when using floats gives you hives, you can avoid
it using local opens by providing, for example, this module:

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

Which allows extending the `Int` and `Float` modules (which already
provide the functions `add`, `sub`, `mul`, and `div`) by giving them
arithmetic operators:

```ocaml
module Int = struct
  include Int
  include Arithmetic (Int)
end
```

In broad terms, we create an `Int` module, include the previous `Int`
module so that our new `Int` module retains the entire API of the
original `Int` module, and then we define (and include) our arithmetic
operators. We can now repeat the same process with `Float`:

```ocaml
module Float = struct
  include Float
  include Arithmetic (Float)
end
```

And now we can use a local `open` so that we don’t have to suffix our
operators with dots:

```ocaml
let x = Int.(1 + 2 + 3 + (4 * 6 / 7))
let y = Float.(1.3 + 2.5 + 3.1 + (4.6 * 6.8 / 7.9))
```

From my point of view, even if this can be confusing for those coming
from languages where this isn’t an issue, it’s a minor problem. The
lack of operator overloading seems like a rather weak argument for not
giving a language a chance — _but that’s just my humble opinion_.

### On the separation between `ml` and `mli`

Another point that generates a lot of discussion (even
[recently](https://discuss.ocaml.org/t/has-there-been-a-syntax-proposed-for-combining-mli-into-ml/15163))
concerns the **separation between `ml` and `mli` files**. Personally,
I find it great. Even if it can introduce a bit of repetition, it
allows me to focus on the API via module encapsulation in the `mli`
file while also adding documentation. I can organize the functions I
expose in any order I like, and naturally, I can abstract the types I
share as much as possible. Moreover, when I look at an implementation,
the `ml` code is rarely cluttered with documentation, making it easy
to navigate the different elements of the module. On top of that, it
enables separate compilation and prevents recompiling modules that
depend on other modules whose implementation alone was changed during
development (this is Dune’s default behavior in the `dev` profile).

However, tastes vary, and when exposing complex types or module types,
this repetition can be annoying. Fortunately, there is a _trick_,
presented in 2020 by [Craig Ferguson](https://www.craigfe.io), that
helps mitigate this repetition: [The `_intf_`
trick](https://www.craigfe.io/posts/the-intf-trick).

Additionally, there are small tricks based on the ability to pass
arbitrary module expressions to the `open` and `include` primitives,
which sometimes allow you to do without `mli`. I had already mentioned
this in the article [OCaml, modules and import
schemes](/en/articles/modules-import.html).

#### Encapsulation without `mli`

You can simply use `open struct (* private code *) end` to avoid
exporting parts of your code without needing interfaces. For example:

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

#### Expressing the interface from `ml`

Another similar technique is to use `include (struct ... end : sig (*
public API *) end)` to describe both the structure and the interface
in the same file. For example:

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

This way, the signature and the structure live in the same file, while
still allowing precise control over encapsulation. Another approach
would be to put the signature in a dedicated `module type`, like this:

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

This is very similar to the first approach, except that the module
also exposes the module type `S`. A useful side effect of this _leak_
is that you can easily reference the module's signature using
`My_mod.S` instead of having to write `module type of My_mod`.

#### To conclude on separation

I find this separation **very desirable**. However, since OCaml’s
module system is highly expressive, it is possible — through some
clever encoding — to work around this separation. From my point of
view, these approaches mainly serve to demonstrate this
_expressiveness_, because the downside of merging everything in one
file is the loss of separate compilation, which I consider _quite
unfortunate_.

## Conclusion

I think I have _briefly_ covered the points I wanted to discuss. From
my perspective, **OCaml is an amazing language**! It offers an
excellent balance between safety and expressiveness, thanks in
particular to its advanced type system, a rich module language,
objects, support for _row polymorphism_ via objects and polymorphic
variants, and user-defined effects! Its intersection of research and
industry makes it, in my view, a language evolving in the right
direction, carefully integrating new features to stay modern without
suffering the pitfalls of too-rapid or untested adoption.

Even though for several years OCaml’s tooling might have seemed a bit…
_dusty_, recently, thanks in part to commercial support from certain
companies, the tooling has been drastically modernized and continues
to improve, as shown by [the platform
roadmap](https://ocaml.org/tools/platform-roadmap). Additionally, the
growing ecosystem of libraries makes it possible to use OCaml in a
wide range of contexts, notably thanks to its different compilation
targets (for example, the browser via
[js\_of\_ocaml](https://github.com/ocsigen/js_of_ocaml) and
[wasm\_of\_ocaml](https://github.com/ocaml-wasm/wasm_of_ocaml)).

By combining an expressive language with a versatile ecosystem and a
supportive, responsive community, OCaml becomes a very compelling
choice for both personal and professional projects. Clearly, migrating
an entire codebase to OCaml is probably not a pragmatic move, but if
you have small personal projects in mind and are curious and
entertained by programming languages, **I seriously encourage you to
consider OCaml**!

I hope I’ve managed to convey my enthusiasm for this language (and its
ecosystem). If you’d like to discuss it, find projects, or explore
contribution opportunities, I’d be happy to talk with you — or you can
reach out to the community through [the
forum](https://discuss.ocaml.org/), which is active, responsive, and
welcoming!
