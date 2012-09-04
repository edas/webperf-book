Travailler avec les caches HTTP
===============================

Ce premier chapitre technique aborde les caches HTTP. Notre objectif va
être de réduire, presque à zéro, le temps de chargement des composants
d'une page web. En fait nous allons faire en sorte que le navigateur
n'ait presque rien à télécharger sur le réseau. Comme chacun peut
l'imaginer le gain pour le navigateur, et donc pour le visiteur, est
impressionnant.

Le principe du cache
--------------------

Dans une session de navigation classique, le visiteur repasse souvent
sur la même page, ou du moins sur des pages similaires d’un même site.
Il demande plusieurs fois l’affichage d’une même ressource, d’une même
icône, d’une même feuille de style.

Sur une page web, le trafic réseau représente l’essentiel du temps
d’attente et de chargement. Couper les temps d’attente réseaux et vous
aurez une réactivité quasi instantanée. 

Pour cela le navigateur stocke certaines ressources dans un cache local
au premier accès. Il stocke en fait simplement les fichiers
correspondants sur disque ou en mémoire. Quand il a besoin une nouvelle
fois de cette même ressource, il peut la prendre dans cet espace
temporaire rapide, sans avoir à la re-télécharger et à subir les délais
dus au réseau.

![Système de cache HTTP local](img/chap03-systeme-de-cache-http-local.png)


Importance du cache
-------------------

Sur deux pages d’un même site, on peut facilement avoir 80 % des
composants identiques. Si le cache est correctement utilisé, la seconde
page ne télécharge donc que les 20 % qui lui manquent. C’est ça qui peut
faire la différence entre un site lent et un site instantané.

Pour un utilisateur, passer de 81 requêtes HTTP à 2, ou de 400 ko à
75 ko c’est la différence entre une voiture et un vélo en performances.
Le résultat est visible immédiatement.

Mais en plus du gain visible pour l’utilisateur, vous avez un bonus.
Vérifiez combien vous coûtent vos serveurs et votre bande passante.
Imaginez diviser par 40 le nombre de hits ou par 5 votre bande passante.
L’investissement est très vite rentable. 

![Téléchargements en premier et second accès sur Amazon.fr](img/chap03-telechargements-en-premier-et-second-acces-sur-amazon-fr.png)

Sur l’échantillon de sites français testés on identifie le nombre de
requêtes et le poids total du document. Pour chaque site le premier
camembert montre la proportion de requêtes HTTP économisées si le cache
est initialisé (en foncé) par rapport au total des requêtes HTTP
réalisées. Le second camembert montre ce même rapport en prenant en
compte le volume de données téléchargé plutôt que le nombre de requêtes
HTTP. Un graphique essentiellement foncé montre que le cache permet
d'éviter l'essentiel des requêtes et des téléchargements. Un graphique
majoritairement clair montre à l'inverse que le cache est inefficace ou
mal exploité.

Un mauvais résultat (graphique clair) n’est toutefois pas toujours
facile à interpréter. Ce peut aussi être un type de page qui profite peu
du cache mais c’est aussi le plus souvent simplement que l’équipe de
développement n’a pas exploité le cache du navigateur et laissé de
mauvaises performances là où on aurait pu avoir de très bons résultats.
On ne peut donc pas les ériger en contre-exemples. C’est en fait plus le
symptôme d’une mauvaise qualité des sites français.

À l’inverse, les bons résultats (graphique foncé) sont une preuve de
l’effet qui peut être obtenu en travaillant les performances du site
web. Wikipedia, Facebook, Microsoft, Apple, Dailymotion, la Fnac,
permettent d’économiser plus de 90 % de la bande passante lors du second
accès. Ils représentent des sites de contenu, des sites vitrine, des
sites de commerce, des sites orientés vidéo. Très peu de catégories sont
exclues et même la page d’accueil de Google qui n’a pour ainsi dire
aucun composant complexe arrive à diviser par 6 se bande passante.

![Influence du cache sur le poids des pages et le nombre de requêtes HTTP](img/chap03-influence-du-cache-sur-le-poids-des-pages-et-le-nombre-de-requetes-http.png)

Cache initialisé et cache vide, utilisateurs concernés
------------------------------------------------------

On parlera de cache vide ou de premier accès quand le cache du
navigateur ne contient pas encore les éléments que vous souhaitez y
entreposer. Il est alors obligé de télécharger tous les composants
nécessaires. À l’inverse on parlera de cache initialisé ou de second
accès quand le navigateur a déjà tous les composants dans son cache et
peut les réutiliser sans avoir à les re-télécharger.

### Nombre d’utilisateurs concernés

Sur le papier un utilisateur arrive la première fois avec un cache vide.
Les composants de la page sont mis en cache par le navigateurs puis
toutes les pages suivantes, dans la même session ou dans toutes ses
sessions futures, sont téléchargées avec un cache pré-initialisé. 

En pratique les choses sont un peu différentes. Le cache des navigateurs
est limité en taille et vos utilisateurs ne naviguent pas que sur votre
site. Au fur et à mesure de leur surf le cache se rempli, et certains
anciens éléments sont effacés pour laisser de la place, peut être les
vôtres. Le résultat c’est qu’à la prochaine visite sur votre site, on se
retrouve dans la situation d’un cache vide : le navigateur doit
retélécharger tous vos composants.

Ensuite certaines politiques de sécurité d’entreprise ou de gestion de
la vie privée vident automatiquement et régulièrement le cache de
certains utilisateurs. Ces utilisateurs vont devoir réinitialiser
souvent leur cache et se retrouveront régulièrement dans une situation
qui correspond à nos mesures « cache vide ».

Enfin, sur un site web public, une part non négligeable des utilisateurs
viennent des moteurs de recherche. Ce sont des visiteurs qui viennent
pour la première fois sur votre site et qui, pour la plupart, ne
visiteront que peu de pages. Eux se retrouvent très souvent dans une
situation de cache vide.

### L’étude Yahoo!

L’équipe performance de Yahoo! a mené une étude [^16] pour connaître la
proportion de caches vides et de caches pré-initialisés lors de l’accès
à leur page d’accueil. Les résultats publiés montrent que 40 à 60 % des
visiteurs ont subi à un moment où un autre une expérience de cache vide
mais surtout 20 % des pages sont chargées avec un cache vide. 20 % c’est
une page sur cinq. Un nombre important des utilisateurs ne profitent
donc pas du cache : les optimisations du cache sont essentielles, mais
ne perdez pas de vue qu’une partie des utilisateurs n’en profiteront
pas.

La page d’accueil de Yahoo! est très spécifique et ces chiffres ne sont
probablement pas généralisables à tous les sites. Toutefois, la tendance
est, elle, certainement généralisable sur la plupart des sites web
publics : Les accès à votre site avec un cache vide sont fréquents et
non négligeables. Si vous avez un doute, faites vos propres mesures. La
réalisation est assez simple et Yahoo! explique comment faire dans son
étude.

[Proportion d’utilisateurs ou pages vues avec un cache vide](img/chap03-proportion-d-utilisateurs-ou-pages-vues-avec-un-cache-vide)[^17]

  [^16]: [Performance Research, Part 2: Browser Cache Usage – Exposed!, Yahoo!, janvier 2007](http://yuiblog.com/blog/2007/01/04/performance-research-part-2/)
  [^17]: © 2007- 2009  Reprinted with permission from Yahoo! Inc. YAHOO! and the YAHOO! logo are trademarks of Yahoo! Inc.

### Utilisateurs mobiles

Les terminaux mobiles ont des navigateurs de qualité très variable,
globalement plutôt mauvais. Android WebKit, Safari (iPhone) et Opera
Mobile sont à peu près au niveau mais les autres navigateurs sont
parfois catastrophiques, même quand ils sont eux aussi basés sur le même
code source.

Cloud Four a mené un test à grande échelle. Les résultats sont assez
mauvais. Près d’un tiers des utilisateurs testés ont un terminal qui ne
met pas en cache les ressources web. Les résultats sont très disparates
suivant les versions d’un même navigateur, ainsi une installation de la
version 3 d’Opera Mini fonctionne correctement. alors qu’une
installation de la version 4 ne gère aucun cache. Parmi les terminaux
les plus répandus, les Blackberry et Opera Mini 4 ont un sérieux
problème de cache. IE Mobile 7.x et Opera Mobile 8.x ont quelques
installations qui elles aussi ne permettent pas le cache (respectivement
sur 30% et 10% des tests).

Le résultat c’est que vous ne pouvez pas vous reposer sur le cache comme
palliatif des connexions bas débit des terminaux mobiles. Il sera
important de réduire au maximum la taille des composants, en tenant
compte du faible débit mais aussi de la probable absence de cache.

**Recommandation :** Prévoyez qu'une grande partie de vos utilisateurs
mobiles ne pourront pas profiter du cache. Limitez le nombre de vos
composants ainsi que leur taille.

### Résultats globaux

Toutefois, gardez en tête les résultats de Apple ou de Microsoft. Même
si 20 % des utilisateurs n’en profitent pas, le gain reste intéressant
en moyenne : gagner 90 % de la bande passante sur 80 % des pages, ça
permet encore de diviser la bande passante globale par 3 à 4.


Requête conditionnelle
----------------------

La principale problématique du navigateur c’est de savoir quoi mettre en
cache et combien de temps. Un élément qui ne part pas en cache, c’est un
téléchargement en plus. Un élément qui reste trop longtemps en cache,
c’est un élément qui risque de ne pas être mis à jour dans le rendu du
navigateur quand bien même il aurait changé sur le serveur.

Le premier mécanisme mis en oeuvre pour répondre à ces questions est la
requête conditionnelle. Il s’agit pour le serveur d’informer le
navigateur sur la date de dernière mise à jour du contenu. Dans les
téléchargements suivants, le navigateur peut demander au serveur si la
ressource a changé. Si ce n’est pas le cas, alors on évite de la
retélécharger.

### Détails HTTP

Lors du premier téléchargement, le serveur web envoie un identifiant ou
une date de mise à jour du contenu. L’entête en jeu pour la date de mise
à jour s’appelle `Last-Modified`. Elle utilise le format de la RFC 1123 :
`Sun, 06 Nov 1994 08:49:37 GMT`.

Requête :

~~~~~~~ {.http .request}
GET /index.html HTTP/1.1
Host: example.org
~~~~~~~

Réponse :

~~~~~ {.http .response}
HTTP/1.1 200 OK
Date: Sun, 02 Nov 2008 15:54:27 GMT
Last-Modified: Tue, 15 Nov 2005 13:24:10 GMT
Etag: "280100-1b6-80bfd280"
Content-Type: text/html; charset=UTF-8

<HTML>
[…]
</HTML>
~~~~~

Lors des téléchargements suivants, le navigateur renvoie cet identifiant
ou cette date et demande un téléchargement conditionnel. Cela se fait
avec l’entête `If-Modified-Since`, en reprenant la date fournie la
dernière fois par le serveur. Si le contenu a changé, tout ce passe
comme habituellement, et le serveur renvoie une nouvelle date.

Seconde requête :

~~~~~~~ {.http .request}
GET /index.html HTTP/1.1
Host: example.org
If-Modified-Since: Tue, 15 Nov 2005 13:24:10 GMT
Accept-Encoding: gzip,deflate
~~~~~~~

Réponse :

~~~~~ {.http .response}
HTTP/1.1 200 OK
Date: Sun, 02 Nov 2008 15:54:27 GMT
Last-Modified: Sun, 01 Feb 2009 18:44:18 GMT
Etag: "29244f-45d-3819bb2e"
Content-Type: text/html; charset=UTF-8

<HTML>
[…]
</HTML>
~~~~~

Si au contraire le contenu n’a pas été mis à jour depuis la dernière
fois, le serveur web se contente de signaler que rien n’a changé. Pour
cela il renvoie un code de retour 304 au lieu de l’habituel code 200 et
du contenu. Il y a toujours une requête HTTP, et donc un léger délai,
mais on évite de re-télécharger le contenu lui-même. Si la ressource
dépasse un ou deux kilo-octets, cela fait une différence.

Seconde requête :

~~~~~~~ {.http .request}
GET /index.html HTTP/1.1
Host: example.org
If-Modified-Since: Tue, 15 Nov 2005 13:24:10 GMT
~~~~~~~

Réponse (seules des entêtes sont envoyées, aucun contenu) :

~~~~~ {.http .response}
HTTP/1.1 304 NOT MODIFIED
Date: Sun, 02 Nov 2008 15:54:27 GMT
Content-Type: text/html; charset=UTF-8
~~~~~

### Support des navigateurs

Tous les navigateurs savent gérer les requêtes conditionnelles. Les
seules exceptions sont certains mauvais robots de téléchargement de fils
RSS. La situation évolue toutefois sur ces derniers logiciels et on peut
considérer que les mauvais clients HTTP se font rares.

Le protocole HTTP laisse toutefois une marge d’appréciation au
navigateur. Ainsi, certains navigateurs vérifient s’il y a mis à jour à
chaque visite, ou à chaque session, ou encore à chaque page. C’est cela
qui fait que parfois sur Microsoft Internet Explorer on continue pendant
quelques temps à voir un ancien contenu au lieu de voir la mise à jour.

Pour palier ce problème, il est possible de demander explicitement au
navigateur de revalider son contenu à chaque fois. Cela se fait avec le
paramètre `must-revalidate` de l’entête `Cache-Control` envoyée par le
serveur :

~~~~~ {.http .partial .response .oneline}
Cache-Control: public; must-revalidate
~~~~~

Il existe aussi un paramètre `proxy-revalidate`, qui a le même effet mais
qui s’adresse uniquement aux serveurs proxy. Les autres paramètres de
cette entête sont détaillées plus loin dans ce chapitre.

### Mise en œuvre sur le serveur web

La configuration par défaut de votre serveur web s’occupe de gérer tout
cela avec les contenus statiques. Si vous utilisez du contenu dynamique
(PHP, Java, Ruby, Python, etc.) c’est à vous de déterminer la dernière
date de modification de vos contenus, de comparer avec celle que vous
recevez, et d’envoyer soit le code de retour 304 soit l’entête
Last-Modified.

**Recommandation :** Gérez manuellement les entêtes HTTP de cache quand
vous servez du contenu dynamiquement (PHP, .Net, Ruby, Python, etc.) et
principalement des contenus réutilisables changeant peu (CSS,
Javascript, images).


Avec Ruby On Rails, un mécanisme est prévu pour cela dans le framework
via la méthode `fresh_when`, qui prend une date de dernière modification
et un etag :

~~~~~~~ {.ruby .rails}
fresh_when :last_modified => @article.published_at.utc, 
           :etag => @article
~~~~~~~

En PHP vous pouvez utiliser une fonction comme la suivante :

~~~~~~~ {.php}
<?php
function HttpCache($last_modified_timestamp)  {
  if( isset($_SERVER['HTTP_IF_MODIFIED_SINCE']) ) {
    $from_browser = $_SERVER['HTTP_IF_MODIFIED_SINCE'] ;
    $from_browser = strtotime($from_browser) ;
    if ($from_browser = = $last_modified_timestamp) {
      header('Not Modified', true, 304) ;
      exit ;
    }
  }
  $format = 'D, d M Y H:i:s' ;
  $to_browser = gmdate($format, $last_modified_timestamp) . ' GMT' ;
  header("Last-Modified: $to_browser");
}
~~~~~~~

ETag
----

La gestion du cache par dernière date de mise à jour est le mécanisme
dynamique proposé par la version 1.0 du protocole HTTP. Le protocole
HTTP 1.1 propose un mécanisme plus étendu : l’etag (pour entity tag, en
anglais).

### Détails HTTP

Au lieu d’une date avec `Last-Modified`, on envoie un identifiant textuel
avec l’entête `ETag`. Cet identifiant est ensuite renvoyé avec
`If-None-Match` au lieu de `If-Modified-Since`.

Première réponse :

~~~~~~~ {.http .response}
HTTP/1.1 200 OK
Date: Sun, 02 Nov 2008 15:54:27 GMT
Server: Apache/2.2.3 (CentOS)
Last-Modified: Sun, 01 Feb 2009 18:44:18 GMT
Etag: "29244f-45d-3819bb2e"
Content-Type: text/html; charset=UTF-8

<HTML>
[…]
</HTML>
~~~~~~~

Requête suivante :

~~~~~~~ {.http .request}
GET /index.html HTTP/1.1
Host: example.org
If-Modified-Since: Tue, 15 Nov 2005 13:24:10 GMT
If-None-Match: "29244f-45d-3819bb2e"
~~~~~~~

### Avantages des Etags sur les dates de dernière modification

Il y a deux avantages à ce nouveau procédé. Tout d’abord on peut gérer
des mises à jour plus fines, éventuellement plusieurs mises à jour pour
une même seconde, ce qui n’était pas possible auparavant. Ensuite HTTP
1.1 permet de gérer plusieurs représentations d’un même document à la
même adresse, par exemple un même contenu en plusieurs langues. Il est
ainsi possible d’avoir plusieurs identifiants pour une même adresse (un
par représentation), ce qui n’était pas réalisable avec les dates de
modification.

En réalité tous les clients HTTP ne savent pas gérer cette négociation
avec etag. Il faut donc toujours la doubler avec la négociation par date
de dernière modification quand on le peut.

Au final, comme peu de sites utilisent plusieurs représentations pour
une même adresse, et comme on doit de toutes façons doubler avec la date
de dernière modification, la gestion des etag a un intérêt limité.

### Désactiver les etags ?

L’équipe performance de Yahoo! a proposé dès le départ de désactiver la
gestion des etags sur les serveurs web. Outre leur intérêt limité, ils
posent en effet quelques problèmes.

L’etag est un identifiant unique textuel. Pour trouver cet identifiant
unique, le serveur web le plus courant sur le marché utilise
l’identifiant interne du fichier sur le disque (l’inode) associé à la
date de modification du fichier. Si vous avez un gros site avec
plusieurs serveurs, chacun a son disque, et l’identifiant interne du
fichier sera différent sur chaque serveur. 

Chaque serveur aura donc son propre identifiant, différent de celui des
autres. Pour peu que la première et la seconde requête ne touchent pas
le même serveur, vous re-téléchargerez inutilement des contenus. Bref,
non seulement inutiles, les etags vont pénaliser vos performances.

Désactiver les etags sous Apache peut être réalisé avec la directive :

~~~~~~~ {.apache .oneline}
FileETag none
~~~~~~~

En réalité il existe d’autres méthodes de génération des etags, qui ne
comportent pas ce défaut. Il suffit de ne pas utiliser l’identifiant
interne du fichier (l’inode). On peut par exemple recommander d’utiliser
la date de dernière modification associée à la taille du fichier :

~~~~~~~ {.apache .oneline}
FileETag MTime Size
~~~~~~~

**Recommandation :** Si votre site utilise plusieurs serveurs web,
désactivez les etags ou assurez-vous qu’ils ne se basent pas sur l’inode
des fichiers.

Désactiver les etags est plus simple, et vu leur faible utilité c’est
probablement le plus simple, mais le choix vous revient. Si votre site
n’utilise qu’un seul serveur pour l’instant, ne vous en préoccupez pas.

### Statistiques

L’analyse d’un échantillon d’une trentaine de sites français ne dégage
pas de consensus fort sur la questions des etag. À peu près autant
fonctionnent avec etag que sans etag. Tout au plus peut-on noter que
ceux qui ont les meilleures performances, donc qui ont probablement le
plus réfléchi à la question, ont plutôt tendance à la désactivation.

Il n’y a pas non plus de spécificité suivant le type de contenu (html,
javascript, feuille de style, images, autres). Seul Cdiscount fait une
différence en mettant des etag sur 60 images mais aucun des 25 fichiers
javascript ou des 19 fichiers CSS.

![Statistiques sur la présence d’Etag sur un échantillon de sites français](img/chap03-statistiques-sur-la-presence-d-etag-sur-un-echantillon-de-sites-francais.png)

Note : Sur la plupart des sites on peut voir qu’il y a toujours quelques
contenus sans etags, et quelques contenus avec etag. Il s’agit le plus
souvent de publicités et contenus externes, non contrôlés par le site
lui-même, ou de contenu très dynamique regénéré à chaque accès (dans le
cas de l’absence des etags). 

