import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'local_storage_service.dart';
import 'MonCompte.dart';
import 'actesMed.dart';
import 'BulletinsSoins.dart';
import 'Connexion.dart';
import 'contact.dart';
import 'membres_famille.dart';
class Accueil extends StatefulWidget {
  const Accueil({Key? key});

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  String _userName = '';
  String _userEmail = '';
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Appeler la fonction pour récupérer les données de l'utilisateur au démarrage de la page
    _getUserData();
  }

  Future<void> _getUserData() async {
    try {
      var user_id = LocalStorageService.getData('user_id');
      print("user_id :" + LocalStorageService.getData('user_id'));

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user'), // Change to post
        body: jsonEncode({'user_id': user_id}), // Add your body here
        headers: {
          'Content-Type': 'application/json'
        }, // Set appropriate headers
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print(data);
        setState(() {
          _userName = data ['nom+ prenom']?? '';
          _userEmail = data['mail']?? '';
        });
      } else {
        // Gérer les erreurs de réponse du serveur
        print(
            'Erreur de chargement des données utilisateur: ${response.statusCode}');
      }
    } catch (error) {
      // Gérer les erreurs de connexion
      print('Erreur de connexion: $error');
    }
  }

  static final List<Widget> _widgetOptions = <Widget>[
    Home(),
    MonCompte(),
    FamilyMemberPage(),
    BulletinsSoins(),
    actesMed(),
    contact(),
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
            margin: const EdgeInsets.only(right: 40),
            child: Row(
              children: [
                SizedBox(
                  width: 200,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const contact()),
                      );
                    },
                    style: ButtonStyle(
                      textStyle: MaterialStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        Colors.white,
                      ),
                      foregroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFF5BADE9),
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
                const SizedBox(width: 40),
                const Icon(Icons.notifications,
                    color: Color.fromARGB(255, 18, 171, 219)),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const Divider(color: Color(0xFF5BADE9)),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 300,
                  child: MenuDrawer(
                    userName: _userName,
                    userEmail: _userEmail,
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
  final String userName;
  final String userEmail;
  final Function(int) onItemTapped;

  const MenuDrawer(
      {Key? key,
      required this.userName,
      required this.userEmail,
      required this.onItemTapped});

  SizedBox _buildSizedImage(String imagePath) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Image.asset(imagePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            width: 300,
            color: const Color.fromARGB(255, 255, 255, 255),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  accountName: Text(
                    userName,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 115, 111, 110)),
                  ),
                  accountEmail: Text(
                    userEmail,
                    style: const TextStyle(
                        color: Color.fromARGB(255, 115, 111, 110)),
                  ),
                  currentAccountPicture: const CircleAvatar(
                    backgroundImage: AssetImage('assets/user.png'),
                  ),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: const Text('Accueil'),
            leading: _buildSizedImage('assets/home (1).png'),
            onTap: () {
              onItemTapped(0);
            },
          ),
          ListTile(
            title: const Text('Mon Compte'),
            leading: _buildSizedImage('assets/user (1).png'),
            onTap: () {
              onItemTapped(1);
            },
          ),
          ListTile(
            title: const Text('Membres de Famille'),
            leading: _buildSizedImage('assets/user (1).png'),
            onTap: () {
              onItemTapped(2);
            },
          ),
          ListTile(
            title: const Text('Mes bulletins de soins'),
            leading: _buildSizedImage('assets/newspaper (1).png'),
            onTap: () {
              onItemTapped(3);
            },
          ),
          ListTile(
            title: const Text('Actes Médicaux'),
            leading: _buildSizedImage('assets/insurance (1).png'),
            onTap: () {
              onItemTapped(4);
            },
          ),
           ListTile(
            title: const Text('Déconnexion'),
             leading: _buildSizedImage('assets/logout (1).png'),
            onTap: () {
              onItemTapped(5);
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
                                        builder: (context) => MyHomePage(),
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

class Home extends StatelessWidget {
  const Home({Key? key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Accueil'),
    );
  }
}
