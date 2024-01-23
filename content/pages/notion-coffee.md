---
title: Indexation de café avec Notion
creation_date: 2023-01-15
description:
  Exemple d'utilisation de Notion pour l'indexation de café
toc: true
tags:
  - lowcode
  - nocode
  - notion
  - café
  - base de données
breadcrumb:
  - name: Sur le café
    href: /coffee.html
  - name: Technologies
    href: /coffee.html#index-technologies
synopsis:
  Cet article est une réinterprétation d'un 
  [article](https://github.com/xvw/planet/blob/master/content/posts/notion-cafe.org)
  que j'avais rédigé en 2021, sur mon [ancien site](https://github.com/xvw/planet).
  J'ai essayé d'aller à l'essentiel et il présente, dans les grandes lignes, l'ensemble
  des pages [Notion](https://www.notion.so/about) mises en place pour me permettre
  d'indexer ma consommation de café et tenter de construire une intuition sur la
  compréhension des mes goûts. De manière générale, je pense que se construire une
  _base de connaissances_ est une bonne pratique quand on tente de découvrir une
  discipline. Étant loin d'être un expert en café et avec Notion, il est probable qu'une
  grande partie de ce que je décris dans cet article semble naïf ! Pour résumer, cet
  article présentera la manière dont j'ai mis en place une infrastructure pour indexer
  les cafés que je goûte, en vue de me fournir des métriques précises m'aidant à
  caractériser mes préférences, au moyen de l'outil Notion, tout en présentant quelques
  techniques et ruses apprises lors de la mise en place de ce système.
---

Alors que généralement, tant que l'on est pas _tombé_ dans le monde très rigolo
du **café de spécialité**, on se contente d'accepter une tasse de café, sans se
soucier _réellement_ des caractéristiques du café que l'on boira. Pourtant, il
existe **beaucoup** de critères qui influeront sur la tasse : la provenance des
grains, la variété du café, sa méthode de sechage, le profil de torréfaction, la
méthode d'extraction et bien d'autres. Un peu à la manière du vin, _comprendre
ce que l'on goûte_ est primordial pour appréhender le café de spécialité et pour
développer l'intérêt que l'on porte au produit, comprendre comment choisir son
café et comment le préparer correctement — en réduisant, potentiellement, le
nombre d'étapes nécéssaires pour approcher, en fonction de ces caractéristiques,
la tasse idéale. 

Dans cet article, je vais présenter **mon utilisation de Notion** pour la
construction d'un suivi de mes préparations (une base de données), me permettant
de _comprendre ma manière d'apprécier le café_ et d'être capable de définir, en
fonction des méthodes d'extractions, une recette adaptée pour tenter d'extraire
des tasses correspondant à _mes préférences_ et, potentiellement, de m'adapter
aux attentes de mes invités !

Par contre, cet article n'est ni un guide d'utilisation de Notion
_génériquement_, ni une introduction au café de spécialité, c'est un compte
rendu de modélisation sur la manière dont j'ai décidé d'organiser mon indexation
de café pour collecter des métriques sur mes préférences.

## À propos de Notion

Il est très difficile de résumer Notion autrement qu'en utilisant le néologisme
[_idéateur_](https://fr.wikipedia.org/wiki/Id%C3%A9ateur_(informatique)). En
général, quand j'essaie de le décrire à mon entourage, je le présente comme un
outil de prise de notes, _boosté aux stéroïdes_, permettant de manipuler, entre
autres, des _spreadsheets_ comme valeurs de première ordre. Depuis plusieurs
années, ce genre d'outils de prises de notes évolués est devenu très populaire
et leur versatilité les fait s'inscrire dans une mouvance que l'on appelle
[_NoCode/LowCode_](https://fr.wikipedia.org/wiki/D%C3%A9veloppement_No_code). On
en trouve beaucoup et, à ma connaissance, les plus populaires (spécifiquement en
extension d'outils de prise de notes) sont [Obsidian](https://obsidian.md/),
[AnyType](https://anytype.io/), [Evernote](https://evernote.com/fr-fr) et
Notion. Je n'ai pas d'opinions très arrêtées sur quel outil privilégier — même
si, pour des raisons idéologiques, je devrais passer un peu plus de temps à
jouer avec AnyType, qui a le très bon goût d'être **libre** et _local-first_. De
plus, une grande partie de ce que je vais présenter dans cet article pourrait
parfaitement fonctionner avec un logiciel _plus spécifique_, comme
[Airtable](https://www.airtable.com/) par exemple ou encore avec une base de
données relationnelle classique, mais quand j'ai commencé à indexer ma
consommation de café, je voulais un outil générique pour assurer
**l'intégralité** de ma prise de notes numériques.

En complément, à l'époque où j'ai rédigé la première version de cet article,
[Shubham Sharma](https://www.shubham-sharma.fr/) parlait beaucoup de Notion sur
sa [chaine Youtube](https://www.youtube.com/channel/UCLKx4-_XO5sR0AO0j8ye7zQ) et
il proposait une [Formation gratuite](https://www.notionfacile.fr/) pour prendre
l'outil en main ! De plus, à cette époque, je travaillais chez [Memo
Bank](https://memo.bank/) et, l'un de mes collègues, [Jonathan
Lefèvre](https://jonathanlefevre.com/), avait, lui aussi, beaucoup de retours
sur Notion et, à la relecture de la première version, m'avait fait l'honneur de
me dire (approximativement dans ces termes) :

> C'est toujours amusant et intéressant de voir un programmeur utiliser Notion,
> et, toi aussi, tu as trouvé un usage bien particulier et un peu flippant pour
> les non-initiés.

En bref, je ne sais pas si Notion est l'outil le plus adapté, et je ne sais pas
si je m'en suis servi de manière pertinente (_n'ayant pas eu pour objectif
d'augmenter drastiquement ma productivité_) mais après 2 ans d'utilisations, je
suis assez satisfait de l'amélioration de la **compréhension des mes goûts** en
matière de café !


### Sur le NoCode/LowCode

J'adore réinventer la roue, il peut donc sembler étrange que je décide
d'utiliser un logiciel propriétaire alors que je pourrais simplement
_réimplémenter_ toute une suite de logiciels dédiée au café ! D'autant plus que,
sur un espace de conversation partagé que je fréquentais beaucoup en 2020, le
_NoCode_ (dont l'appellation _LowCode_ était encore assez confidentielle) avait
très mauvaise réputation.

Pour être honnête, je suis très favorable au _NoCode/LowCode_ dans le sens où
ils me permettent de me focaliser sur **la problématique que je veux adresser**
et même si je suis convaincu que pour utiliser _très efficacement_ des outils de
ce genre, il vaut mieux être familier avec la programmation (qui requiert une
certaine forme de logique et des qualités de modèlisation), mon seul _réel_
reproche à cette collection d'outils porte sur leur nom. En effet, on programme
toujours et l'utilisation d'un outil _dit de "NoCode_, ne dispense pas d'un
architecte capable de construire une solution pertinente.

De mon point de vue, utiliser des Notion's et consorts me permet d'avoir de la
génération de formulaires, _gratuitement_, et donc de pouvoir me focaliser sur
le **traitement de la donnée** plutôt que sur la saisie, ce qui, dans beaucoup
de cas, est un gain de temps monumental.

Par contre, comme évoqué précédemment, il est probable que 2024 soit l'année où
je me pencherai sérieusement sur [AnyType](https://anytype.io) pour privilégier
un **logiciel libre** et **_local-first**, parce que le fait de ne pas devoir
écrire chaque ligne de code, caractère par caractère, me semble beaucoup moins
problématique, _idéologiquement parlant_ que de devoir me reposer sur des
technologies propriétaires, pour lesquelles je n'ai pas de gouvernance de ma
propre données.

### Organisation de l'espace de travail

Notion permet de structurer des documents hiérarchisés — des documents peuvent
en contenir d'autres. Chacun de ces documents sont une collection de blocs dont
le comportement varie en fonction du besoin. On retrouve des blocs de titre, des
paragraphe, des images, mais ils peuvent aussi référencer d'autres documents,
des fragments de documents ou encore des _vues_ paramétrées par des sources de
données. La versatilité des blocs permet d'organiser proprement son espace de
travail.

Comme un espace Notion ne sert pas qu'à un seul usage, j'ai organisé l'ensemble
de mes pages dédiées à l'indexation du café dans un document, appellé sobrement
`Coffee` (auquel j'ai ajouté l'_émoji_ `:coffee:` parce que je suis moderne et
que j'utilise des _émojis_). Ce premier document fait office d'ombrelle, on peut
le voir comme un _espace nom_ ou encore un _répertoire_. Dans ce même document,
j'ajoute un nouveau document `database` (associé à l'icone `:disquette`) dans
lequel je placerai toutes mes tables. Ensuite, je pourrai construire des vues
(qui consomment ces tables), elles aussi, dans le document `Coffee` pour
adresser des services spécifiques. Le fait de compartimenter **la donnée brute**
est probablement une coquetterie de développeur mais j'en suis satisfait.

#### Sur les bases de données

les [bases de données Notion](https://www.notion.so/help/intro-to-databases)
sont probablement une des fonctionnalités les plus utiles (de mon point de vue).
Elles permettent de décire des tables, dans le sens qu'on leur donne dans le
monde des bases de données relationnelles avec la possibilité d'embarquer des
champs qui sont des formules dont la valeur est définie en dépendant d'autres
champs. C'est en partie pour ça que je considère que les bases de données Notion
sont à l'intersection entre une table et une feuille de calcul.

Comme il y a vraiment beaucoup de fonctionnalités attachées aux base de données,
je tâcherai d'expliquer, au fil de l'article, les différentes fonctions
utilisées (quand il y aura des ambiguïtés potentielles).

## Premières caractéristiques

Maintenant que nous avons _sommairement_ survolé quelques caractéristiques liées
à Notion, nous pouvons nous intéresser au café, à _proprement parlé_. Notre
exercice sera d'essayer de comprendre le cycle de vie du café, **de l'arbre à la
tasse** pour extraire des éléments qui **serviront à la modèlisation de notre
système**. Au travers de cette modèlisation, on pourra décrire une collection de
tables qui serviront, ensuite, à décrire des vues pour répondre à des questions
factuelles. C'est, de mon point de vue, la partie la plus amusante et j'ai
l'intime conviction que, peu importe que l'on utilise du _NoCode/LowCode_ ou que
l'on programme entièrement l'application _from-scratch_, la démarche est
identique (et fondamentale).

### De l'arbre à la tasse

Pour dériver des modèles pertinents à notre indexation, il est important de
comprendre le cycle de vie du café. En effet, en observant les différentes
étapes par lesquelles on passe depuis l'arbre, jusqu'au café en grain qui
servira à une préparation, on peut isoler une collection de critères qui
influeront sur la _tasse_. N'étant pas (encore, je l'espère) un expert, il est
probable que ma compréhension du cycle est naïve et maladroite, je suis donc
ouvert à toute proposition d'amélioration !

Dans les grandes lignes, le commerce du café implique plusieurs parties :
- les producteurs, qui possèdent des fermes de caféiers et qui assurent le
  séchage des grains ;
- les exportateurs, qui rappatrient les grains vers des torréfacteurs ;
- les torréfacteurs, qui torréfient les grains ;
- les commercants, qui fournissent les revendeurs et les _coffee-shops_ ;
- les préparateurs (_baristas_ ou _consommateur final_).

Il est évident que ces différentes parties ne forment pas toujours des groupes
absolument hétérogènes. Il est très courant qu'un torréfacteur soit aussi
commercant (voire _barista_). Mais cette _découpe_ des différentes parties
impliquées nous permet de décrire un schéma sommaire du trajet du café, _depuis
l'arbre, jusqu'à la tasse_ :

![](/images/coffee-to-cup.svg){ class=centered-fig }

1. **La récolte** :  
   Cette étape permet de mettre en lumière plusieurs critères. Premièrement, la
   **région géographique** où le café à été récolté, et par extension, **le
   producteur** (ou la ferme) et l'altitude du plan, le **type d'arbre**
   (naïvement, **Robusta** contre **Arabica**, même si, généralement, dans le
   café de spécialité, on ne trouve presque qu'exclusivement de l'arabica), la
   **variété du café** et des informations relatives aux dates de récoltes.
   
2. **Le séchage** :  
   En tant que consommateur, on est habitué à me voir que du café en grain
   (voire moulu), mais **le grain de café est le coeur d'une cerise**. Il existe
   plusieurs techniques de séchages, _naturel_, _lavé_ ou encore _honey_ (qui
   possède plusieurs variations spécifiques) qui **influent énormement** sur le
   goût en tasse. Ce **processus** est une critère indispensable. J'ai
   l'intention d'écrire un article entièrement dédié à l'explication des
   différents processus de séchage.  
   En complément du séchage, certains producteurs ajoutent une étape de
   **fermentation complémentaire** (pouvant être, par exemple, _anaérobique_ ou
   encore _carbonique_) qui, elle aussi, influe grandement sur les arômes du
   café. Au vue des conditions écologique, le café est devenu un produit de luxe dont
   l'importation peut se révéler coûteuse ce qui amène certains producteurs à
   expérimenter des techniques **d'altérations aromatiques** au moment de la
   fermentation influant, elles aussi, grandement sur les arômes du café.
   
3. **La torréfaction** :  
   La torréfaction, grossièrement, la _cuisson_ des grains verts, pour en
   révéler les arômes, joue en rôle essentiel (logique) sur la tasse finale. En
   France, c'est généralement le torréfacteur qui choisi les producteurs et les
   fermes avec lesquels il veut travailler ce qui nous permet d'extraire de
   nouveaux critères : le **torréfacteur**, le **niveau de torréfaction**, le
   **profil aromatique** du café et la **date de torréfaction**.  
   
4. **La préparation** :  
   La manière de préparer un café influe aussi très fort sur la tasse finale, et
   est conditionné par plusieurs critères : la **recette utilisée**, la
   **quantité de café**, la **quantité d'eau**, la **taille de la mouture**, la
   **température de l'eau**, la **fraicheur du café**, le **temps
   d'extraction**, en bref, toutes les variables de la recette. Ce qui nous
   permet de spéculer sur le fait que l'appréciation générale d'un café se fait
   **par recette pour un _batch de torréfaction_ précis**.
   
C'est une vision assez large (et pour le moment, floue) des différents critères
que l'on va utiliser pour décrire notre modélisation. Rassurez-vous, quand nous
construirons explicitement les tables et les vues, je tâcherai de revenir sur
les différents critères utilisés.

Les lecteurs plus attentifs remarqueront que je n'ai absolument pas parlé du
processus d'exportation. Pour être très honnête, je n'ai aucune idée de comment
ça se passe et je ne suis pas convaincu qu'il soit possible (de manière
consistante), d'être aux faits de critères liés à l'exportation, c'est pour
cette raison que je me permet discrètement de ne pas m'en soucier. En
complément, la **fraicheur** des grains utilisés lors d'une préparation influent
aussi sur la tasse, les conditions de stockages — type de récipient, exposition
à la lumière etc. — devraient être un critère d'indexation. Cependant, comme
j'utilise une méthode de conditionnement assez consistante (et que j'applique à
tout mes cafés), je n'ai pas trouvé qu'il était pertinent de la mettre en
lumière dans mon indexation !


### Note sur la réplicabilité

Dans l'esquisse des critères que nous avons sélectionné, la recette joue un rôle
très important. Pour que l'indexation soit pertinente, il faut donc être capable
de reproduire précisement une recette et en collecter un maximum de métriques.
De plus, imaginez que vous soyez en train de savourer la plus délicieuse tasse
que vous ayez jamais produites, il serait terrible ne pas être capable de la
reproduire pour des raisons d'imprécisions de mesure ! Pour cela, j'utilise une
collection d'outils précis :

- un moulin à cliques, le [Commandante C40](https://www.comandantegrinder.com/).
  Un moulin à clique permet de contrôler précisemment la _granulométrie_ de la
  mouture et le Commandante est un moulin très polyvalent dont les réglages au
  cliques forment presque un _standard_ de réglage. Le moulin est vraiment un
  outil nécéssaire car le café perd une grande partie de ses arômes 15 minutes
  après mouture ;
  
- une balance, la [Smart Scale 2 de
  Brewista](https://brewista.co/products/smart-scale-2), précise et doté d'un
  chronomètre, que j'utilise pour peser les quantité de café et d'eau. (Ce qui
  me permet d'éviter les mesures volumétriques, souvent assez peu précises et
  peu réplicables) ;
  
- une bouilloire avec une gestion de la température précises (me permettant de
  changer degré par degré) et idéalement doté d'un col de cygne (pour le café
  filtre), j'utilise la [Artisan Electric Gooseneck Kettle
  ](https://brewista.co/products/artisan-electric-gooseneck-kettle), elle aussi,
  de chez [Brewista](https://brewista.co/)

Le dernier point peut sembler anecdotique, mais dans une tasse de café, ce n'est
pas le café qui est le plus présent, mais **l'eau**. Ne disposant pas de
purificateur d'eau, j'ai opté pour une carafe [Brita](https://www.brita.fr/), me
permettant de diminuer au maximum le [Potentiel
Hydrogène](https://en.wikipedia.org/wiki/PH) de mon eau. A tout cela s'ajoute
une collection de machines à café (un peu excessives) cependant, l'indexation
peut ne commencer qu'avec une seule machine ! Et maintenant que ces
clarifications sur la terminologies ont été évoquées, nous pouvons passer à la
modélisation concrète de notre système dans Notion.

## Modélisation des tables

Même si, normalement, on commence pas construire des _user-stories_ pour dériver
un modèle pertinent, comme un espace Notion est moins difficile à faire évoluer
qu'une base de données utilisée en production et que l'établissement un peu naïf
du cycle de vie du café nous donne des intuitions sur quels sont les variables
que l'on voudrait tracker, je me permet de construire des tables qui me
serviront à décrire la données que je voudrai exploiter dans des vues
spécifiques. Nous allons donc pouvoir remplir notre document `database` avec des
tables. L'ensemble de ces tables est organisée par thème, mais je pense que pour
les besoins de cet article, il n'est pas nécéssaire de documenter cette
organisation (qui est un peu à la préférence de chacun).

### Décrire les fermes/producteurs et les torréfacteurs

Même si je me suis intéressé tardivement aux fermes et aux producteurs, j'ai, à
force de goûter de plus en plus de café, appris à _détecter_ des fermes dont
j'apprécie toujours les récoltes (par exemple, l'extraordinaire [Finca
Hartmann](https://www.panamavarietals.com/copy-of-cafe-gallardo), de Panama).
Donc avant de décrire une ferme sommairement, il est important de pouvoir la
positionner géographiquement.

#### Un premier ensemble de tables: les zones géographiques

Attaquons-nous à notre première modélisation, où nous seront confronté à la
construction de **relation entre des tables** ! Ma modèlisation est assez simple, je
distingue 4 tables : Le continent, le pays, la région et la ville. Ces 4 niveaux
me permettent d'avoir une granularité suffisamment fine (même si la terminologie
n'est pas uniforme pour tous les pays. Par exemple, au Panama, on parlera de
[_corregimiento_](https://fr.wikipedia.org/wiki/Corregimiento) plutôt que de
région).

Je n'ai pas besoin d'information autres que le nom (qui fait office d'index) et
d'un treillis de relation suivant cet ordre : `cities -> regions -> countries ->
continents`. Voici une vue schématique du modèle des zones géographiques (que
j'ai placé dans un document nommé `Location`) :

![](/images/coffee-geopoint.svg){ class=centered-fig }

Vous remarquerez que j'ai ajouté des relations _en pointillés_ (avec le label
`rollup`). Dans Notion, on trouve deux formes de relations : 

- les relations _standards_ qui référencent directement une autre table ;
- les _rollups_, qui décrivent **champ de relation**. C'est très similaire des
  [_Delegates_](https://en.wikipedia.org/wiki/Delegation_(object-oriented_programming))
  en programmation orientée objets. En d'autres termes, **un Rollup est un champ
  virtuel calculé depuis une relation**.
  
Les _Rollups_ permettent d'ajouter du contexte à ma table, et **ne doivent pas
être remplis manuellement**, en effet, dès que j'ai nommé, par exemple, une
région, et que je lui ai attribué un pays, le champs continents sera
automatiquement calculé. Il existe cependant une petite restrictions aux
_Rollups_, **il est impossible de décrire un Rollup qui prend un autre Rollup
comme source**. En effet, les Rollups prennent **toujours** des relations en
source. Dans le schéma de la modélisation, on peut voir que je recense, par
exemple, dans `cities`, le pays et le continent dans lequel il se trouve, or, si
l'on s'en tient à mon affirmation sur les Rollups de Rollups, ça devrait être
impossible. Il existe une astuce !

##### La technique des champs miroirs

Dans notre exemple, on dispose des tables `continents`, `countries`, `regions`
et `cities`. Pour des raisons de lisibilité, je voudrais : 
- les entrées de `countries` listent leur `continent` associé ;
- les entrées de `regions` listent leurs `country` et transitiviement leur
  `continent` associés ;
- les entrées de `cities` listent leur `region`, transitivement leur `country`
  et transitiviement leur `continent`.
  
Nous savons que : 
- les **relations** permettent de référencer un directement une entrée ;
- les **rollups** permettent de cibler un champ d'une référence
  (transitivement).
  
Comme un **Rollup** utilise toujours une relation comme source, il n'est pas
possible, dans le cas de `cities` de remonter le continent — c'est d'ailleurs la
seule table pour laquelle le problème se pose car `country` ne peut n'utiliser
qu'une seule relation pour exprimer son continent, `region` utilise une relation
pour exprimer son `country` et un Rollup pour faire remonter le continent et
dans le cas de `cities`, une relation exprimera la `region`, un Rollup remontera
le `country`, mais on ne pourra pas faire remonter le continent.

Pour permettre à `cities` d'accéder au continent de `regions`, il suffit
d'utiliser un **champ miroir**, que j'ai appelé `_mirror_continent` qui sera une
formule et qui sera égal à `prop("Continent")`. Ça a pour effet de créer un
second champ qui est strictement équivalent au champ `Continent`, sauf que ce
champ n'est pas le résultat d'un Rollup (et ce, même si c'est le cas de la
propriété `Continent`). Il devient donc possible de référencer ce champs depuis
`cities` en créant un autre Rollup pointant la région et en référençant notre
nouveau champ `_mirror_continent` qui lui, n'est pas le résultat du calcul d'un
Rollup, et rendre explicite le continent dont fait partie une ville.

Pour les férus de **l'encapsulation**, Notion permet facilement de cacher des
champs de la vue générale, permettant de garder notre vue de `regions` facile à
lire. Dans la suite de l'article, je ne distinguerai pas spécialement
l'utilisation d'un champ miroir ou d'un Rollup, le premier n'étant qu'un détail
technique nécéssaire pour combler une limite inhérente au Rollups.

#### Décrire une ferme

Maintenant que nous pouvons _localiser_ une ferme, nous pouvons les décrire.
L'exercice n'est pas très compliqué. En effet, je me contente de recenser les
champs me permettant de construire un _annuaire_ de fermes :

![](/images/coffee-farm.svg){ class=centered-fig }

J'ai besoin d'un **nom** et d'un **site** (ou d'une page sociale) et de
référencer la **ville** dans laquelle se trouve la ferme. Et de manière générale,
je trouve ça intéressant d'avoir une rapidement accès au pays, d'où la présence
d'un Rollup (qui nécéssite d'ajouter un **champ miroir** sur `country` dans
`cities`). Maintenant, nous pouvons décrire les torréfacteurs.

#### Décrire les torréfacteurs

La description des torréfacteurs n'est pas foncièrement différentes de celle des
fermes. On y retrouvera des champs en communs — **Nom**, **Ville**, un Rollup
depuis la ville vers le **Pays** et une **Url**. J'ai ajouté une adresse précise
(essentiellement pour référencer une _rue_), car il est plus courant que je
veuille me rendre dans la boutique d'un torréfacteur plutôt que dans la ferme du
producteur et deux champs booléens pour exprimer **si j'ai déjà testé de leur
café** et si le **torréfacteur est encore actif**.

![](/images/coffee-roaster.svg){ class=centered-fig }

Le fait de conserver les torréfacteurs inactifs me permet d'avoir une indexation
cohérente. Le fait d'avoir un marqueur décrivant si un café dans du torréfacteur
à déjà été goûté/testé permet de créer un premier outil. Cependant, quand notre
modèle sera plus riche, il sera possible d'automatiser le calcul de cette
cellule.

##### Un premier outil : torréfacteurs à essayer

Une des forces de Notion et qu'il est possible **de construire des prismes de
données**, soit des **vues qui appliquent des filtres et des méthodes de tris**
sur des bases de données existantes. On peut donc facilement construire une vue
qui sert à lister l'ensemble des torréfacteurs encodés que je n'ai pas encore
essayé. 

Par exemple, en prenant cette table `roasters` (avec un tout petit ensemble de
données), on voudrait qu'une vue `torréfacteurs à expérimenter` n'affiche que
_L'Arbre à Café_.


![](/images/coffee-notion-roasters.png){ class=aered-centered-fig }


Pour cela, il suffit de construire une vue (avec le _layout_ **Liste**) auquel
on ajoute un [**filtre
avancé**](https://www.notion.so/help/guides/using-advanced-database-filters)
pour lequel on dit que l'on veut que le champ `Tested` ne soit pas activé et le
champ `Active` est activé. La construction de filtres avancés est, de mon point
de vue, assez intuitive :

![](/images/coffee-notion-roaster-filter.png){ class=aered-centered-fig }

Ce qui, logiquement, produit une vue ne prenant que les torréfacteurs **actifs**
et **non-testés**.

![](/images/coffee-notion-roasters-view.png){ class=aered-centered-fig }

C'est en partie pour ce genre de _possibilités_ que, à l'époque, j'avais décidé
d'utiliser Notion. Il existe plusieurs gabarits de vues (par exemple, celle qui
permet d'afficher les données sous forme de tables _Kanban_) et couplés et tris
et aux filtres, il est possible de construire des vues spécifiques (et
embarquables dans d'autres documents) pour répondre à des questions très
précies. Dans la suite de l'article, nous illustrerons d'autres utilisations de
ces vues.


### Modèlisation du café, des variétés et des grains

On peut passer à la partie, de mon point de vue, la plus rigolote, **on va
décrire le café** ! Même si l'existe **plus de 130 espèces de
[caféiers](https://en.wikipedia.org/wiki/Coffea)**, on en distingue généralement
deux principales, utilisées pour faire du café :
[l'Arabica](https://en.wikipedia.org/wiki/Coffea_arabica) et le
[Canephora](https://en.wikipedia.org/wiki/Coffea_canephora) — que l'on appelle
généralement **Robusta**. Dans le café de spécialité, on trouvera presque
exclusivement de _L'Arabica_, qui est un arbre plus dur à entretenir mais qui
produit du café de meilleur qualité. Ensuite il existe une très grande
collection de variétés de café dérivés du Robusta et de l'Arabica, que l'on
appelle des _Cultivars_ (ou variétés cultivées). Dans les rubriques qui suivent,
nous tâcherons de modéliser les tables décrivant les variétés de cafés pour
ensuite décrire les grains torréfiés.

#### Décrire les variétés de café

Une première question de _design_ se pose assez directement. Bien que l'on sait
que généralement, on aura une distinction entre Arabica et Robusta, doit-on
dédier une table pour décrire les caféiers ou peut-on juste considérer que c'est
un champ compacte — par exemple `is_arabica`, étant un booléen et dont la valeur
`false` impliquerait que le caféier serait Robusta. Je n'ai pas d'opinion forte
sur la meilleure approche donc je vais dédier une table spécifique, ce qui me
permettra d'utiliser la page adossée à une entrée — dans Notion, il est possible
d'ajouter du contenu additionnel à chaque entrée dans une table — pour collecter
des notes relatives aux caféiers. On peut donc décrire les variétés de cette
manière :

![](/images/coffee-cultivar.svg){ class=centered-fig }

Les espèces (`species`) ne sont pas très originales, je stocke juste le **nom
bref** et le **nom complet**. Ensuite, pour les _cultivars_, je stocke un
**nom**, un **lien** (qui pointe généralement vers l'excellent index [World
Coffee Research](https://worldcoffeeresearch.org/)), une liste de **noms
alternatifs** (par exemple, la variété _Villa Sarchi_ est aussi appelée
_Villalobos_), une **espèce** (_Arabica_ ou _Robusta_) et des potentiels
**cultivars parents**.

La référence de cultivars parents permet de capturer des mutations génétiques
artificielle ou naturelle. Par exemple, le [Bourbon
Rose](https://perfectdailygrind.com/2023/10/pink-bourbon-specialty-coffee/) est
une mutation naturelle du
[Bourbon](https://varieties.worldcoffeeresearch.org/varieties/bourbon) (un des
cultivars les plus populaires) et le [Mundo
Novo](https://varieties.worldcoffeeresearch.org/varieties/mundo-novo) est une
mutation artificielle de
[Typica](https://varieties.worldcoffeeresearch.org/varieties/typica)
(probablement la variété la plus ancienne) et de
[Bourbon](https://varieties.worldcoffeeresearch.org/varieties/bourbon). Cette
précision peut passer pour de la coquetterie, cependant, je trouve qu'avoir une
idée approximative de la lignée de variétés permet d'avoir une meilleure
compréhension des caractéristiques de ces dernières.

Maintenant, nous avons toutes les tables permettant de décrire **les grains
torréfiés**.

#### Décrire les grains torréfiés

Nous avons tous les ingrédients nous permettant de décrire le grain que nous
allons utilisé pour faire une tasse. Ce sera donc naturellement une des tables
les plus touffue de notre système. Logiquement, nous retrouverons les
**producteurs** (fermes) et les **torréfacteurs**, les **régions** (on pourrait
imaginer que le producteur suffirait à décrire la région, mais je ne suis pas
sur que toutes les fermes soient parfaitement situé dans une seule région, et
certains grains peuvent être le fruit d'une collaboration entre deux fermes, où
l'un fournit les cerises et l'autres pratique la fermentation, d'où ma nécéssité
de dupliquer la région), on retrouvera la liste de **variétés** (quand un café
n'est composé que d'une seule variété, on parle d'origine unique, quand il est
composé de plusieurs variété, on parlera de _blend_) et d'autres champs que je
décrirai aprés vous avoir présenté la structure :

![](/images/coffee-bean.svg){ class=centered-fig }
