---
page_title: L'enfer du Tetra Master
description: Présentation aigrie du jeu de cartes de Final Fantasy 9
tags: [final-fantasy, game-design, jeu-video, ocaml]
section: jeu-video
published_at: 2023-09-05
display_toc: true
breadcrumb:
  - title: Technologies
    url: /#index-technologies
  - title: Jeux vidéo
    url: /games.html
synopsis: 
  Le _Tetra Master_ est le jeu de cartes facultatif du jeu
  **Final Fantasy 9**. Son fonctionnement est, en surface, similaire
  au _Triple Triad_ — le jeu de cartes de Final Fantasy 8 — cependant,
  même s'il est possible de capturer une intuition générale nous
  permettant de gagner, pour peu que l'on possède des bonnes cartes,
  après plus d'une centaine de parties, je dois avouer avoir accepté le
  fait que, juste en jouant au jeu, et en lisant tous les didacticiels
  _en jeu_, je fusse incapable d'en comprendre l'ensemble des règles, me
  poussant à me documenter pour comprendre ce que j'avais raté. L'absence
  d' **aucune règle** dans le jeu (ou le manuel) m'a exaspéré, me
  poussant à écrire cet article ...
---

Attention, ma critique salée **ne porte que sur le jeu Tetra
Master**. Bien que je puisse parfaitement comprendre (et accepter)
certaines critiques formulées à l'égard du neuvième opus de la saga,
j'ai, peut-être par nostalgie, beaucoup apprécié le jeu. De plus, le
jeu de cartes n'est pas un élément bloquant pour le progrès dans
l'aventure, il est donc possible de parfaitement apprécier le jeu,
tout en ne conservant qu'une très légère frustration de ne pas
comprendre les rouages complexes — et discutablement inférables — de
son système de règles.

Certaines personnes trouveront ça très étrange de revenir sur ce jeu,
**plus de 22 ans** après sa sortie en Europe... c'est vrai ! Je dois
vous avouer que je trouve ça très rigolo de tâcher de transformer ce
site web en _un genre de bibliothèque poussiéreuse_, remplie de
_savoirs inutiles_.

### Mise en contexte

J'ai découvert la saga [Final
Fantasy](https://en.wikipedia.org/wiki/Final_Fantasy) par le biais du
7ème opus, à la fin des années 90, regardant avidement mon cousin,
Thomas, y jouer. J'avais été très marqué, et je suis devenu un grand
amateur de la série, pour ses ambiances, ses musiques, et ses
histoires. Par contre, étant très jeune, et n'ayant pour seule
expérience du genre
[JRPG](https://en.wikipedia.org/wiki/History_of_Eastern_role-playing_video_games#Japanese_role-playing_games)
Pokemon rouge, je me souciais peu de mécaniques — quelle horreur, me
direz-vous, je passais à côté de ce qui fait qu'un jeu vidéo **est**
un jeu — et donc je lisais peu les didacticiels de jeu, ne cherchant
qu'à progresser dans l'histoire.

> Même si la série Final Fantasy — du moins, les épisodes parvenus
> jusqu'en Europe à cette époque — n'est pas réputée pour être une
> collection de jeux difficile, ne pas s'embarrasser de la
> compréhension, par exemple, du sysème de
> [materia](http://ff7.fr/materias.php), dans Final Fantasy 7 peut
> rendre la progression de l'aventure **très complexe**. Et oui, bien
> que les opus 6, 7, 8 et 9 de Final Fantasy soient, en terme de
> [_Skill Ceiling_](https://en.wiktionary.org/wiki/skill_ceiling),
> similaires aux versions rouge et bleue de Pokemon, j'ai l'intuition
> que le [_Skill Floor_](https://en.wiktionary.org/wiki/skill_floor)
> des trois Final Fantasy est largement plus élevé.

Gardant une sympathie, pendant plusieurs années, sur ces jeux que je
n'avais **jamais** terminés, des années plus tard, je décidais d'y
rejouer, avec l'ambition de les terminer. De plus, à cette époque, mon
intérêt en tant que programmeur se portait sur la série
[RPGMaker](https://www.rpgmakerweb.com/) (un _logiciel jouet_ pour
construire des RPGs, en offrant une interface de de programmation pour
la construction de systèmes originaux et laissant un très grande
liberté de personnalisation pour les [utilisateurs plus
chevronnés](https://www.aedemphia-rpg.net/)), jouer à des classiques
du genre me semblait être une très bonne approche !

Comme les _JRPGs_ sont, très souvent, des jeux longs, et que je n'y
jouais pas à la fréquence d'un _hardcore gamer_, presque 10 ans plus
tard, après avoir terminé FF6, FF7 et FF8, mon bilan était clair:
**lire les didacticiels et comprendre les différentes mécaniques de
jeu rend l'expérience de jeu largement plus facile**. Même s'il existe
des subtilités dans chacun de ces opus, relevant plus du _Skill
Ceiling_, les jeux étaient globalement très simples — ce qui n'est pas
une critique — et je pouvais attaquer FF9, sereinement.

#### Simple, mais pas sur tous les aspects

Comme ses prédécesseurs, Final Fantasy 9 n'est pas un jeu
compliqué. Les mécaniques de jeu sont faciles d'accès et, même si
parfois les combats peuvent manquer de rythme — et le mécanisme de
[transe](https://fr.wikipedia.org/wiki/Final_Fantasy_IX#Combats) peut
être frustrant quand on vient des deux précédents jeux — on comprend
rapidement comment être efficace. La source de ma frustration provient
du jeu de cartes.  Comme son prédécesseur, le jeu embarque un système
_ad-hoc_, **le Tetra Master**, un jeu de cartes est introduit assez
rapidement dans sa diégèse. En tant que joueur, je suis généralement
assez favorable à la diversification (et la prolifération) de systèmes
_ad-hoc_, surtout dans les JRPGs, qui bénéficient, généralement, d'une
assez longue durée de vie et qui, du moins, à cette époque, étaient
souvent linéaires parce qu'ils permettent parfois de changer le rythme
et d'introduire des quêtes annexes amusantes. Dans le jeu, le Tetra
Master est introduit comme un jeu de cartes _simple_, et il est très
rapidement possible de récupérer ses premières cartes et d'apprendre
les _pretendues_ règles du jeu.

Après plus d'une centaine de parties et, tout en ayant lu
consciencieusement les différents fragments de règles éparpillées dans
le jeu — notamment via les conseils de _Jack_ — j'en suis arrivé à la
conclusion suivante : **je n'étais jamais serein lors d'une partie**,
car même si j'avais capturé l'idée générale du jeu, il semblait me
manquer quelque chose dans la compréhension des règles.

#### Découverte des règles via Internet

Frustré que, malgŕe mon expérience dans le jeu, je semblais passer à
coté de plusieurs subtilités, je fis ce que, à l'époque (aux alentours
de 2000), je ne pouvais pas faire, j'ai cherché sur le net. J'ai été
amusé de voir qu'en 2023, il existe toujours des sites, à l'apparence
des sites du début des années 2000 qui forment une base de
connaissances impressionnantes sur la licence sur lesquels j'ai pu
trouvé des règles détaillées du Tetra Master et, en effet, il me
manquait **beaucoup d'éléments** pour comprendre l'ensemble des règles
du jeu. D'ailleurs, durant mes recherches, j'ai eu l'occasion de
trouver un grand nombre de messages publiés sur des forums de joueurs
tout aussi désabusés que moi. Une fois les règles découvertes, une
autre question s'est naturellement posée : "_Comment ces sites ont-ils
découvert ces règles ?_".

Mon premier réflexe a été de consulter [le manuel
d'origine](http://s3.amazonaws.com/szmanuals/6de938ebe61e9432ea99da2095150069)
qui, possède une section dédiée au Tetra Master (page `22` et `23`).
Malheureusement, elle ne donne pas plus d'informations que ce que l'on
apprend dans le jeu. Cependant, l'encart **Card Ability Points** de la
page `22` :

> Every card has a set of numbers and letters that represents the
> strength of the card, which comes into play during card
> battles. Generally, the higher the number, the stronger the
> card. Try to figure out the effects of numbers and letters on each
> card.

Sapristi, le manuel nous provoque ! En cherchant plus profondément,
j'ai trouvé un [sombre
document](http://web.archive.org/web/20221226113714/https://gamefaqs.gamespot.com/ps/197338-final-fantasy-ix/faqs/9671),
publié en Novembre **2000**, et mis à jour jusqu'en Juin **2001**, qui
semble être la base du savoir collectif des règles du jeu. Fruit d'une
investigation poussée — incluant des demandes à
[Squaresoft](<https://en.wikipedia.org/wiki/Square_(video_game_company)>)
et probablement un peu de _reverse-engineering_ — Le document a été
initié en vue d'établir un ensemble de règles exhaustives du jeu pour
être porté en jeu de plateau et semble avoir été l'aboutissement d'une
très jolie collaboration.

Un autre point très amusant du document, au-delà d'expliquer les
règles, est qu'il met en lumière une [citation
extraordinaire](http://archive.thegia.com/letters/l0011/19.html) d'un
certain [Drew
Cosner](http://archive.thegia.com/features/990602/staff/s10.html),
membre de l'équipe de rédaction de _feu_ [The Gaming Intelligence
Agency](http://www.thegia.com/), un site éteint en 2015 proposant des
revues de jeux vidéo.

> Anyway, here it is: how the hell are you supposed to play Tetra
> Masters in FFIX? As far as I can tell, you place your cards on the
> board at random and your opponent randomly puts his cards down
> causing random cards to flip over at random, leading to the random
> card battle which is apparently won completely at random. In the
> end, one of you wins. At random.

Démontrant que non, je n'étais pas le seul ayant été frappé
d'incompréhension par des règles, je ne me contente que de m'inscrire,
20 ans plus tard, dans la collectivité des joueurs désabusés par cet
étrange jeu de cartes, pourtant tant apprécié des habitants de
l'univers imaginaire dans lequel se déroule l'histoire de, malgré
tout, **l'excellent Final Fantasy 9**.

## Le Tetra Master

Comme je l'ai évoqué dans cette _très longue_ introduction, il existe,
depuis la publication du "[sombre
document](http://web.archive.org/web/20221226113714/https://gamefaqs.gamespot.com/ps/197338-final-fantasy-ix/faqs/9671)",
énormément de ressources _en ligne_ pour apprendre les règles de
l'infernal Tetra Master. Alors à quoi bon décider, en 2023, d'en
écrire une nouvelle ? Même si l'article a essentiellement pour
objectif de râler sur la complexité des règles et sur leur
_non-découvrabilité_, je pense que documenter l'ensemble des règles,
**à ma manière** — mais en me basant sur le document précédemment cité
— appuiera mes propos, et me permet, un peu gratuitement, d'ajouter du
contenu à mon site.

### Les cartes dans l'histoire

Les cartes sont très rapidement introduites dans le _lore_ du jeu. En
effet, elles semblent susciter, dès les premiers instants de jeux, un
intérêt tout particulier pour
[Bibi](https://fr.wikipedia.org/wiki/Personnages_de_Final_Fantasy_IX#Bibi_Orunitia).
D'ailleurs, lors de la [fête de la
chasse](https://finalfantasy.fandom.com/wiki/Festival_of_the_Hunt), il
réclamme pour récompense la [carte
Aérothéatre](http://www.ff-heroes.com/final-fantasy-ix/tetra-master/liste-des-cartes/detail-de-la-carte/item/aerotheatre.html),
une carte largement superieure au niveau des cartes acquises à ce
stade de l'aventure. Bien que les cartes ne changent absolument pas la
progression dans l'histoire et ne procurent aucun bonus, on apprend
que beaucoup des habitants de l'univers du jeu jouent à ces cartes et
il existe même un [tournoi de
cartes](https://www.gamerguides.com/final-fantasy-ix/guide/walkthrough/disc-3/back-to-treno)
(que vous pouvez perdre sans crainte).

Si ces cartes n'apportent pas de bonus additionnel, elles permettent
de satisfaire la _collectionnite aigüe_ de certains joueurs et, comme
beaucoup de systèmes de jeux _ad-hoc_ dans le JRPGs, les parties de
cartes permettent de _légèrement_ rompre la linéarité du jeu,
construisant un réseau de petites quêtes annexes se greffant à la
trame principale ou à d'autres quêtes et systèmes annexes.

En bref, si les règles du jeu avait été inférables... son intégration
aurait été, selon moi, une excellente idée (un peu à la manière du
**Triple Triad** de FF8), malheureusement, comme nous allons le
voir... ce n'est absolument pas le cas !

### La collecte des cartes

Les cartes faisant partie de la diégèse du jeu, il est normal qu'il
existe plusieurs moyens d'en collecter. Après avoir évoqué les
différentes méthodes pour collecter de nouvelles cartes, je tâcherai
de, subjectivement, définir l'approche la plus efficace :

- **Les recevoir de personnages**  
  C'est la première approche auquel nous sommes confrontés. En effet,
  dès le début de l'aventure, Bibi aura l'occasion de collecter des
  cartes et de se voir enseigner les bases du jeu (oui, juste les
  bases, soit absolument trop peu d'information pour _comprendre les
  règles_. Fichus PNJs, incapables de nous donner des informations
  exhaustives).

- **Les trouver**  
  Comme dans tout JRPG qui se respecte, les donjons et les villages
  regorgent de trésors, dans FF9, en plus des coffres, il est possible
  de trouver des objets cachés — les frôler fera apparaitre un
  phylactère habité d'un point d'exclamation. Parfois, vous
  découvrirez des cartes. A noter qu'elles peuvent aussi faire partie
  des trésors découvrables au moyen de
  [Chocographes](https://jegged.com/Games/Final-Fantasy-IX/Side-Quests/Chocographs.html).

- **En récompense de combats**  
  Il arrive parfois que certains adversaires _offrent en récompense_
  une ou plusieurs cartes. Très souvent, la carte reçue correspondra à
  l'un des monstres présent dans le combat — _logique_, pour une fois.

- **Les acheter**  
  Il est possible d'acheter, pour `100 gils` des cartes dans la ville
  de [Treno](https://finalfantasy.fandom.com/wiki/Treno). Le prix
  étant très bas, les cartes disponibles à la vente seront, _de facto_
  relativement peu intéressantes.

- **Les gagner**  
  Nous le détaillerons plus tard en expliquant les règles mais gagner
  des parties de cartes permet de prendre une ou cinq cartes, en cas
  de victoire, à son adversaire. Comme certains PNJs sont des joueurs
  expérimentés — notamment au tournois de cartes de Treno — il est
  possible de collecter des cartes puissantes dès que l'on atteint un
  certain niveau de progression dans le jeu.

Naïvement, en observant cette liste, on pourrait rapidement arriver à
la conclusion que la manière la plus efficace de gagner un maximum de
cartes est de défier le plus d'adversaires possible. Cependant, et
c'est la raison d'être de cet article, le jeu étant très compliqué,
j'ai l'intime conviction que pour se construire un _deck_ efficace, il
vaut mieux **combattre le plus de monstres possibles**. En effet, les
monstres, lors des rencontres aléatoires, ont une probabilité de
laisser une carte en récompense. En plus de la carte, combattre des
monstres fait gagner de l'expérience et d'autres objets, donnant donc,
à la collecte de carte, une utilité concrète à la progression dans
l'aventure.  Cependant, défier des adversaires est aussi nécessaire,
comme nous le verrons dans l'exposition du détail des règles.
