# Documentation Epicture

Ceci est la documentation technique officielle du projet **Epicture** proposé par **EPITECH**.

Il nous est demandé de réaliser par groupes de 2, une application mobile utilisant l'**API imagur**.

Pour réaliser ce projet nous avons décidé d'utiliser comme technologie le langage **Flutter**.

Nous n'aborderons pas la partie du développement de l'application pour Apple.
___

## I - Technologies et Logiciels

Avant de pouvoir tester et travailler sur l'application, il vous faudra installer ces différents outils.

Pour commencer, installer **Android Studio**. En installant ce logiciel, cela vous installera tous les packages nécessaires au développement d'applications pour android. De plus, il vous donnera accès à des émulateurs de téléphone ou de tablette sous android pour pouvoir directement tester votre application sans utiliser votre téléphone.

Si vous voulez tester ou développer votre application directement sur votre téléphone, il vous faudra passer en **mode développeur** et activer le **mode débogage** quand vous serez branché par USB.

Pour utiliser flutter simplement, vous pouvez installer **l'extension Flutter** sur **Visual Studio Code**. Cela vous permettra aussi du compiler rapidement sous un émulateur d'**Android Studio** et de débugger en temps réel votre application à chaque sauvegarde du code.

___

## II - Architecture

1 - Architecture des dossiers
===
Vous aurez ici toutes les informations sur la disposition des dossiers et sur les fichiers les plus importants.


    epicture
    ├─android // Ce dossier gère la partie Android de l'application
    │ └─app
    │   └─src
    │     └─main
    │       ├─mipmap-hdpi // Inclure une image nommé "ic_launcher.png" au bonne dimension qui sera l'icon de l'application (idem pour les dossiers similaire)
    │       │ └─ic_launcher.png
    │       ├─mipmap-mdpi // //
    │       ├─mipmap-xhdpi // //
    │       ├─mipmap-xxhdpi // //
    │       ├─mipmap-xxxhdpi // //
    │       └─AndroidManifest.xml // Doit être modifier directement pour l'ajout de certain paramètre spécifique à Android
    ├─ios // Ce dossier gère la partie IOS de l'application
    ├─lib
    │ ├─pages // Contient les différentes pages que possède l'application
    │ ├─parsers // Contient les parsers de Json
    │ ├─providers // Contient les différents providers de l'application
    │ ├─widgets // Contient les widgets customs ou modifier
    │ └─main.dart // Contient la fonction de lancement ainsi que certain paramètre de l'application
    ├─test // L'ajout de test de l'application ce fais dans ce dossier
    └─pubspec.yaml // L'ajout de nouveau **plugin** ce fait dans ce fichier dans les **dependencie**


2 - Architecture des données
===
A faire
├─│└
___
___
___
# A RAJOUTER

des informations sur le build de l'apk
===
des informations l'achitecture des données
===
...
===
___

**by Thomas DALEM / Tony MARINI**