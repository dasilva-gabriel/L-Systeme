Rapport du projet L-Systèmes
===

## Contributeurs

DEPREZ Hugo

DA SILVA Gabriel

## Fonctionnalités

#### Minimum & Extensions

Notre programme satisfait les exigences du sujet minimal, et possède également plusieurs fonctionnalités \"optionnelles\" :

* affichage en couleurs (à chaque `Store` la couleur change, et celle-ci est rétablie à chaque `Restore`). Précisons cependant qu\'un L-Système ne possédant pas d\'instructions de ce type se verra afficher en noir (par exemple `snow.sys`).

* animation d\'une itération du L-Système : pour continuer l\'affichage du L-Système (entre les itérations), il suffit de bouger sa souris.

* itération suivante ou arrêt : une fois une itération terminée, un tout petit message s\'affiche en bas à droite de la fenêtre, précisant les touches sur lesquelles appuyer en fonction de nos envies : la touche `Q` pour quitter ou n\'importe quelle autre touche pour passer à l\'itération suivante (malheureusement pas de choix de la taille de la police pour le message, Cf [Cours 7](https://gaufre.informatique.univ-paris-diderot.fr/letouzey/pf5/blob/master/slides/cours-07b-graphics.md)). Ce message permet aussi de savoir si une itération est terminée ou non : si le message n\'est pas présent, c\'est que vous devez toujours bouger votre souris !

* chargement des données à partir d\'un fichier : vous pouvez charger votre L-Système en le passant en argument de la commande run via un fichier `.sys` (Cf Section `Compilation et exécution`). Le fichier sera alors chargé, et vous pourrez l\'afficher.

* choix de la taille de la fenêtre, ainsi que des coordonnées et de l\'angle de départ : ces informations seront lues depuis le fichier `config`.

* réduction de l\'échelle : au fur et à mesure des itérations, l\'échelle baissera toute seule afin de limiter la propagation du L-Système en dehors de la zone d\'affichage (cependant inévitable selon les dimensions passées à `Line` et/ou `Move`).

#### Manquant / À améliorer

Plusieurs points restent cependant largement améliorables:

* l\'affichage qui fait un peu \"vide\" (fond blanc).

* la sortie de l\'écran lorsque l\'itération commence à être importante.

* la vérification de la validité des arguments : il y avait trop de règles à vérifier pour que cela ait un sens, donc nous sommes partis du principe que l\'utilisateur aurait un semblant de cerveau et respecterait le format

Certains points n\'ont eux pas pu être implémentés, car nous n\'avons tout simplement pas réussi à le faire :

* l\'interprétation des chaînes parenthésées à la volée (sans les mettre en mémoire) : nous n\'avons pas compris l\'explication des sous-arbres etc...

* la sauvegarde des résultats dans des `.pdf` ou des `.svg` : nous avons trouvé comment le faire pour des formats \"simples\" (Cf [sujet](https://gaufre.informatique.univ-paris-diderot.fr/letouzey/pf5/blob/master/projet/projet.pdf)), mais pas pour les formats que nous voulions.

## Compilation et exécution

#### Compilation

Pour compiler le programme, la commande `make` suffit (de même que `make clean` suffit à nettoyer le répertoire).

#### Format des fichiers

Comme énoncé plus haut, notre programme permet le parsing de plusieurs fichiers : le fichier `config`, ainsi que les fichiers `.sys` pour le chargement des L-Systèmes. Ceux-ci doivent respecter plusieurs règles :

* l\'axiome doit être écrit sur une ligne précédée d\'un nombre quelconque de lignes vides (lignes ne comportant que le symbole `\n`) ou de commentaires (lignes commençant par `#`), puis suivie d\'un nombre quelconque de lignes vides ou de commentaires.

* les règles suivent la même logique, cependant il ne peut pas y avoir de lignes vides ou de commentaires entre les règles : cela doit être un seul \"bloc\".

* les interprétations suivent la même logique que les règles, mais celles-ci doivent également respecter des principes supplémentaires : il ne peut pas y avoir d\'interprétation autre que `L`, `M` ou `T`, tous les symboles doivent avoir une interprétation et il ne peut pas y avoir plus d\'interprétation que de symboles.

Le fichier `config` quant à lui doit respecter, en plus des règles précédentes concernant le format, plusieurs règles :

* aucune donnée (à part l\'angle) ne peut être négative.

* les coordonnées doivent être exprimées en float, donc avec un `.` à la fin si le chiffre est \"rond\".

* les coordonnées doivent être inférieures aux bornes de la fenêtre.

* l\'angle doit être compris entre -360 et 360 degrés.

#### Chargement d\'un fichier

Pour \"charger\" un fichier, il suffit de faire `./run arg`, où arg représente un fichier `.sys`, correspondant à une déclaration de L-Système (voir plus haut, ou les exemples fournis comme `snow.sys` ou `tree.sys`). Un message vous indique que tout s\'est bien passé, ou l\'erreur le cas échéant.

Une fois chargé, le L-Système peut être affiché autant de fois que voulu sans être rechargé.

#### Affichage d\'un L-Système

Une fois chargé, un L-Système peut être \"démarré\" via la commande `./run`. 

Si vous ne chargez aucun fichier, le L-Système affiché sera le dernier L-Système chargé, ou `tree.sys` si vous venez de fork notre projet.

#### Librairies

À notre connaissance, nous ne nous sommes servis que de bibliothèques _\"standard\"_ (Float, Graphics, String, List, etc), c\'est pourquoi nous ne fournissons qu\'un lien vers la documentation de la [librairie standard](https://www.ocaml.org/releases/4.11/htmlman/stdlib.html).

## Découpage modulaire

#### Turtle

Ce module regroupe toutes les fonctions de gestions des positions, d\'interprétations graphiques des axiomes, de mise à jour des positions et des couleurs, et l\'animation de l\'affichage.

Ce module était présent par défaut.

#### Systems

Ce module regroupe toutes les fonctions d\'interprétations des axiomes, d\'applications des règles, de créations des listes de commandes, du lien avec la tortue et de la gestion des itérations.

Ce module était présent par défaut.

#### Parse

Ce module regroupe les fonctions de lecture des arguments (pour les L-Systèmes), de conversion/traduction de ces arguments en L-Systèmes utilisables par notre programme, ainsi que de la création des fichiers de sauvegarde des L-Système.

Pour expliquer plus en détail comment fonctionne notre chargement de L-Système :

* nous prenons le fichier `.sys` et nous le lisons

* nous traduisons chacune des lignes en une string représentant ce qu\'un L-Système devrait contenir

* nous écrivons ces lignes dans un fichier `lsys.ml` (avec son `lsys.mli` afin d\'être utilisable en dehors du module), comme dans le fichier `exemple.ml` fourni

Ce module n\'était pas présent par défaut.

#### Config

Ce module regroupe les fonctions de conversion/traduction de la `config` fournie par l\'utilisateur, afin de générer une fenêtre aux dimensions voulues, ainsi qu\'un curseur démarrant exactement là ou le veut l\'utilisateur.

Ce module n\'était pas présent par défaut.

## Organisation du travail

Le découpage s\'est fait en interne (dans notre conversation privée), de même que les discussions des merge-request et des assignations des issues.

Hugo s\'est occupé de `turtle`, puis Gabriel a implémenté les fonctions de `systems`. Hugo a ensuite implémenté le parsing de fichiers pour les L-Système, ce qui a permis à Gabriel de s\'occuper du chargement de la configuration, ainsi que de push le `main` final.

## Misc

* Le projet contient un `.gitignore` : vous pouvez ignorer ce fichier, il ne sert qu\'a nous simplifier la vie dans notre utilisation de git.

* Gabriel s\'étant fait pirater son compte GitLab (vol de mot de passe), nous avons dû attendre le 13/01/2021 pour mettre en place un repo git sécurisé (l\'étudiant pirate lui ayant déjà dérobé son projet de CPOO).

* Les seules lignes dépassant les 80 caractères sont des décalarations de types dans des `.mli`.
