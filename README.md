# Repo entrainement pour git

## Table des matières

[[_TOC_]]

## Documentation

Pour avoir l'essentiel de ce qu'il faut savoir pour manipuler git correctement, il faut se référer à cette documentation: https://gitlab.comwork.io/comwork/wiki/-/blob/master/git.md

Si vous n'y avez pas accès, demander les accès à idriss.neumann@comwork.io (il est possible que l'on vous envoi un export pdf en fonction de si vous faite partie des effectifs de comwork ou non).

## Cas pratique : résoudre un conflit

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
$ git commit -m "Modification {nom prenom}"
$ git push origin conflict_to_merge_{votre nom}
```

Ouvrez ensuite une merge request pour merger `conflict_to_merge_{votre nom}` dans `main_{votre nom}` et essayez de merger en résolvant correctement les conflits.
