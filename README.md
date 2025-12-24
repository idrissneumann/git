# Repo entrainement pour git

## Table des matières

[[_TOC_]]

## Périmètre

Dans cette formation vous apprendrez à utiliser git en ligne de commande et à travailler avec gitlab en équipe dans des vrais process de qualité d'entreprise (Sprints Agiles, Code reviews, gestion des conflits, ré-écriture et remise en forme de l'historique, CI/CD, etc).

## Dépôts de sources

* Dépôt principal: https://gitlab.comwork.io/comwork_training/git
* Miroir sur github: https://github.com/idrissneumann/git.git
* Miroir sur gitlab: https://gitlab.com/ineumann/git.git
* Miroir sur bitbucket: https://bitbucket.org/idrissneumann/git.git

## Documentation

Pour avoir l'essentiel de ce qu'il faut savoir pour manipuler git correctement, il faut se référer à [cette documentation](https://www.cwcloud.tech/docs/tutorials/git).

Pour savoir l'essentiel sur les méthodes agiles et Scrum, vous pouvez vous référer à [mon cours](https://ineumann.developpez.com/tutoriels/alm/agile_scrum/) sur developpez.com.

Les [slides de cette formation](./formation.pdf).

## Cas pratique

### Issue 1: résoudre un conflit

Correspond au ticket [issue #1](./https://gitlab.comwork.io/comwork_training/git/-/issues/1).

Créez votre branche de référence depuis depuis la branche `main`:

```shell
$ git checkout main
$ git pull --rebase origin main
$ git checkout -b main_{votre nom}
$ git push origin main_{votre nom}
```

Partez de la branche `conflict_to_merge` et créez votre propre branche:

```shell
$ git checkout conflict_to_merge
$ git pull --rebase origin conflict_to_merge
$ git checkout -b conflict_to_merge_{votre nom}
$ git push origin conflict_to_merge_{votre nom}
```

Remplacez ensuite "Idriss Neumann" dans le script `le_code_source.sh` et pushez la modification :

```shell
$ git add le_code_source.sh
$ git commit -m "Issue #1 - modification {nom prenom}"
$ git push origin conflict_to_merge_{votre nom}
```

Vérifier que votre commentaire arrive bien dans l'[issue #1](./https://gitlab.comwork.io/comwork_training/git/-/issues/1)

Ouvrez ensuite une merge request pour merger `conflict_to_merge_{votre nom}` dans `main_{votre nom}` et essayez de merger en résolvant correctement les conflits.

Une fois les conflits résolu, affectez cette merge request au formatteur

### Issue 2: faire un report et renommer les commit

Correspond au ticket [issue #2](./https://gitlab.comwork.io/comwork_training/git/-/issues/2).

* Créer une nouvelle branche `prod_{votre nom}` à partir de la branche `prod`
* Reporter les modifications en utilisant `cherry-pick`
* Renommer le message du commit en remplaçant le commentaire de l'issue #1 par issue #2 en utilisant le rebase interactif
* Pusher et observez le résultat sur le ticket [issue #2](./https://gitlab.comwork.io/comwork_training/git/-/issues/2)
* Ouvrir une merge request avec `prod` et l'affecter au formatteur

### Issue 3: exécuter le script dans une CI/CD

Correspond au ticket [issue #3](./https://gitlab.comwork.io/comwork_training/git/-/issues/3).

* Créer une nouvelle branche à partir de `main`
* Faire la configuration gitlab-ci pour que le script `le_code_source.sh` soit exécuté selon les règles suivantes:
  * Tag du runner: `rpi`
  * Uniquement sur les push sur `main` ou sur `prod`
  * Uniquement si le fichier `le_code_source.sh` a changé

### Fin de la scéance

On va merger vos merge request et vérifier que la CI/CD exécute bien ce qu'on lui a demandé.
