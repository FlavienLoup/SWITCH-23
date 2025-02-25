# Prepare data for Switch simulation
### FR :
````
Ces dossiers contiennent l'ensemble des scripts nécessaires au prétraitement des données nécessaires à la simulation
de SWITCH. L'ensemble des scripts se trouvent dans le dossier SRC.

Afin de lancer la procédure de création complète, lancez le script CreateFiles.py.
Les données nécessaires à l'utilisation des scripts se trouvent dans IN.
Les données produites par le script se trouvent dans OUT.

Si vous supprimez les fichiers dans le dossier OUT, le script lancera les algorithmes pour les recréer à son exécution.
Il relancera aussi les algorithmes pour les fichiers dépendants si nécessaire.
````
Afin de modifier un fichier, il faut donc : Modifier le fichier source dans IN puis supprimer le fichier dans OUT.

#### Contenu de IN :

- **BATIMENT.xxx** : sont les fichiers shapefiles des bâtiments à récupérer dans la BD Topo.
- **TRONCON_DE_ROUTE.XXX** : sont les fichiers shapefile des routes à récupérer dans la BD topo.
- **COMMUNE.XXX** : ensemble des commune française trouvable dans la bd topo
- **population** : population a simuler au format de l'EMD de Toulouse (pour le moment copie de l'emd)
- **EMD_depl** : est le fichier déplacement de la base de donnée EMD (enquête ménage déplacement).
- **EMD_pers** : est le fichier personne de la base de donnée EMD.


#### Contenu de OUT :

- **bati.xxx** : shapefile, contenant les bâtiments au bon format dans la zone à étudier.
- **roads.xxx** : Shapefile contenant les routes de la zone à étudier
- **depl.csv** : liste des déplacements et des heures à laquelle ils sont réalisés en fonction des individus
- **people.csv** : liste des individus de l'EMD classifiés avec shabou
- **population.csv** : population qui va peupler l'EMD (Actuellement individu de l'EMD associé à une chaîne d'activité)
- **PopulationModel** : fichier qui associe les profils Shabou à la chaîne d'activité correspondant à toutes les personnes ayant ce profil dans l'EMD.


#### Contenu de SRC :

- **CreateFiles** :  est le script principal qui appellera tous les autres dans le bon ordre.
- **CentroidandSphere** : est le script qui permet de récupérer toutes les routes et bâtiments autour de la ville à étudier.
- **Classify_Shabou** : classifie un ensemble d'individus en fonction de l'arbre de shabou (pour les jours de la semaine)
- **createActivityChain** : Créer des listes d'activité à partir du fichier depl de l'EMD en les groupant par individu
- **formatageBati** : Regroupe deux fonctions permettant de mettre les bâtiments au bon format en fonction de leur source (BD topo ou OSM) (Le script OSM doit être mis à jour en fonction des types de bati présent dans la zone à étudier).
- **FormatRoute** : permet de mettre les routes de la BD Topo au bon format.
- **PreapaDataWShabou** : est un ensemble de fonctions utilitaires pour préparer les données EMD aux traitements.

#### Dépendances :

Afin de fonctionner les scrypts python on besoin que les bibliothèque suivante soit installées:
- Pandas
- Geopandas
- OS
- Shapely
- AST

#### Guide de création de scénario :

###### Pour modifier la zone d'étude :
````
Pour modifier la zone d'étude il faut modifier 
les dossier 'BATIMENT.xxx' et 'TRONCON_DE_ROUTE.xxx'
Ainsi que la ligne "communeAEtudier = 'xxxxx' "
ou xxxxx est le numéro de la commune a étudier.
L'algorithme va récupérer toute les routes et batiment dans un rayon de 15 km autour du centre de cette commune.
Pour que cela fonctionne bien, il faut donc que la commune a étudier ce trouve dans les fichiers BATIMENT 
et TRONCON_DE_ROUTE. Actuellement les fichiers couvrent le departement du 31.
Pour changer de région, vous pouvez télécharger les données dans la bd topographique.
Le rayon d'étude peux être modifier dans le code en modifiant la ligne 44 : diametre = 15000
````
pour télécharger la bd topographique d'une nouvelle region :
<https://geoservices.ign.fr/bdtopo>
````
Pour modifier les infrastructures routier sur une zone d'étude deja existant, vous pouvez les modifiers directement
dans les fichiers TRONCON_DE_ROUTE et BATIMENT en respectant le format de données de la bd topo.
Pour cela vous pouvez utiliser un logiciel comme qgis our arcgis.
````
###### Pour modifier la population : 
````
Pour modifier la population, il faut modifier le fichier lu a la ligne 22 "src_pop = '../IN/population.csv'"
actuellement la population utilisé et la même que l'EMD de Toulouse. Pour modifier la population vous pouvez modifier directement
le fichier ou en télécharger un nouveau. Il faut que le fichier corresponde au format de l'EMD Toulouse.
Toute les colones ne sont pas utiliser les utiles sont :
P2(genre), P4(age), P8(niveau d'étude), P9(activité principale) et PCSD(Catégorie socioprofessionnelle)
````
EMD Grenoble : <https://www.data.gouv.fr/fr/datasets/enquetes-menages-deplacements-emd/>

info EMD Toulouse : <https://data.progedo.fr/studies/doi/10.13144/lil-0933>


### EN :
```

These folders contain all the scripts needed to pre-process the data needed to simulate SWITCH.
All scripts are in the SRC folder.
To start the complete creation procedure, run the CreateFiles.py.
The data needed to use the scripts can be found in IN.
The data generated by the script can be found in OUT.

If you delete the files in the OUT folder, the script will launch the algorithms to recreate them when it runs. It will also restart algorithms for dependent files if necessary.

To modify a file, you must: Modify the source file in IN and then delete the file in OUT.

```
#### IN Content :

- BATIMENT.xxx are the shapefiles of the buildings to be recovered in the Topo BD.
- TRONCON_DE_ROUTE.XXX are the shapefile files of the routes to be recovered in the topo BD.
- EMD_depl is the move file of the EMD database (household move survey).
- EMD_pers is the person file of the EMD database.


#### OUT content :

- bati.xxx shapefile, containing the correct format buildings in the study area.
- road.xxx Shapefile containing the roads in the study area
- depl.csv list of trips and times they are made according to individuals
- people.csv list of EMD individuals classified with Shabou
- population.csv population that will populate the EMD (Currently EMD individual associated with an activity chain)
- PopulationModel file that links the Shabou profiles to the activity chain for all people with this profile in the EMD.

#### SRC content : 

- CreateFiles is the main script that will call all others in the correct order.
- CentroidandSphere is the script to retrieve all the roads and buildings around the city to study.
- Classify_Shabou classifies a set of individuals according to the shabou tree (for weekdays)
- createActivityChain Create activity lists from the EMD depl file by grouping them by individual
- formatageBati Includes two functions to put buildings in the right format according to their source (BD topo or OSM) (The OSM script must be updated according to the types of building present in the area to be studied).
- FormatRoute allows to put the routes of the Topo BD in the correct format.
- PreapaDataWShabou is a set of utilities to prepare EMD data for processing.

#### Dependencies :

Those algorithm need following library to work :
- Pandas
- Geopandas
- Shapely
- OS
- AST
