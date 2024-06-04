import 'package:flutter/material.dart';

class ActesMed extends StatelessWidget {
  ActesMed({Key? key}) : super(key: key);

  List<ActeMed> acteMed = [
    ActeMed(
      title: 'Les pharmacies',
      pharmacies: [
        annuaire(
          name: 'Pharmacie Dr.Basma Mdaissi',
          region: "Nianou 8052",
          numTel: '28228741',
        ),
        annuaire(
          name: 'Pharmacie Victoria',
          region: "Rue Lac Victoria, Tunis 1053",
          numTel: '71 860 040',
        ),
        annuaire(
          name: 'Pharmacie du Centre Kobbi Ariana',
          region: "60 Av. Habib Bourguiba, Ariana",
          numTel: '70 732 201',
        ),
         annuaire(
          name: 'Pharmacie Bouattour Hichem',
          region: "Bardo Palace, 63 Av. Habib Bourguiba, Tunis 2000",
          numTel: '53 585 505',
        ),
      ],
      imagePath: "assets/pharmacie.png",
      couleurBordure: Colors.green,
    ),
    ActeMed(
      title: 'Les radiologues',
      pharmacies: [
        annuaire(
          name: ' Dr Ben Othman Nadia',
          region: "Centre de Radiologie Ghazela",
          numTel: '71 866 891',
        ),
        annuaire(
          name: 'Dr Hella Said Abdelhadi',
          region: "Centre radiologie manar",
          numTel: '71 881 881',
        ),
        annuaire(
          name: 'Dr Mohamed Amine Chemli',
          region: " Habib Bourguiba St, Nabeul",
          numTel: '92 540 838',
        ),
      ],
      imagePath: "assets/radiologue.png",
      couleurBordure: Colors.orange,
    ),
    ActeMed(
      title: 'Les médecins',
      pharmacies: [
        annuaire(
          name: 'Dr. Samir Gharbi (Généraliste)',
          region: "32 Rue Sidi Aloui, Bab Lakoues, Tunis ",
          numTel: ' 71 568 881',
        ),
        annuaire(
          name: 'Dr. Leila Ben Sedrine (Dermatologie)',
          region: "7 Rue de l'Artisanat, 2035 Tunis",
          numTel: ' 71 820 123',
        ),
        annuaire(
          name: 'Dr. Riadh Daghfous (Neurologie)',
          region: "12 Avenue de Paris, 1000 Tunis",
          numTel: ' 71 341 891',
        ),
        annuaire(
          name: 'Dr. Lamia Hamrouni Gharbi (Généraliste)',
          region: "Omrane Supérieur, Tunis",
          numTel: ' 71 796 654',
        ),
        annuaire(
          name: 'Dr. Adel Bouzid (Généraliste)',
          region: "Tunis",
          numTel: ' 71 797 987',
        ),
        
      ],
      imagePath: "assets/medecin.png",
      couleurBordure: Colors.blue,
    ),
    ActeMed(
      title: 'Les cliniques',
      pharmacies: [
        annuaire(
          name: 'Clinique Carthagéne',
          region: "Centre Urbain Nord, Tunis",
          numTel: '31 336 336',
        ),
        annuaire(
          name: 'Clinique Saint Augustin',
          region: "Centre Ville, Tunis",
          numTel: '71 791 100',
        ),
        annuaire(
          name: 'Clinique Ridha Mrad',
          region: "Centre Ville, Tunis",
          numTel: '71 846 666',
        ),
        annuaire(
          name: 'Clinique Mourali',
          region: "Centre Ville, Tunis",
          numTel: '71 331 331',
        ),
        annuaire(
          name: 'Clinique Taoufik',
          region: "Boulevard Mohamed Bouazizi, Tunis",
          numTel: '71 840 000',
        ),
        
      ],
      imagePath: "assets/hospital.png",
      couleurBordure: Colors.green,
    ),
    ActeMed(
      title: 'Les dentistes',
      pharmacies: [
        annuaire(
          name: 'Dr Yosra Tlijani Ben Farhat',
          region: "Ariana ",
          numTel: '52 659 797',
        ),
        annuaire(
          name: 'Dr.Mrabet Med Amin',
          region: "Ariana",
          numTel: '51 441 020',
        ),
        annuaire(
          name: 'Dr Damak Aref',
          region: "Rue Habib Chatti, Tunis",
          numTel: '20 290 074',
        ),
        annuaire(
          name: 'Dr. Emna Mouelhi',
          region: "Ezzahra, Ben Arous",
          numTel: '20 075 587',
        ),
      ],
      imagePath: "assets/destist.png",
      couleurBordure: Colors.blue,
    ),
    ActeMed(
      title: 'Les laboratoires',
      pharmacies: [
        annuaire(
          name: 'Laboratoire Manougui Bouzoffara',
          region: "Ariana ",
          numTel: '97 963 516',
        ),
        annuaire(
          name: 'Laboratoire Rahal',
          region: "38, Rue d Italie, Tunis ",
          numTel: '71 259 099',
        ),
        annuaire(
          name: 'Laboratoire Masmoudi',
          region: "5, Rue Ibn El Jazzar, Tunis",
          numTel: '70 860 680',
        ),
        annuaire(
          name: 'Laboratoire Clément',
          region: "3, Avenue de l'Indépendance, Tunis ",
          numTel: '71 321 144',
        ),
        
      ],
      imagePath: "assets/lab.png",
      couleurBordure: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: acteMed
              .map((acte) => Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: ActeMedWidget(acteMed: acte),
                  ))
              .toList(),
        ),
      ),
    );
  }
}

class ActeMed {
  final String title;
  final List<annuaire> pharmacies;
  final String imagePath;
  final Color couleurBordure;

  ActeMed({
    required this.title,
    required this.pharmacies,
    required this.imagePath,
    required this.couleurBordure,
  });
}

class annuaire {
  final String name;
  final String region;
  final String numTel;

  annuaire({
    required this.name,
    required this.region,
    required this.numTel,
  });
}

class ActeMedWidget extends StatelessWidget {
  final ActeMed acteMed;

  const ActeMedWidget({Key? key, required this.acteMed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      padding: EdgeInsets.all(10),
      color: const Color.fromARGB(255, 253, 250, 250),
      width: 350,
      height: screenHeight*1.5,
      child: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: acteMed.couleurBordure,
              width: 2.0,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    acteMed.imagePath,
                    width: 50,
                    height: 50,
                  ),
                  SizedBox(width: 10),
                  Text(
                    acteMed.title,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Container(
                width: 345,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromRGBO(208, 230, 244, 0.804),
                      blurRadius: 20.0,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: acteMed.pharmacies.map((annuaire) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              annuaire.name,
                              style: TextStyle(fontWeight: FontWeight.bold, color: acteMed.couleurBordure),
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/location.png",
                                  width: 15,
                                  height: 15,
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    annuaire.region,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Row(
                              children: [
                                Image.asset(
                                  "assets/phone.png",
                                  width: 15,
                                  height: 15,
                                ),
                                SizedBox(width: 10),
                                Text(annuaire.numTel),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          ),
    ),
),
);
}
}