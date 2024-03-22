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
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
     const HomeAdmin(),
     dashboard(),
     const BSAdmin(),
     const employee(),
     const newmember(),

   
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/CapgeminiEngineering_82mm.png',
          width: 220,
          height: 180,
        ),
       actions: [
          Container(
             margin: const EdgeInsets.only(right: 40),//marge notif et contactez-nous
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                ),
                const SizedBox(width: 40),
                const Icon(Icons.notifications, color: Color.fromARGB(255, 18, 171, 219)),
              ],
            ),
          ),
        ],
      ),
     body: Column( // Utilisation d'une colonne pour ajouter le Divider sous l'appBar
        children: [
          const Divider(color: Color(0xFF5BADE9)),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: MenuDrawer(
                    onItemTapped: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                  ),
                ),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
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

  const MenuDrawer({super.key, required this.onItemTapped});
  //fonction taille image
SizedBox _buildSizedImage(String imagePath) {
  return SizedBox(
    width: 24, // Remplacez ces valeurs par les dimensions souhaitées
    height: 24,
    child: Image.asset(imagePath),
  );
}

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white, // Couleur de fond blanche
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
                width: 300,
                color: Color.fromARGB(255, 255, 255, 255),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    UserAccountsDrawerHeader(
                      accountName: Text(
                        'Administartion RH',
                        style: TextStyle(color: Color.fromARGB(255, 115, 111, 110)),
                      ),
                      accountEmail: Text(
                        '',
                        style: TextStyle(color: Color.fromARGB(255, 115, 111, 110)),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage: AssetImage('assets/user.png'),
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ],
                  ),
          ),
         
          ListTile(
            title: const Text('Tableau de bord'),
             leading: _buildSizedImage('assets/home (1).png'),
            onTap: () {
              onItemTapped(0);
             
            },
          ),
          ListTile(
            title: const Text('Liste des employés'),
            leading: _buildSizedImage('assets/user (1).png'),
            onTap: () {
              onItemTapped(1);
             
            },
    
          ),
          ListTile(
            title: const Text('Bulletins de soins employés '),  
            leading: _buildSizedImage('assets/newspaper (2).png'),
            onTap: () {
              onItemTapped(2);
          
            },
          ),
          ListTile(
            title: const Text(' Nouveau membre'),
             leading: _buildSizedImage('assets/insurance.png'),
            onTap: () {
              onItemTapped(3);
            
            },
          ),
           ListTile(
            title: const Text('Déconnexion'),
             leading: _buildSizedImage('assets/logout (1).png'),
            onTap: () {
              onItemTapped(4);
              showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
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
                                  child: const Text('Annuler',
                                  style: TextStyle(
                                     color: Color(0xFF5BADE9)),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>  MyHomePage(),
                                      ),
                                    );
                                  },
                                  child: const Text('Déconnexion',
                                  style:TextStyle(
                                    color: Color(0xFF5BADE9)
                                  ),),
                                ),
                              ],
                            ); 
                      },
                    );
          },
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
