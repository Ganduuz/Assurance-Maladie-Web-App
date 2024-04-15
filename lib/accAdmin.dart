import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'employé.dart';
import 'BSAdmin.dart';
import 'connexion.dart';
import 'newmember.dart';

class AccueilAdmin extends StatefulWidget {
  const AccueilAdmin({super.key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<AccueilAdmin> {
  int selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
     const HomeAdmin(),
     const dashboard(),
      Employeee(),
     const BSAdmin(),
     const newmember(),

   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Image.asset(
          'assets/CapgeminiEngineering_82mm.png',
          width: 220,
          height: 220,
        ),
        actions: [
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                         Color.fromARGB(255, 73, 167, 226),
                      ),
                    ),
                    child: const Text(
                      'Contactez-nous',
                      style: TextStyle(
                        fontFamily: 'inter-bold',
                      ),
                    ),
                  ),
                ),
                 SizedBox(width: 40),
                Icon(Icons.notifications, color: Color.fromARGB(255, 18, 171, 219)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
         
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: MenuDrawer(
                    onItemTapped: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    selectedIndex: selectedIndex,
                  ),
                ),
                Expanded(
                  child: IndexedStack(
                    index: selectedIndex,
                    children: _widgetOptions,
                  ),
                ),
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
static const double defaultPadding = 5.0;

  const MenuDrawer({Key? key, required this.onItemTapped, required this.selectedIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(defaultPadding * 1.2),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                height: height,
                padding: EdgeInsets.symmetric(
                    horizontal: defaultPadding,
                    vertical: defaultPadding * 3),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                    borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: DrawerHeader(
                        padding:
                            EdgeInsets.only(left: defaultPadding * 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                
                                SizedBox(width: defaultPadding),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      "Administration RH",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline6
                                          ?.copyWith(
                                              color: Color.fromARGB(255, 73, 167, 226),
                                              fontSize: 16),
                                    ),
                                    
                                  ],
                                ),
                              ],
                          
                            ), Expanded(
              flex: 4,
              child: Container(),),
                          ],
                        ),
                      ),
                    ),
          SizedBox(height: 8,),
          AccueLisTile(
            title: "Accueil",
            icon: Icon(Icons.home),
            press: () {
              onItemTapped(0);
            },
            isSelected: selectedIndex == 0,
          ),
          AccueLisTile(
            title: "Tableau de bord",
            icon: Icon(Icons.dashboard),
            press: () {
              onItemTapped(1);
            },
            isSelected: selectedIndex == 1,
          ),
          AccueLisTile(
            title: "Employés",
            icon: Icon(Icons.man),
            press: () {
              onItemTapped(2);
            },
            isSelected: selectedIndex == 2,
          ),
          AccueLisTile(
            title: "Bulletins de soins",
            icon: Icon(Icons.newspaper),
            press: () {
              onItemTapped(3);
            },
            isSelected: selectedIndex == 3,
          ),
          Spacer(),
          AccueLisTile(
            title: "Nouveau membre ",
            icon: Icon(Icons.man),
            press: () {
              onItemTapped(4);
            },
            isSelected: selectedIndex == 4,
          ),
        AccueLisTile(
  title: "Déconnexion",
  icon: Icon(Icons.logout),
  press: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: const Text('Déconnexion'),
          content: Container(
            width: 400,
            padding: const EdgeInsets.all(15.0),
            child: const Text('Voulez-vous vous déconnecter?'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Annuler',
                style: TextStyle(color: Color(0xFF5BADE9)),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyHomePage(), // Supprimez 'const' ici
                  ),
                );
              },
              child: const Text(
                'Déconnexion',
                style: TextStyle(color: Color(0xFF5BADE9)),
              ),
            ),
          ],
        );
      },
    );
  },
  isSelected: selectedIndex == 5,
),
        ],
      ),
      ),
      ),],
      ),
      ),
    );
  }
}

class AccueLisTile extends StatelessWidget {
  const AccueLisTile({
    Key? key,
    required this.title,
    required this.icon,
    required this.press,
    required this.isSelected,
  }) : super(key: key);

  final String title;
  final Icon icon;
  final VoidCallback press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              height: 50,
              decoration: isSelected ? BoxDecoration(
                color: Color.fromARGB(255, 73, 167, 226),
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
              leading: icon,
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
class HomeAdmin extends StatelessWidget {
  const HomeAdmin({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Accueil'),
);
}
}