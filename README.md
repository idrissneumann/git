# Utilisation de git

## Cloner un repo

```shell
git clone <url du repository>
```

## Création d'une branche

Toutes les branches doivent partir du master. Idéalement on peut pusher la branche cela permet de visualiser sur GitLab qu'elle a bien été créée à partir du master et qu'à sa création elle est à jour avec le master.

```shell
git pull --rebase origin master
git checkout -b <numéro du ticket correspondante>
git push origin <numéro du ticket correspondante>
```

## Mise à jour d'une branche

Pour mettre à jour une branche il est préférable d'utiliser le rebase

```shell
git pull --rebase origin <numéro du ticket>
```

## Commit et push sur une branche

Il est important de le faire régulièrement et ne pas attendre d'avoir trop de modifications pour le faire.

Attention : le commit ne répercute pas les modifications sur le serveur GIT distant, c'est l'opération du push qui le fait.

```shell
git add . # à la racine du repo
git commit -m "<numéro de la branche ou ticket> commentaire"
git push origin <numéro de la branche ou ticket>
```

## Mettre de changement de côté

```shell
git stash # mettre de côté les changements
git stash list # lister les changements de côté
git stash pop <id du stash optionnel> # remettre les changements
git stash clear # vider les changement de côté
```

## Gestion des conflits lors de la mise à jour d'une branche

Les conflits apparaissent à la suite de la commande `git pull --rebase origin <numéro de la branche ou ticket>`

```shell
CONFLIT (contenu) : Conflit de fusion dans FILENAME
```

Il faut alors régler les conflits sur tous les fichiers indiqués puis exécuter les commandes suivantes :

```shell
git add FILENAME
git rebase --continue
```

### Cas exceptionnels

Cependant il se peut que vous ayez à résoudre plusieurs fois les mêmes conflits (cas non reproductible mais il semble que cela puisse arriver). Auquel cas vous pouvez abandonner le rebase et effectuer un merge :

Pour abandonner un rebase :

```shell
git rebase --abort
```

Vous pouvez essayer de squasher vos commits pour simplifier le rebase :

```shell
git rebase --interactive HEAD~2
# ==>> dans l'éditeur modifier les "pick" en "s"
```

Si vraiment le rebase ne veut pas passer vous pouvez effectuer un merge :

```shell
git pull origin <numéro de la branche ou ticket>
```

Pour abandonner un merge :

```shell
git reset --hard HEAD
```

## Merge du master dans une branche

Afin d'intégrer au fur et à mesure les modifications du master dans sa branche pour éviter que la désynchro soit trop importante il faut régulièrement faire le merge des modifications du master dans sa branche. A chaque fin de Sprint ce merge est obligatoire. Aussi avant d'effectuer le merge local il faut avoir mis sa branche à jour pour pouvoir faire le push de ce commit de merge immédiatement après.
La raison est la suivante : si entre temps un autre commit a été effectué sur la branche le commit de merge apparaitra en temps que commit de la branche et toutes les modifs du master se retrouveront dans la merge resquest.

```shell
git checkout master
git pull --rebase origin master
git checkout <numéro de la branche ou ticket>
git pull --rebase origin <numéro de la branche ou ticket>
git merge master
git push origin <numéro de la branche ou ticket>
```

Cela peux s'automatiser via le script suivant :

```shell
#!/bin/bash

if [[ ! $1 =~ ^[0-9\\-]+$ ]]; then
    echo "Missing number of story"
    exit 1
fi

brancheref="master"
if [[ $2 =~ ^[0-9\\-]+$ ]]; then
    brancheref="$2"
fi

cd ~/wks/src/Hub
git checkout "$brancheref"
git pull --rebase origin "$brancheref"
git checkout "$1"
git pull --rebase origin "$1"
git merge "$brancheref"
git push origin "$1"
```

## Gestion des conflits lors du merge

Les conflits apparaissent à la suite de la commande <code>git merge master</code> :

```shell
CONFLIT (contenu) : Conflit de fusion dans FILENAME
```

Il faut alors régler les conflits sur tous les fichiers indiqués :

```shell
git add FILENAME
git commit
```

## Merge manuel d'une branche vers le master

Tout les développeurs n'ont pas les droits pour faire cette opération. Il faut normalement passer par une merge request sur gitlab.

Avant d'effectuer le merge local il faut avoir mis le master à jour pour pouvoir faire le push de ce commit de merge immédiatement après.

```shell
git checkout <numéro de la branche ou ticket>
git pull --rebase origin <numéro de la branche ou ticket>
git checkout master
git pull --rebase origin master
git merge <numéro de la branche ou ticket>
git push origin master
```

Lorsque le merge s'est bien déroulé, il faut supprimer la branche dans GitLab.

```shell
git push origin --delete <numéro de la branche ou ticket>
```

## Démo

Voici le scénario de la démo Git :

```shell
###########################
# Initialisation repo Git #
###########################
 
# User 1
mkdir poc-git; cd poc-git; git init; touch README; touch BRANCH; git add README BRANCH; git commit -m 'first commit'; git remote add origin ssh://git@ci.docapost.io:8006/pcombescot/poc-git.git; git push -u origin master
 
 
####################
# Use case de base #
####################
 
# User 2
git clone ssh://git@ci.docapost.io:8006/pcombescot/poc-git.git poc-git-2; cd poc-git-2; git checkout -b 0000; echo "modif branch" >> BRANCH; git add BRANCH; git commit -m "modif branch"; git push origin 0000
 
# User 1
echo "modif master" >> README; git add README; git commit -m "modif master"; git push origin master; echo "modif bis" >> README; git add README; git commit -m "modif bis"; git push origin master
 
# User 3
git clone ssh://git@ci.docapost.io:8006/pcombescot/poc-git.git poc-git-3; cd poc-git-3; git checkout 0000; echo "modif branch bis" >> BRANCH; git add BRANCH; git commit -m "modif branch bis"
 
# User 2
git checkout master; git pull --rebase origin master; git checkout 0000; git pull --rebase origin 0000; git merge master
git push origin 0000
 
# User 3
git pull --rebase origin 0000; git push origin 0000
 
==>> Merge request: OK
 
#######################################
# Conlit lors du merge avec le master #
#######################################
 
# User 1
echo "modif master" >> BRANCH; git add BRANCH; git commit -m "modif master on branch"; git push origin master
 
# User 2
git checkout master; git pull --rebase origin master; git checkout 0000; git pull --rebase origin 0000; git merge master
==>> CONFLIT (contenu) : Conflit de fusion dans BRANCH
vi BRANCH
git add BRANCH; git commit
git push origin 0000
 
==>> Merge request: uniquement les modifs de la branche
 
####################
# Conflit sur 0000 #
####################
 
# User 3
git pull --rebase origin NUMERIQUE-0000; echo "modif branch conflit" >> BRANCH; git add BRANCH; git commit -m "modif branch conflit"; git push origin 0000
 
# User 2
echo "modif branch conflit bis" >> BRANCH; git add BRANCH; git commit -m "modif branch conflit bis"; git pull --rebase origin 0000
==>> CONFLIT (contenu) : Conflit de fusion dans BRANCH
vi BRANCH
git add BRANCH; git rebase --continue
==>> Application : modif branch conflit bis
git push origin 0000
 
==>> Network GitLab: OK
 
###########################
# Dernier merge optionnel #
###########################
 
# User 1
echo "modif ter" >> README; git add README; git commit -m "modif ter"; git push origin master
==>> Merge request: Accept Merge Request
```

## Basculer une branche sur une autre

Si on se trouve dans le cas ou une US a été basculé vers une autre nouvelle US, il sera utile de créer une nouvelle branche qui continue à "Tracker" l'ancienne pour garder l'historique complet.
=> Il s'agit de la même opération que renommer une branche.

```shell
git branch new-branch-name origin/old-branch-name
git push origin --set-upstream new-branch-name
git push origin :old-branch-name
```

## Commit et push de modification sur une branche

```shell
$ git commit -am "Deleting useless file"
[develop2 aab887a] Deleting useless file
 1 file changed, 31 deletions(-)
 delete mode 100644 .classpath
$ git push origin <numéro de la branch ou ticket>
Counting objects: 2, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (2/2), done.
Writing objects: 100% (2/2), 233 bytes | 0 bytes/s, done.
Total 2 (delta 1), reused 0 (delta 0)
remote: 
remote: Create merge request for develop2:
remote:   http://91.121.80.56:8181/gitlab/isamm/facedeplook-jee/merge_requests/new?merge_request%5Bsource_branch%5D=develop2
remote: 
To http://91.121.80.56:8181/gitlab/isamm/facedeplook-jee.git
   a778234..aab887a  develop2 -> develop2
```

## Supprimer une branche

```shell
git branch -d <numéro de la branche ou ticket> # localement
git push origin -d <numéro de la branche ou 
```

## Ré-initialiser une branche

```shell
git reset --hard origin/<numéro de la branche ou ticket>
```

