import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class UserData extends ChangeNotifier {
  String _username = 'Nom d\'utilisateur par défaut';
  String _mail = 'email@exemple.com';
  String _profileImage = 'image_de_profil_par_defaut.png';

  String get username => _username;
  String get mail => _mail;
  String get profileImage => _profileImage;


    // Mettre à jour l'image de profil
 void updateUsername(String nouveauNom) {
    _username = nouveauNom;
    notifyListeners();
  }

  void updateEmail(String nouvelmail) {
    _mail = nouvelmail;
    notifyListeners();
  }

  void updateProfileImage(String nouvelleImage) {
    _profileImage = nouvelleImage;
    notifyListeners();
  }
}

class UserDataProvider extends ChangeNotifier {
  UserData _userData = UserData();

  UserData get userData => _userData;

  // Méthodes pour mettre à jour les données utilisateur
  void updateUsername(String nouveauNom) {
    _userData.updateUsername(nouveauNom);
  }

  void updateEmail(String nouvelmail) {
    _userData.updateEmail(nouvelmail);
  }

  void updateProfileImage(String nouvelleImage) {
    _userData.updateProfileImage(nouvelleImage);
  }
}


class MenuTile extends StatelessWidget {
  final String title;
  final String imagePath;
  final Function onTap;
  final bool isExpandable;
  final List<MenuTile> children;

  const MenuTile({
    Key? key,
    required this.title,
    required this.imagePath,
    required this.onTap,
    this.isExpandable = false,
    this.children = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Image.asset(
            imagePath,
            width: 24,
            height: 24,
          ),
          const SizedBox(width: 16),
          Text(title),
        ],
      ),
      onTap: onTap as void Function()?,
      // You can customize the expansion behavior based on your needs
      trailing: isExpandable ? Icon(Icons.expand_more) : null,
      tileColor: Colors.white,
    );
  }
}

class Accueil extends StatelessWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserDataProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            'assets/CapgeminiEngineering_82mm.png',
            width: 270,
            height: 250,
          ),
          actions: [
            Container(
              child: Row(
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
                  const SizedBox(width: 10),
                  const Icon(Icons.notifications, color: Color.fromARGB(255, 18, 171, 219)),
                ],
              ),
            ),
          ],
        ),
       body: Column(
          children: [
            const SizedBox(
              width: 2000,
              child: Divider(color: Colors.blue),
            ),
            Row(
              children: <Widget>[
                Container(
                  width: 300,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Consumer<UserDataProvider>(
                        builder: (context, userDataProvider, child) {
                          UserData userData = userDataProvider.userData;
                          return UserAccountsDrawerHeader(
                            accountName: Text(
                              userData.username,
                              style: TextStyle(color: const Color.fromARGB(255, 115, 111, 110)),
                            ),
                            accountEmail: Text(
                              userData.mail,
                              style: TextStyle(color: const Color.fromARGB(255, 115, 111, 110)),
                            ),
                            currentAccountPicture: CircleAvatar(
                              backgroundImage: AssetImage(userData.profileImage),
                            ),
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                            ),
                          );
                        },
                      ),

                      MenuTile(
                        title: 'Acceuil',
                        imagePath: 'assets/interface.png',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12.0),
                     MenuTile(
                      title: 'Mon Compte',
                      imagePath: 'assets/user (1).png',
                     
                      onTap: () {},
                      isExpandable: true,
                      children: [
                        MenuTile(
                          title: 'Informations personnelles',
                          imagePath: 'assets/criteria.png',
                          
                          onTap: () {
                            
                          },
                        ),
                        MenuTile(
                          title: 'Sécurité',
                        
                          imagePath: 'assets/personal-data.png',
                          onTap: () {},
                        ),
                      ],
                    ),

                      const SizedBox(height: 12.0),
                      MenuTile(
                        title: 'Mes Bulletins de Soins',
    
                        imagePath: 'assets/newspaper (1).png',
                        onTap: () {},
                      ),
                      const SizedBox(height: 12.0),
                      MenuTile(
                        title: 'Actes Médicaux',
   
                        imagePath: 'assets/insurance (1).png',
                        onTap: () {},
                      ),
                      const SizedBox(height: 15.0),
                      MenuTile(
                        title: 'Déconnexion',
                      
                        imagePath: 'assets/logout (1).png',
                        onTap: () {
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
                                    child: const Text('Annuler'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      // Handle logout logic here
                                    },
                                    child: const Text('Déconnexion'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: const Center(
                      child: Text('Contenu principal'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
     home: ChangeNotifierProvider<UserDataProvider>(
      create: (context) => UserDataProvider(),
      child: Accueil(),
    ),
    ),
  );
}
