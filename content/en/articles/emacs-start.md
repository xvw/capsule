---
page_title: Emacs, how it all started (for me)
description:
  A presentation of why, and how, I started using Emacs
tags: [programmation, emacs]
section: tools
published_at: 2026-06-15
display_toc: true
synopsis:
  I have been using (_badly_) [Emacs](https://www.gnu.org/software/emacs/)
  since around 2008. In this short article, I will try to present the
  **chaotic path** that led me to choose Emacs as my main text and code
  editor. This is **absolutely not a tutorial**, but rather a small piece
  of my personal lore, because it is quite amusing to describe clumsy
  choices that, in hindsight, turned out to be, in my view, beneficial. 
  This article is **largely inspired**, while being less ambitious, by
  the [April 2026](https://www.emacswiki.org/emacs/CarnivalApril2026)
  topic of the [Emacs Carnival](https://www.emacswiki.org/emacs/Carnival).
origin: /pages/emacs-start.html
---

While I can have very strong opinions on many topics (notably on
[programming languages](/pages/why-ocaml.html)), I am much less
emotionally invested in the ancient [_Editor
War_](https://en.wikipedia.org/wiki/Editor_war).  Indeed, even though
I sometimes defend Emacs _mordicus_, to be honest I do not know that
much about it and **I have never tried
[Vi/Vim](https://www.vim.org/)** (nor its
[variations](https://neovim.io/)). So please consider this article
only as an approximate historical account of the reasons that led me
to choose Emacs, and not as an attempt at a debate.

> I have absolutely nothing against other editors. Even though my
> professional work involve maintaining editor support for the OCaml
> language, and I have sometimes been frustrated by the difficulties
> one can encounter when extending [Visual Studio
> Code](https://code.visualstudio.com/), I do not hold any particular
> hostility toward them. Similarly, although I try to favor free
> software whenever possible, I am unfortunately not very familiar
> with licensing issues, the various philosophies, or more generally
> anything related to the [GNU](https://en.wikipedia.org/wiki/GNU)
> world. My choice of Emacs is therefore not a political one, but a
> pragmatic one, as we will try to show in this article.

## My prehistory

Before telling the story of my encounter with Emacs, I will take a
brief detour through the completely stupid choices I made over the
years before I seriously started writing code. Indeed, when you begin
discovering programming as a self-taught developer, you can run into a
lot of difficulties and, in my case, from the very first seconds, I
was confronted with terminological problems.

### Writing code with Microsoft Word

Like many people of my generation, I started *seriously* trying to
program with [PHP](https://www.php.net/). At the time, I did not have
regular access to an internet connection, so I learned mainly from
books, and, not having installation rights on my computer, **I assumed
that what I was writing actually worked** (*true story*). The book I
was using to try to understand PHP (whose title and edition I sadly no
longer remember) stated in its introduction that **to write code, we
could use any text editor**. Since I was very young and I was not
executing my code, I decided to use [Microsoft
Word](https://en.wikipedia.org/wiki/Microsoft_Word).  And yes,
understanding the difference between a *text editor* and a *rich text
editor* was, at the time, too much for me.

### EasyPHP, Notepad and Notepad++

After finally having the opportunity to run the code I was writing,
*via a CD-ROM* that provided an installer for
[EasyPHP](https://www.easyphp.org/), I was able to *naively understand
the difference between a text editor and a rich text editor* and ...
I switched to
[Notepad](https://en.wikipedia.org/wiki/Windows_Notepad).  At the
time, I did not really understand the code I was writing (and
copy-pasting), and I did not fully realize the importance of syntax
highlighting and indentation preservation.

Once I was able to *run my PHP programs*, I gradually became more
ambitious and eventually discovered **my first code editor**:
[Notepad++](https://en.wikipedia.org/wiki/Notepad%2B%2B). A true
*epiphany*.

> It is quite amusing to realize that, when you have not been exposed
> to a comfortable tool, you laboriously make do without it, while
> imagining that you can live without it forever. I suppose this also
> applies to programming languages. Without sum types, one tends to
> think they are not particularly useful, until you actually use
> them...  in practice.

I used Notepad++ for a long time, with a few detours through
[SciTE](https://en.wikipedia.org/wiki/SciTE), then
[Eclipse](https://en.wikipedia.org/wiki/Eclipse_%28software%29) and
its PHP support (which, although offering more features, even in a
[*pré-LSP*](https://fr.wikipedia.org/wiki/Language_Server_Protocol)
era, gave me a lot of trouble, probably because I was not wired for
the tool).

Then I jumped on the [Sublime
Text](https://en.wikipedia.org/wiki/Sublime_Text) bandwagon, thinking
it would be **the last code editor I would ever use in my life**, as I
was so convinced by its ergonomics and aesthetics.

### Le Site du Zéro: discovering alternatives

After having used PHP *to do things*, I started getting interested in
programming **for programming’s sake**, and I ended up on [Le Site Du
Zéro](https://en.wikipedia.org/wiki/OpenClassrooms#History). I had
been active on *Le Site Du Zéro* as a *“PHP developer”*, but I was not
particularly familiar with the forum (nor with *forums* in general).
One of the strengths of *Le Site Du Zéro*, in addition to some of its
*tutorials*, was **its community** (which was significantly reduced
when it transitioned into
[OpenClassrooms](https://openclassrooms.com/en/)).

Indeed, on this very active forum, there was a collection of users
passionate about programming, using languages very different from
those I had been exposed to! By browsing the various *forum topics*, I
discovered names of languages such as [OCaml](https://ocaml.org),
[Erlang](https://www.erlang.org/),
[Forth](https://en.wikipedia.org/wiki/Forth_%28programming_language%29),
[Haskell](https://www.haskell.org/),
[Io](https://en.wikipedia.org/wiki/Io_%28programming_language%29),
[Smalltalk](https://en.wikipedia.org/wiki/Smalltalk), various
[Lisp](https://en.wikipedia.org/wiki/Lisp_%28programming_language%29)
dialects, and many others, more or less *obscure*.

In 2026, this list is probably underwhelming, as these languages have
become popular. But at the time, when I only knew PHP, I was very
poorly educated about the vast diversity of programming languages.

> It is quite amusing to see that, more than 15 years later, this
> initial curiosity has led me to work professionally with less
> popular languages such as Erlang and OCaml, and that I have had the
> opportunity (and the honor) to collaborate with users so far ahead
> of my own knowledge that they implicitly introduced me to these
> alternative languages.

It was very motivating to discover these other languages, however I
was quite frustrated to realize that I did not understand anything. I
therefore decided to learn as many languages as possible, hoping that
this would help me improve my PHP skills and, above all, choose the
ideal language depending on the problems at hand, while trying to
avoid falling into the [Law of the
Instrument](https://en.wikipedia.org/wiki/Law_of_the_instrument), a
trap I only fell into much later, because now, **in the projects I
work on every day**, I have come to the conclusion that **OCaml is
always the right answer**, _hehehe_.

#### Experimenting with as many programming languages as possible

I was _very, very motivated_ and I went to the [_List of programming
languages_](https://en.wikipedia.org/wiki/List_of_programming_languages)
page with **a simple goal**: for each language, try to find a compiler
or an interpreter, and attempt to write a
[Brainfuck](https://en.wikipedia.org/wiki/Brainfuck) interpreter!

I naturally allowed myself the freedom to skip some languages if they
seemed too far from any realistic, practical use case (attempting to
write a Brainfuck interpreter in
[HAL/S](https://en.wikipedia.org/wiki/HAL/S), for instance, felt very
ambitious).

## Emacs to the rescue ... on Windows

At the time, I was heavily using software from the [Adobe Creative
Suite](https://en.wikipedia.org/wiki/Adobe_Creative_Suite) as well as
Windows, and I did not realize how limiting this was for learning to
program. This made my search for installable compilers and
interpreters **significantly more difficult**. In addition, having
grown used to syntax highlighting and indentation preservation, I also
wanted a _decent_ editor setup.

### One mode per problem and excellent Windows support

It turns out that, at the time, before editor interaction
standardization protocols such as LSP (or _TreeSitter_) had really
matured, I had the impression that **Emacs was the standard**. Indeed,
even for [languages that seemed obscure to
me](https://en.wikipedia.org/wiki/Lustre_(programming_language)), I
could almost always find a corresponding [Emacs
mode](https://www.gricad-gitlab.univ-grenoble-alpes.fr/verimag/reproducible-research/run-bench/-/blob/main/styles/emacs/lustre.el)!
Moreover, **surprisingly enough**, Emacs’ Windows support was (and
very likely still is) excellent.

The only concrete difficulty I faced at the time was that, as a
beginner Windows user, I had no idea what my `$PATH` was, and I spent
a lot of time trying to figure out "_how and where to configure
Emacs_".

After dozens of experiments, Windows started to feel too limiting, so
I moved to a Linux distribution, first through virtualization, then
via _dual-boot_, until in 2014 I deleted my Windows partition and went
from _a bad Windows user_ to _a bad Linux user_.

## Conclusion

It is quite amusing that I ended up using one of the
[earliest](https://en.wikipedia.org/wiki/History_of_free_and_open-source_software)
free software programs on a proprietary operating system, only to
eventually decide to migrate permanently to something _more free_. I
continued using Emacs as my main editor over the years, gradually
trying to learn how to use it more effectively. This learning phase is
still ongoing, even though I now maintain my [own
package](https://github.com/tarides/ocaml-eglot), have learned to
build a [somewhat overly generic
configuration](https://github.com/xvw/scame), and avidly read various
Emacs-related _feeds_.

I have sometimes had to take detours through other editors, such as
[IntelliJ](https://www.jetbrains.com/) (_JVM reasons_) and [Visual
Studio](https://visualstudio.microsoft.com/) (_#NET reasons_), and I
have occasionally experimented with alternatives. However, time and
habits had already taken root, and **I always inevitably come back to
Emacs** (muscle memory and
[Bastien](https://github.com/BastienDuplessier) often helped bring me
back to reason). Years later, I do not regret this choice at all, made
for _ad hoc_ and chaotic reasons. I am an Emacs user!

This was a slightly longer article than expected, with many detours
and not much useful information. If you made it this far, _thank you_!
