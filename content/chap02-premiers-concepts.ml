
Premiers concepts
=================

Avant d’entrer dans le détail des recommandations et du travail 
à réaliser, il est important de comprendre ce qu’il se passe entre 
le navigateur et le serveur web. Vous connaissez peut-être le 
principal mais jetez tout de même un oeil attentif à l’analyse 
réseau. Il y a de nombreux points sous-estimés qui méritent votre 
attention. 

Composition d’une requête HTTP
------------------------------

Le protocole utilisé par le navigateur web et le serveur web s’appelle 
HTTP : hypertext transfer protocol. Il s’agit d’un protocole 
simple à comprendre, basé sur des lignes de texte et des associations 
clef – valeur. 

La première particularité de HTTP est d’être un protocole dit 
_stateless_, sans état. Il n’y a en effet qu’un seul échange : 
Le navigateur envoie une requête puis attend la réponse du serveur. 
Il n’y a aucun autre échange entre les deux intervenants. Lorsque 
le navigateur demandera une seconde ressource (ou rechargera 
la même que précédemment) il fera une nouvelle requête, indépendante, 
sans aucun lien avec la première. 

### Exemple de requête HTTP

Une requête du navigateur au serveur est constituée de trois 
parties : la ligne de requête, un bloc d’entêtes, et éventuellement 
un bloc de données, le corps de la requête. 

GET /index.html HTTP/1.1 Host: example.org User-Agent: Mozilla/5.0 
([...]) Gecko/2008092414 Firefox/3.0.3 Accept: text/html,application/xml;q=0.9,*/*;q=0.8 
Accept-Language: fr,fr-fr;q=0.8,en-us;q=0.5,en;q=0.3 
Accept-Encoding: gzip,deflate Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7 
Keep-Alive: 300 Connection: keep-alive 

La première ligne est la ligne de requête. Le terme `GET` indique 
qu’on souhaite récupérer une ressource (la page web) ; c’est 
ce qui est fait le plus souvent. Vous pourrez aussi trouver `POST`, 
qui indique qu’on souhaite envoyer une ressource, par exemple 
un message sur un forum. D’autres opérations existent mais nos 
navigateurs n’utilisent que ces deux là donc nous nous en contenterons. 

Vient ensuite l’adresse de la ressource que nous souhaitons 
récupérer, ou vers laquelle nous souhaitons envoyer des informations. 
Cette adresse commence toujours par `/`, et ne contient pas le 
nom de domaine. Il s’agit d’une chaîne de caractères arbitraire. 
Si habituellement on considère qu’il y a des répertoires, un 
nom de fichier puis une extension, l’adresse peut en fait correspondre 
à tout à fait autre chose. Il s’agit en fait d’un simple identifiant, 
charge au serveur de savoir à quoi il correspond. 

La troisième information de la première ligne de requête est 
le protocole utilisé. Ce sera quasiment toujours `HTTP/1.1` 
pour les navigateurs, même si quelques rares scripts ou robots 
utilisent encore `HTTP/1.0`. 

Le reste de l’exemple donné constitue le bloc d’entête. Chaque 
ligne contient un couple clef – valeur, séparés par le caractère 
« : ». Certaines valeurs ont de multiples valeurs séparées par 
des virgules, et parfois une valeur est paramétrée, les paramètres 
étant séparés par un point virgule. 

Une ligne vide indique la fin du bloc d’entête. Dans le cas d’une 
requête de type `POST` vous trouverez aussi un bloc de contenu 
juste après. Il peut contenir des valeurs de formulaire par exemple. 

### Exemple de réponse HTTP

Une réponse HTTP n’est pas très différente d’une requête. On 
a une ligne de statut, un bloc d’entêtes et un bloc de contenu, 
le corps de la réponse. 

HTTP/1.1 200 OK Date: Sun, 02 Nov 2008 15:54:27 GMT Server: Apache/2.2.3 
(CentOS) Last-Modified: Tue, 15 Nov 2005 13:24:10 GMT Etag: 
"280100-1b6-80bfd280" Accept-Ranges: bytes Content-Length: 
438 Connection: close Content-Type: text/html; charset=UTF-8 
<HTML> _[…]_ </HTML> 

La ligne de statut contient le protocole, code de retour et un 
message explicatif. Le protocole sera presque toujours HTTP 
1.1, exceptionnellement HTTP 1.0. Le code de retour 200 indique 
que le serveur a traité la requête avec succès et renvoyé la page 
demandée, d’où le message explicatif « OK ». Vous connaissez 
aussi probablement le code de retour 404 « Document Not Found 
», qui correspond à une page non trouvée. Dans ce livre nous croiserons 
aussi les codes 301 et 302 qui sont des redirections, et le code 
304 qui est lié aux mécanismes de cache. 

La suite de la réponse est vraiment similaire à ce que nous avons 
vu pour une requête : une suite d’entêtes avec clef - valeur, une 
ligne vide, et le corps de la réponse. Le corps de la réponse c’est 
le fichier HTML, le code javascript, ou le contenu binaire de 
du fichier image. 

### Les outils

Pour explorer les requêtes et les réponses HTTP je vous encourage 
à télécharger l’extension Firefox nommée HTTPfox, ou encore 
l’extension LiveHttpHeaders. L’extension Firebug, les outils 
IBM Page Detailer ou Page Test peuvent aussi vous montrer le détail 
de ce qui est envoyé et reçu par les navigateurs. L’extension 
Firefox nommée TamperData permet même de modifier dynamiquement 
les requêtes HTTP au moment où elles sont envoyées, pour tester 
différents résultats. 

{draw:frame} Exemple de visualisation d’une requête HTTP avec 
Firebug 

Analyse d’une requête réseau
----------------------------

La requête HTTP n’est qu’une partie de ce qui est fait sur le réseau. 
Voici les concepts principaux à retenir. 

{draw:frame} 

Schéma d’un échange réseau 

### Requête DNS

Le début d’un échange commence toujours par une requête DNS. 
Quand vous demandez http://www.example.org/ il s’agit de déterminer 
quelle est l’adresse IP de la machine hébergeant www.example.org. 
C’est un DNS (serveur de nom de domaine) chez vote fournisseur 
d’accès qui va vous répondre. C’est généralement rapide, mais 
ça prend tout de même prendre quelques dizaines de millisecondes. 
En fait tout dépend de la latence avec le DNS de votre société, 
et éventuellement de la latence entre ce DNS et celui du site que 
vous cherchez à joindre. Sur un réseau lent ou avec un site très 
éloigné, cela peut dépasser 150 ms. 

### Connexion TCP

Une fois que votre navigateur connait l’adresse du serveur à 
joindre, on peut établir une connexion TCP avec le serveur web. 
TCP c'est le protocole utilisé par HTTP. Il s'agit ni plus ni moins 
que de mettre en place une sorte de fil de discussion entre le serveur 
et le client, et pour ça il faut l'accord des deux avec une phase 
d'initialisation. C’est rapide, très rapide, mais c’est encore 
une étape à franchir, qui dépend elle aussi de la latence. 

C’est seulement après ces deux premières étapes qu’on peut avoir 
un échange requête - réponse entre le navigateur et le serveur 
web. 

Le principe de base c'est qu'un fil TCP ne sert que pour un seul 
couple requête/réponse. À chaque nouvelle requête, on établit 
une nouvelle connexion TCP. Pour combler ce problème HTTP prévoit 
une fonctionnalité (connexions persistantes, keep-alive) 
pour garder le fil TCP ouvert et pouvoir y enchaîner plusieurs 
requêtes, l'une après l'autre. Cette possibilité a un gros avantage, 
mais n'est pas toujours activée sur les serveurs à cause de la 
consommation en ressources qu'elle implique. Une seconde fonctionnalité 
existe dans la version 1.1 de HTTP, le pipelining, mais elle est 
rarement activée. Nous y reviendrons plus loin dans ce livre. 

Pour compenser et comme solution de contournement, les navigateurs 
opèrent plusieurs téléchargements en parallèle (de 2 à 6 suivant 
le navigateurs). Ils ouvrent simplement plusieurs fils TCP 
et y envoient des requêtes différentes. Ils permettent ainsi 
d'optimiser la bande passante et de ne pas se tourner les pouces 
pendant les temps d'attente dus à la latence. 

### Génération de la page HTML par le serveur

Sur le schéma, le temps de génération de la page sur le serveur 
se verrait par un espace blanc entre la fin du parallélogramme 
labellisé « requête HTTP » et le début du parallélogramme « réponse 
HTTP ». 

Comme on l'a déjà vu dans le chapitre d'introduction, le temps 
de génération de la page, ce que j'ai appelé la partie « back-end 
», est quasiment toujours inférieur à la demie seconde (et le 
plus souvent inférieur au dizième de seconde), et au final négligeable 
par rapport au temps de chargement total de la page. C'est pourquoi 
c'est probablement la dernière fois que vous lirez quelque chose 
à ce propos dans ce livre, nous nous concentrerons sur le reste. 

### Temps de transfert, débit et latence

Vous voyez que sur le schéma on dessine des obliques et non des 
traits verticaux. Plus la latence est importante, plus les obliques 
sont écrasées, et donc plus l’aller-retour prend du temps. 

Vous voyez aussi que la requête et la réponse se dessinent ici 
avec des parallélogrammes et non de simples flèches. C’est parce 
que les requêtes prennent du temps à être envoyées entièrement, 
et les réponses prennent encore plus de temps à être téléchargées. 
Augmenter ou diminuer la bande passante réseau permet d’influer 
sur ces deux durées. 

### Les outils

Des outils comme Firebug, IBM Page Detailer ou AOL Page Test (ici 
en exemple dans sa version web) vous montreront les différentes 
étapes d’une requêtes, pour vous permettre de constater où est 
votre problème. Vous trouverez aussi des équivalents à Firebug 
dans les navigateurs Chrome et Safari. Plusieurs proxy de développement 
comme HttpWatch peuvent aussi exporter des données similaires. 

Le graphique alors représenté est appelé vue en cascade. Il est 
un peu différent du schéma explicatif général car il ne prend 
en compte que les temps d’attente vues du navigateur et permet 
d’établir les mesures pour chaque requête HTTP faite sur la page. 
On y remarque si une étape prend un temps trop important mais aussi 
si une requête bloque les suivantes par exemple. 

{draw:frame} {draw:frame} Exemple d’analyse faite par webpagetest.org 

### Plafonnement du débit lors d'une session HTTP

#### Gestion de la bande passante par TCP

Sur Internet le serveur ne connait pas la bande passante disponible 
sur le client, ou sur les éléments réseaux entre le serveur et 
le client. Il est donc impossible de savoir à priori à quelle vitesse 
envoyer les données. Comme les équipements réseaux ne peuvent 
se permettre de stocker temporairement les données de tout le 
monde, si des données sont envoyées plus vite qu'on ne peut les 
recevoir, une grande partie est simplement perdue, ignorée 
sur le trajet. 

Pour palier ce problème le protocole TCP met en œuvre une communication 
entre le client et le serveur. Le serveur commence par transmettre 
une certaine quantité de données au client puis attend confirmation 
de bonne réception. Si tout va bien il va transmettre un peu plus 
de données à la fois et attendre là aussi confirmation, et ainsi 
de suite. Quand la vitesse devient trop grande des données sont 
perdues et la confirmation n'arrive pas. Le serveur diminue 
alors la quantité de données et recommence. Après la phase d'initialisation 
la bande passante utilisée oscille donc (on monte jusqu'à dépasser 
la bande passante disponible, on diminue d'un coup pour remonter 
progressivement et recommencer). 

Comme ce système nécessite quelques allers-retours pour arriver 
en rythme optimal et que la latence influe sur le temps que prennent 
ces allers-retours, plus la latence est forte, plus la phase 
préalable de faible débit perdure. 

#### Influence sur HTTP et les pages web

Sur le web l'essentiel des contenus sont très petits, souvent 
moins de 5 ko, rarement plus de 25 ko. Seuls quelques pages ou composants 
javascript montent à 100 ko. Le résultat c'est que très souvent 
TCP n'a pas le temps d'échanger assez de données pour monter à 
la bande passante optimale entre le client et le serveur. 

Si on ajoute que pour télécharger plusieurs contenus le serveur 
et le client établissent plusieurs connexions TCP (chacune 
prenant un temps initial fixe pour l'initialisation avant le 
transfert d'une quelconque donnée) on comprend qu'assez rapidement 
augmenter la bande passante disponible n'aura aucune influence, 
ou très peu. 

D'après une étude de Google[^1], à 1 Mb/s le trafic HTTP occupe 
à peu près 70 % de la bande passante disponible. On tombe à 55 % pour 
une bande passante disponible de 2 Mb/s. Pour 4 Mb/s disponible 
on n'utilise que 1,45 Mb/s en réalité. Ce nombre n'augmente quasiment 
pas par la suite quand bien même on augmenterait encore la bande 
passante disponible. Pour la page de référence de Google, même 
avec une connexion qui peut réaliser 10 Mb/s, le trafic web n'en 
utilise pas beaucoup plus de 1,6 Mb/s. 

{draw:frame} Bande passante réellement utilisée en fonction 
de la bande passante disponible 

Plafonnement 

On observe un plafonnement de la bande passante à cause de la latence, 
du fonctionnement de TCP, des contraintes de HTTP et de la petite 
taille des composants échangés. Ce plafonnement rend peu utile 
d'avoir une bande passante de plus de 4 à 5 Mb/s. 

{draw:frame} Bénéfice de l'augmentation de la bande passante 
pour une page web 

Analyse réseau du chargement d’une page
---------------------------------------

Comme nous l’avons vu au premier chapitre, la page HTML principale 
n’est pas forcément la source du problème de performance. Généralement 
elle ne l’est pas du tout même. On ne peut pas se limiter à une requête 
indépendamment des autres. 

Le navigateur commence par charger la page HTML. Après quelques 
millisecondes, le navigateur initie le téléchargement des 
composants qui sont référencés dans la page. 

Un certain nombre de ces téléchargements sont fait en parallèles, 
les autres sont mis en attente le temps que les premiers soient 
terminés. De plus, certains composants sont bloquants, c’est 
à dire qu’ils empêchent tout chargement d’un autre composant 
en parallèle. La réorganisation des références dans la page 
peut donc permettre de charger plus vite les éléments visibles, 
ou d’éviter de bloquer le navigateur à un moment critique. 

### Les outils

Les graphiques en cascade sont un des outils principaux, essentiellement 
Firebug ou les outils de développements de Chrome, Google Page 
Speed ou Yslow (tous les deux des extensions de Firefox), un proxy 
de débogage comme Charles, et AOL (web) Page Test ou IBM Page Detailer. 
On y liste toutes les requêtes sur un axe de temps. On voit s’il 
y en a trop, lesquelles bloquent les autres, lesquelles sont 
lentes, etc. 

Si dans l’analyse d’une requête réseau particulière nous nous 
intéressions au graphique ligne à ligne, ici nous nous intéressons 
surtout à la cascade elle-même, à l’enchaînement et à l’organisation 
des requêtes. 

### Exemple de chargement

Un graphique en cascade du chargement de Yahoo! France accompagne 
ces pages. Vous pouvez y constater quelques particularités 
propres à une analyse macroscopiques. 

Tout d’abord vous voyez que certaines requêtes bloquent tout 
téléchargement. C’est le cas de la troisième ligne, un fichier 
javascript. Tant que ce javascript n’est pas entièrement téléchargé, 
rien d’autre n’avance. Il y a même un espace blanc entre la fin 
de ce javascript et le téléchargement suivant. C’est que le javascript 
prend un certain temps à s’exécuter, et bloque le navigateur 
pendant ce temps. 

{draw:frame} Graphique en cascade de la page d’accueil Yahoo! 
France 

Ensuite vous voyez que le rendu de la page ne commence que longtemps 
après que la page HTML soit téléchargée. La page HTML principale 
c’est la première ligne. Le début du rendu sur le navigateur c’est 
la première ligne verticale, entre 3 s. et 3,5 s. La seconde ligne 
verticale correspond à l’événement `onLoad` du navigateur, 
c’est à dire quand le navigateur considère avoir entièrement 
chargé la page. 

Notre objectif est d’avancer au maximum le début du rendu, première 
ligne verticale, et la fin des téléchargements, seconde ligne 
verticale. Pour cela on tente d’éliminer des requêtes HTTP, 
surtout les plus lentes, ainsi que de réduire le temps de chargement 
et d’améliorer la parallélisation de celles qui restent. 

On retrouve sur le graphique en cascade les différentes étapes 
d'un connexion HTTP sur chaque ligne. Les différentes couleurs 
permettent de repérer la requête DNS, l'établissement de la 
connexion TCP, l'envoi de la requête et l'attente du navigateur, 
puis la réception elle-même. 

Suivant les lignes, la requête DNS et l'établissement de la connexion 
TCP peuvent être inutile (respectivement sile domaine a déjà 
été résolu en adresse IP, et si le serveur réutilise une connexions 
persistante). La réception des données est parfois tellement 
rapide qu'elle semble ne pas apparaître dans le graphique. 

On voit aussi deux lignes verticales. La première symbolise 
le début du rendu dans le navigateur (la page commence à ne plus 
être blanche) et la seconde indique l'événement « onload » dans 
le navigateur. 




--------

[^1]: More bandwidth doesn't matter (much), Google, Mike Belshe, avril 2010
Les graphiques suivants sont tirés de cette étude.
[http://www.belshe.com/2010/05/24/more-bandwidth-doesnt-matter-much/](http://www.belshe.com/2010/05/24/more-bandwidth-doesnt-matter-much/)


