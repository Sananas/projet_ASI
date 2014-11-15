Geoserver connecté base postGIS
==========
Ce répertoire contient le script nécessaire à la création d’un Geoserver connecté à une base PostGIS.

**Explication en image** : 

*Schéma simplifié* 
 ![alt text](https://raw.githubusercontent.com/Sananas/projet_ASI/master/Schema_Geoserver_Postgis_Simple.png "Schema de la connexion GEOSERVER / POSTGIS que nous allons etablir ")

*Schéma Technique* 
![alt text](https://raw.githubusercontent.com/Sananas/projet_ASI/master/Connect_GEOSERVER_POSTGRES.png "Schema de la connexion GEOSERVER / POSTGIS que nous allons etablir ")

***
Démarrage de boot2docker
------
Il est nécessaire dans un premier temps de lancer le script permettant de lancer boot2docker. Pour se faire, rendez-vous dans le répertoire contenant le **Vagrantfile**, le **runScript.sh** et le **runVagrant.sh**, à l’aide de la commande cd.

Une fois effectuée, lancer la commande ci-dessous afin de lancer le script.

`$ /bin/sh runVagrant.sh'`

Boot2docker est à présent lancé, une baleine apparaît.


Lancement des containers
------

Placez-vous dans le répertoire vagrant.

`docker@boot2docker: $ cd /vagrant/`

A présent nous allons lancer le script permettant de récupérer les images [PostgresSQL / PostGIS](https://github.com/jamesbrink/docker-postgresql) et [Geoserver](https://github.com/kartoza/docker-geoserver) sur le site Github. En effet, le lancement de PostGIS et de Geoserver se base sur deux images disponibles sur Github. 

L’image PostGIS écoutera sur le port 5432 et le Geoserver écoutera sur le port 8080. Le script établira un lien entre la base PostGIS créée et le Geoserver. Le script créera par la même occasion un container dynamique qui créera une table et ajoutera une couche shapefile.

`docker@boot2docker: $  /bin/sh runScript.sh`

Le lancement prend quelques minutes. Le mot de passe sera demandé demandés deux fois:

`PASSWORD : postgres`

Une fois terminée, assurez-vous que les containers ont bien été créés. Ils sont normalement listés à la fin du script.

**Note** : Si l’un des deux containers (ou les deux) ne s’affichent pas, vous devez alors trouver une nouvelle image sur le site Github. Veillez à choisir les images les plus populaires et lire chacun des readME, avant tout téléchargement.

Vous devez ensuite modifier le script **runScript.sh** en indiquant la nouvelle image postGIS (IMAGE_NAME) ou Geoserver (IMAGE_NAME_GEOSERVER).

Récupérer l’adresse IP du container postGIS qui s’est affiché à la fin du script. Notez là, nous la réutiliserons bientôt.

Connexion au Geoserver
---
Le Geoserver a convenablement été lancé par le script. Vous pouvez maintenant accéder à l’interface de gestion du Geoserver. Pour cela, ouvrir un navigateur web et entrer comme url, localhost:8080 

Voici les informations pour vous connecter au Geoserver :

* **Identifiant** : Admin

* **Mot de passe** : geoserver

Cliquer ensuite sur créer un nouvel Entrepôt et choisissez Postgis. Cette étape va vous permettre de connecter PostGIS sur le Geoserver pour pouvoir publier des couches ShapeFile.

____
* **Nom de la source de données** : database

* **Host** : 172.17.0.2

* **Port** : 5432

* **User** : postgres

* **Passwd** : postgres
____
Valider, vous avez maintenant connecté votre base PostGIS. Cliquer ensuite sur **Publier**, à droite de **database**. 
Appuyer sur **Basées sur les données** et **Calculées sur les emprises natives** dans la partie *Emprise native* et *emprise géographique*.



Visualisation de la donnée
------
Pour visualiser les données, cliquer sur **Visualisation des données**, puis OpenLayer à droite de la couche *ne_110m_ocean.shp*. 

| Titles        | Common Format           | All Format  |
| ------------- |:-------------:| -----:|
| *ne_110m_ocean.shp*     | **OpenLayers** KML GML |    |

Vous visualisez maintenant la donnée !

Interface d'administration sous PG ADMIN
------

Pour acceder à l'interface d'administration de votre serveur de base de données PostgresSQL / GIS, ouvrez PGAdmin, et configurer une nouvelle connexion à une base de donnée.

* **Nom** : database

* **Hote** : localhost

* **Port TCP** : 2201

* **Nom utilisateur** : postgres

* **Mot de passe** : postgres

Valider, puis rendez-vous dans la partie Schema de votre database pour voir vos données !
