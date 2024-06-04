import 'package:flutter/material.dart';
import 'package:pfe/Dashboard/dashboard.dart';
import 'package:pfe/RemAdmin.dart';
import 'employé.dart';
import 'bsAdmin/BSAdmin.dart';
import 'connexion.dart';
import 'newmember.dart';
import 'responsive.dart';
import 'package:pfe/cntrollers/controller.dart';
import 'package:provider/provider.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
class AccueilAdmin extends StatefulWidget {
  const AccueilAdmin({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<AccueilAdmin> {
  int selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
       dashboard(),
     Employeee (),
     BSAdmin(bulletinsSoins: [],),
      NewMemberPage(),
      Remb(),


  ];
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      leading: !Responsive.isDesktop(context) ? IconButton(
      onPressed: context.read<Controller>().controlMenu,
      icon: Icon(Icons.menu),
      ) : null,
      title:
         Image.asset(
        'assets/CapgeminiEngineering_82mm.png',
        width: 220,
        height: 220,
      ) ,
      actions: [
       
        Container(
          padding: const EdgeInsets.only(right: 40),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             
            ],
          ),
        ),
      ],
    ),  
 key: context.read<Controller>().scaffoldkey,
 drawer: MenuDrawer( // Ajoutez le menu drawer ici
    onItemTapped: (index) {
      setState(() {
        selectedIndex = index;
      });
    },
    selectedIndex: selectedIndex,
  ),
      body: Column(
        children: [
           Divider(color: Color(0xFF5BADE9)),
          Expanded(
            child: Row(
              children: [
                if (Responsive.isDesktop(context))
                SizedBox(
                  width: 265,
                  child: MenuDrawer(
                    onItemTapped: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    selectedIndex: selectedIndex,
                  ),
                ),
                 VerticalDivider(
                  color: Color.fromARGB(255, 187, 187, 187),
                  width: 0,), // Ajout du Divider vertical
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: _widgetOptions,
                  ),),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MenuDrawer extends StatelessWidget {
  final Function(int) onItemTapped;
  final int selectedIndex;
  
  const MenuDrawer({Key? key, required this.onItemTapped, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Drawer(
      child: Container(
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(
                
                  vertical:30),
                  decoration: BoxDecoration(
                  color: Color.fromARGB(255, 255, 255, 255),
                      
                    ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: DrawerHeader(
                        padding: EdgeInsets.only(left: 10 * 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                               
                               
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Administration RH",
                                      style: TextStyle(
                                         fontWeight: FontWeight.bold,
                                              color: Color.fromARGB(255, 73, 167, 226),
                                              fontSize: 16),
                                    ),
                                    
                                  ],
                                ),
                              ],
                          
                            ), 
                          ],
                        ),
                      ),
                    ),
                    SizedBox(),
                  
                    AccueLisTile(
                      title: "Tableau de bord",
                      imagePath: "assets/dashboard.png",
                      press: () {
                        onItemTapped(0);
                      },
                      isSelected: selectedIndex == 0,
                    ),
                    AccueLisTile(
                      title: "Employés",
                      imagePath: "assets/group.png",
                      press: () {
                        onItemTapped(1);
                      },
                      isSelected: selectedIndex == 1,
                    ),
                    AccueLisTile(
                      title: "Bulletins de soins",
                      imagePath: "assets/newspaper.png",
                      press: () {
                        onItemTapped(2);
                      },
                      isSelected: selectedIndex == 2,
                    ),
                    AccueLisTile(
                      title: "Valider membre",
                      imagePath: "assets/remb.png",
                      press: () {
                        onItemTapped(3);
                      },
                      isSelected: selectedIndex == 3,
                    ),
                   Spacer(),
                    AccueLisTile(
                      title: "Remboursements",
                      imagePath: "assets/health-insurance.png",
                      press: () {
                        onItemTapped(4);
                      },
                      isSelected: selectedIndex == 4,
                    ),
                   
                    AccueLisTile(
                      title: "Déconnexion",
                     imagePath: "assets/exit.png",
                      press: () {
                        _deconnexion(context); // Afficher la boîte de dialogue
                      },
                      isSelected: selectedIndex == 5,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _deconnexion(BuildContext context) {
    AwesomeDialog(
      width: 500,
      context: context,
      dialogType: DialogType.question,
      animType: AnimType.topSlide,
      title: 'Déconnexion',
      desc: 'Voulez-vous vraiment se déconnecter ?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
      },
      btnCancelText: "Annuler",
      btnCancelColor: Color.fromARGB(245, 170, 216, 231),
      btnOkText: "Oui",
      btnOkColor: Color(0xFF5BADE9),
    )..show();
  }
}


class AccueLisTile extends StatelessWidget {
  const AccueLisTile({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.press,
    required this.isSelected,
     this.imageWidth = 18, // Définir une valeur par défaut pour la largeur de l'image
    this.imageHeight = 18,
  }) : super(key: key);

  final String title;
  final String imagePath;
  final VoidCallback press;
  final bool isSelected;
   final double imageWidth; // Ajouter un paramètre pour la largeur de l'image
  final double imageHeight; // Ajouter un paramètre pour la hauteur de l'image

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: 45,
              decoration: isSelected ? BoxDecoration(
                color: Colors.blue.shade200,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ) : null,
            ),
          ),
          Container(
            height: 40,
            child: ListTile(
              visualDensity: VisualDensity(vertical: -4),
              dense: true,
              onTap: press,
              leading: Image.asset(imagePath,width: imageWidth, // Utiliser la largeur spécifiée
                height: imageHeight, ),
              title: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
     ),
);
}
}