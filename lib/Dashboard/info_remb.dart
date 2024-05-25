import 'package:flutter/material.dart';
import 'chart.dart';


class StorageInfoCard extends StatelessWidget {
  const StorageInfoCard({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.amountOfFiles,
    //required this.nbreBulletin,
    this.amountColor = Colors.black, // Couleur de la quantité par défaut
    this.imageWidth = 18, // Définir une valeur par défaut pour la largeur de l'image
    this.imageHeight = 18,
  }) : super(key: key);

  final String title, amountOfFiles;
  final String imagePath;
  //final int nbreBulletin;
  final Color amountColor; // Couleur de la quantité
  final double imageWidth; // Ajouter un paramètre pour la largeur de l'image
  final double imageHeight; // Ajouter un paramètre pour la hauteur de l'image

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: Colors.blue.shade300,width: 3)),
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            height: imageHeight,
            width: imageWidth,
            child: Image.asset(imagePath),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  //
                 
                ],
              ),
            ),
          ),
           Text(
                    amountOfFiles,
                    style: TextStyle(
                      color: amountColor, // Utiliser la couleur de la quantité déterminée
                    ),
                  ),
        ],
      ),
    );
  }
}

class InfoRemb extends StatelessWidget {
  const InfoRemb({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int nbreBulletin=0;
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color:Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
         boxShadow: const [
      BoxShadow(
        color: Color.fromRGBO(204, 234, 252, 0.804),
        blurRadius: 20.0,
        offset: Offset(0, 5),
      ),
    ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
         
          Text(
            "Remboursements",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
           Text(
                    "45 bulletin${nbreBulletin != 1 ? 's' : ''}",
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall!
                        .copyWith(color: Colors.black), // Utiliser la couleur déterminée
                  ),
          ],),
          SizedBox(height: 30),
          Chart(), // Appel au code de chart
          StorageInfoCard(
            imagePath: 'assets/newspaper.png', // Chemin de l'image pour les bulletins remboursés
            title: "Bulletins remboursés",
            amountOfFiles: "30",
           // nbreBulletin: 45,
            amountColor: Colors.blue, // Couleur de la quantité pour les bulletins remboursés
          ),
          StorageInfoCard(
            imagePath: "assets/encours.png", // Aucune image spécifiée pour les contre-visites
            title: "Contre visite",
            amountOfFiles: "10",
           // nbreBulletin: 45,
           amountColor:Color.fromARGB(255, 162, 216, 232),
          ),
          StorageInfoCard(
            imagePath: 'assets/decline.png', // Chemin de l'image pour les annulations
            title: "Annuler",
            amountOfFiles: "5",
           // nbreBulletin: 45,
           amountColor: Color.fromARGB(255, 243, 202, 55),
          ),
        ],
     ),
);
}
}