Avant Propos
==========

Performance ou performance ?
---------------------------------------------

En collectant un peu les avis de chacun sur les performances des sites
web, je me suis aperçu que le terme de performance en français recoupe
beaucoup de concepts. Chacun y voit quelque chose de différent, et
parfois même les gens parlent entre eux sans comprendre qu'ils parlent
de sujets entièrement différents.

Voici un peu ce que les gens entendent par « performance des sites web » :

-   bénéfices tirés du site, souvent financiers,
-   taux de conversion pour les ventes ou les envois formulaires,
-   nombre de visiteurs uniques, ou de pages vues,
-   ressources utilisées sur les serveurs web ou base de données,
-   temps de réaction des serveurs web ou des équipements réseau,
-   le temps d'exécution d'une page web PHP ou Java sur le serveur,
-   temps de chargement des pages web.

Alors précisons : ce livre ne s'occupe que du dernier item, le temps de
chargement des pages web par le navigateur sur le poste de l'internaute,
et uniquement de cela. Même si vous avez probablement déjà feuilleté le
livre ou regardé le sommaire, cette précision reste importante.
N'oubliez pas de la faire vous-même quand vous parlez de performance des
sites web à quelqu'un après m'avoir lu.

Vous le verrez, ce livre est même plus pointu que cela, puisque dans le
temps de chargement des pages web je ne m'occuperai ni d'architecture
système, ni de programmation Java ou PHP, ni de bases de données... mais
vous aurez l'occasion de découvrir que je vous propose bien mieux.

Ce que nous allons voir ensemble
-------------------------------------------------

Cet ouvrage est découpé en quatre sections et treize chapitres. Les deux
premiers sont des chapitres d'introduction, ils vous permettront de vous
familiariser avec la notion de performance et les concepts techniques
indispensables pour la suite de votre lecture :

1. Users really respond to speed
2. Premiers concepts

Les six chapitres suivants, qui composent le corps du livre, décriront 
tous les principes techniques, les recommandations de performance, 
la mise en œuvre, le pourquoi et le comment. Ils sont plus ou moins placés par 
ordre de priorité, aussi je vous conseille de les lire séquentiellement 
au moins une fois.

3. Travailler avec les caches HTTP
4. Moins de requêtes HTTP
5. Contenus plus petits
6. Parallélisations 
7. Réduire les espaces vides
8. Applicatif

Vient ensuite un chapitre plus conversationnel qui a pour but de
discuter des différentes approches et de gérer l'aspect non technique de
la mise en œuvre :

9. Optimiser  

Enfin, les derniers chapitres collectent toutes les références utiles.
Ils référencent les recommandations de performance, les termes et
concepts techniques, les outils de mesure ou de correction, et les sites
ou documentations externes. Ces chapitres vous serviront d'aide au cours
de votre lecture et d'index par la suite lors de la mise en œuvre :

10. Mesurer la performance
11. Définitions et concepts techniques
12. Outils utiles
13. Références externes

Ce dont vous aurez besoin
--------------------------------

Avant la lecture, préparez un poste de développement qui vous servira
pour vos tests et vos analyses. Sur ce poste, désactivez tous les
logiciels de vie privée ou les options agressives de surveillance réseau
de votre anti-virus, ainsi que tous les logiciels ou extensions
anti-publicités. Ces logiciels pourraient modifier et fausser toutes les
mesures. Ils sont aussi connus pour parfois modifier le trafic réseau en
profondeur et vous empêcheront de réaliser vos expériences.

Côté navigateurs, vous aurez besoin de Mozilla Firefox ou Chrome pour
plusieurs extensions. Créez un profil dédié à vos tests performance sous
Mozilla Firefox afin de ne pas être impacté par les différentes autres
extensions que vous avez. Pour cela, lancez Firefox avec l'option
« -profilemanager ».

-   Mozilla Firefox :
    [http://www.mozilla-europe.org/](http://www.mozilla-europe.org/) 
-   Gérer les profils Firefox :
    [http://support.mozilla.com/fr/kb/managing+profiles](http://support.mozilla.com/fr/kb/managing+profiles) 
-   Chrome :
    [http://www.google.com/chrome?hl=fr](http://www.google.com/chrome?hl=fr) 

Dans Mozilla Firefox, installez la toute dernière version de Firebug
ainsi que les extensions Yslow et Pagespeed. Pour Chrome, installez
l'extension Speed Tracer.

-   Firebug : [http://getfirebug.com/](http://getfirebug.com/) 
-   Yslow :
    [http://developer.yahoo.com/yslow/](http://developer.yahoo.com/yslow/) 
-   Pagespeed :
    [http://code.google.com/speed/page-speed/](http://code.google.com/speed/page-speed/) 
-   Speed Tracer :
    [http://code.google.com/intl/fr/webtoolkit/speedtracer/](http://code.google.com/intl/fr/webtoolkit/speedtracer/) 

Vous aurez aussi besoin, tôt ou tard, d'un proxy de débogage, qui vous
permet d'analyser le trafic réseau. Vous pouvez par exemple utiliser
Fidler ou Charles. Pour jouer avec le navigateur vous pouvez aussi
installer l'extension TamperData de Firefox.

-   Fiddler :
    [http://www.fiddler2.com/fiddler2/](http://www.fiddler2.com/fiddler2/) 
-   Charles :
    [http://www.charlesproxy.com/](http://www.charlesproxy.com/) 
-   TamperData :
    [https://addons.mozilla.org/fr/firefox/addon/966/](https://addons.mozilla.org/fr/firefox/addon/966/) 

Enfin, vous finirez très probablement par avoir un raccourci vers le
service en ligne webpagetest.org, alors autant le créer maintenant :

-   Webpagetest :
    [http://www.webpagetest.org/](http://www.webpagetest.org/) 

Les dernières versions de Microsoft Internet Explorer, Safari et Opera
ont aussi des outils pour tester et analyser la performance des pages
web. Il peut être intéressant de les installer aussi, afin de pouvoir
étudier des ralentissements spécifiques à l'un ou l'autre de ces
navigateurs.

Parti pris et organisation
-------------------------------

Enfin, j'ai dans ce livre trois partis pris très explicites :

-   ne laisser aucun internaute de côté, que ce soit à cause de son
    navigateur (même s'il est faiblement utilisé), de ses difficultés
    matérielles (faible bande passante, mauvaise connectivité, petit
    écran) ou de ses difficultés physiques (handicap divers) ;
-   faire de la qualité, donc éviter de proposer des solutions qui
    provoqueront des incompatibilités avec les normes et standards ou
    qui seront impossibles à maintenir ensuite ;
-   tout vous expliquer en détail, quitte à parfois plus me rapprocher
    de l'encyclopédie que du cahier de recettes à appliquer sans
    comprendre, parce que les choses changent très vite sur le web,
    qu'un simple cahier de recettes risquerait de devenir obsolète, et que
    j'adhère totalement au principe qu'il vaut mieux apprendre à pêcher
    que de donner du poisson.

Le but final restant tout de même de vous permettre de mettre en œuvre
rapidement et simplement ce que vous apprenez, je ponctue le livre de
recommandations claires mises en surbrillance. Si vous voulez aller
vite, il vous suffit de les suivre et de lire les détails uniquement
quand vous en avez besoin.

Compromis
---------------

Au fil de ce livre je vous proposerai des recommandations.
Généralement elles sont applicables sans avoir à dégrader l'expérience
utilisateur ou vos choix graphiques. Par contre, dans de rares cas, il
vous faudra peut-être faire des compromis entre la performance, la
richesse des pages, la qualité graphique, la complexité et le temps de
développement. 

Habituellement, et les graphistes vous y encourageront, tous choisissent
assez rapidement de sacrifier la performance en trouvant inacceptable de
« dégrader l'expérience utilisateur ». On privilégie ce qui est
visible : le graphisme et le contenu de la page.

Dites-vous bien cependant que la performance fait justement partie de
l'expérience utilisateur, et elle en est même un des critères majeurs. Faites
donc attention à ne pas vous focaliser uniquement sur l'évident visible
dans la page. Acceptez de faire des compromis avec vous-même et avec vos
interlocuteurs.

Si à un moment vous tranchez en faveur d'un des critères (performance,
graphisme, contenu, temps de développement, complexité) de manière
radicale sans avoir accepté de compromis qui fasse faire un pas sur
chaque domaine, c'est probablement une erreur.

Si les compromis sont difficiles ce n'est pas qu'ils sont complexes à
trouver ou à réaliser, c'est qu'il est difficile de se convaincre qu'il
faut abandonner notre position intégriste du « je ne lâche rien là-dessus ».
Ce qui est délicat, c'est de se convaincre soi-même (et les
autres) de faire un compromis.

Pour votre bien, et pour celui de vos visiteurs, acceptez les compromis,
c'est indispensable (et oui, cela veut aussi dire parfois ne pas
appliquer toutes mes recommandations mais les adapter, tant que ce n'est
pas « à chaque fois » et que vous faites vous aussi un pas dans ma
direction).

78 % des statistiques sont fausses (les miennes aussi, dont celle-ci)
---------------------------------------------------------------------------------

Les statistiques et valeurs ne sont significatives que dans le contexte
dans lequel elles ont été créées : version du navigateur, latence de la
connexion, nombre de files de téléchargement simultanées, date et heure
de mesure, etc. Je ne prétends donc pas avoir une représentation
objective des sites testés dans les différents tableaux.

Pire, le logiciel de mesure utilisé peut avoir un impact sur la mesure
elle-même. Chacun étant imparfait d'une façon différente, le résultat
peut varier fortement. Il est donc parfois vain de comparer des chiffres
obtenus avec deux logiciels différents. Pour cette raison, deux
paragraphes de ce livre peuvent donner des résultats différents pour un même
site, sans forcément qu'il y ait contradiction.

Les statistiques réalisées permettent d’établir des comparaisons entre
les différents sites dans les mêmes conditions, ou de vérifier les gains
sur un même site avec le même logiciel avant et après les actions
correctrices. Il ne faut parfois pas leur donner plus de poids : ce ne
sont pas les chiffres objectifs mais des mesures qui permettent de
donner des références et des guides, rien de plus.

