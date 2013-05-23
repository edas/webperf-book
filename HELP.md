* Le livre : https://github.com/edas/webperf-book/
* Les tickets en cours : https://github.com/edas/webperf-book/issues 
* Quelques liens à pour fouiller : https://groups.diigo.com/group/web-performance 
* La liste de diffusion webperf française : https://groups.google.com/group/performance-web?hl=fr

Participer
==========

(re)Lire
--------

1. Se rendre sur https://github.com/edas/webperf-book/
2. Cliquer sur « content » dans le cadre principal
3. Choisir un des chapitres
4. La vue « raw » peut être moins trompeuse parfois

Faire une proposition, remonter une anomalie, …
-----------------------------------------------

Rendez-vous dans la rubrique « issues ». Vérifiez que ce que vous souhaitez remonter ne l’est pas déjà, et cliquez sur le bouton vers « new issue ». 

En marge de la description de votre ticket, pensez à cliquer sur tous les labels à gauches qui vous semblent s’appliquer à votre cas. Vous en aurez probablement au moins un jaune et un d’une autre couleur.

Réaliser une modification
-------------------------

N’hésitez jamais à modifier, rien n’est sacré, faites ce qui vous semble pertinent et utile. Si ça ne va pas, ça sera retouché par quelqu'un d'autre.

### Solution rapide et simple

À partir d’un chapitre en lecture, cliquez sur « edit » en haut à droite, modifiez, décrivez le changement effectué dans le formulaire en bas de façon à ce qu’il puisse être compris hors contexte, et validez votre envoi. Vous devez être authentifié sur github pour cela.

### Solution complète (via GIT)

1. Faire un fork sur votre espace github
2. Faire une branche par groupe d’ajout/modification
3. Modifier et envoyer vos modifications sur la branche via git
4. Envoyer une pull-request
5. Lire les retours s’il y en a
6. Réaliser les corrections et améliorations, les envoyer
7. Retour à l’étape 5

Tant que la pull-request n’est pas acceptée, tout ce que vous ajouterez à la branche viendra automatiquement s’ajouter à la même pull-request (ce qui permet d’améliorer, corriger, compléter). Donc : Une branche par pull-request.

Contenu : La forme
==================

Format
------

Les fichiers sont des fichiers texte, codage UTF-8, avec la syntaxe Markdown et les extensions Pandoc. Github offre un apperçu avec sa propre extension de Markdown, qui ne comprend pas toutes les subtilités de Pandoc. Entre autres : les listes recommencent toujours à partir de 1, les tableaux ne sont pas compris et les images peuvent ne pas s’afficher et générer un lien cassé.

- Détails : http://johnmacfarlane.net/pandoc/README.html#pandocs-markdown 

Structure
---------

Les chapitres sont dans le répertoire « content », les images dans « content/img ». Tous les fichiers commencent par « chapXX- » où XX est le numéro du chapitre concerné. 
Les outils sont dans « tools », n’hésitez pas à en ajouter.

Images
------

Pensez à réaliser des images avec la meilleure qualité possible, et en très grand format. Elles seront recoupées plus tard lors de la réalisation du fichier final mais cela permet d’envisager une publication papier (qui a besoin de haute qualité).

En toutes occasions, préférez les formats vectoriels si vous le pouvez (par exemple pour les graphiques). Dans le cas contraire, la plupart des images (captures d’écran, graphiques, schéma, et tout ce qui contient du texte à lire) devraient utiliser le format PNG.

Contenu : Le fond
=================

Français - anglais
------------------

En toute occasion, préférez le terme français quand il existe. S’il vous semble peu usité, vous pouvez mettre la traduction anglaise entre parenthèses lors de la première occurrence.

Utiliser le français encourage à s’impliquer et comprendre les concepts sous-jacents, par rapport à des utilisations un peu « formule magique » de termes anglais.

Ton, approche personnelle
-------------------------

Le ton de la discussion, non formelle mais avec vouvoiement est préféré. J’ai anciennement beaucoup utilisé le « je » étant donné que le projet a démarré comme un projet personnel. Vous pouvez rendre plus neutres les tournures ou utiliser le « nous ».

Sources
-------

Précisez toujours la source des affirmations, particulièrement les affirmations chiffrées. Signalez tous les liens qui vous semblent manquer.
