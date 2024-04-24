import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'moncompte.dart';
import 'actesMed.dart';
import 'BulletinsSoins.dart';
import 'contact.dart';
import 'membres_famille.dart';
import 'connexion.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'local_storage_service.dart';
import 'dart:html' as html; 
import 'remboursement.dart';


class Accueil extends StatefulWidget {
  const Accueil({super.key});
  

  @override
  _AccueilState createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
late OverlayEntry _overlayEntry;
double _reste=0;
int initialNumberOfNotifications = 0; // Définir le nombre initial de notifications

  int selectedIndex = 0;
   String _userName = '';
  String _userEmail = '';
  List<FamilyMember> familyMembers = [];
  List<Widget> alertWidgets = [];
  int number=0;

Future<void> _loadFamilyMembers() async {
  try {
    List<FamilyMember> members = await fetchFamilyMembers(); 
    setState(() {
      familyMembers = members; 
      _calculateNotifications();
    });
  } catch (error) {
   
    print('Erreur lors du chargement des membres de la famille: $error');
  }
}

Future<List<FamilyMember>> fetchFamilyMembers() async {
  var userId = LocalStorageService.getData('user_id');

  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/family-members/$userId'));
  
  if (response.statusCode == 200) {
    // Analyser la réponse JSON
    final jsonData = jsonDecode(response.body);
    final List<dynamic> membersJson = jsonData['membersDetails'];
    
    // Convertir les données JSON en liste d'objets FamilyMember
    List<FamilyMember> familyMembers = membersJson.map((json) => FamilyMember.fromJson(json)).toList();
    
    return familyMembers;
  } else {
    // En cas d'erreur, lancer une exception
    throw Exception('Failed to load family members');
  }
}


 @override
  void initState() {
    super.initState();
    // Appeler la fonction pour récupérer les données de l'utilisateur au démarrage de la page
    _getUserData();
    _loadFamilyMembers(); 
    number=0;
    _calculateNotifications();

  }

Future<void> _getUserData() async {
    try {
      var userId = LocalStorageService.getData('user_id');
      print("user_id :" + LocalStorageService.getData('user_id'));

      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/user'), 
        body: jsonEncode({'user_id': userId}), 
        headers: {
          'Content-Type': 'application/json'
        }, 
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _userName = data['username'] ?? '';
          _userEmail = data['mail']?? ''; 
          _reste=data['reste']??'';    
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
    const Home(),
    FamilyMemberPage(),
      bs(),
     remb(),
     const actesMed(),
    const MonCompte(),
   
  ];


void updateNumber(int newNumber) {
  setState(() {
    number = newNumber;
  });
}
  

  void _showAlerts(BuildContext context, double reste, Function(int) updateNumber)  {

    void removeOverlay() {
      _overlayEntry.remove();
    }

    bool employeeAlert = reste < 100;
    int numberOfNotifications = 0;
    
    for (var member in familyMembers) {
      if (member.alert) {
        numberOfNotifications++;
      }
    }
    
    if (employeeAlert) {
      numberOfNotifications++;
    }
    
  _overlayEntry = OverlayEntry(
    builder: (BuildContext context) => Positioned(
      top: MediaQuery.of(context).padding.top + kToolbarHeight + 10,
      right: 10,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(width: 2, color: Color.fromARGB(255, 91, 177, 248)),
        ),
        color: Colors.white,
        child: Container(
          width: 350,
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    "Alertes",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 210),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: removeOverlay,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (employeeAlert)
                ListTile(
                  leading: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Dépassement de seuil",
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 190, 237),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "pour vous : ",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: _userName,
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${reste.toStringAsFixed(2)} DT",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ...familyMembers
                  .where((member) => member.alert)
                  .map((member) {
                return ListTile(
                  leading: const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  title: const Text(
                    "Dépassement de seuil",
                    style: TextStyle(
                      color: Color.fromARGB(255, 35, 190, 237),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "pour votre ${member.type} : ",
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: "${member.nom} ${member.prenom}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "${member.reste.toStringAsFixed(2)} DT",
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              if (familyMembers.every((member) => !member.alert))
                const Text(
                  "Aucune alerte",
                  style: TextStyle(
                    color: Colors.grey,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ),
    ),
  );
 updateNumber(numberOfNotifications);

  Overlay.of(context).insert(_overlayEntry);
}
void _calculateNotifications() {
  int notifications = 0;
  for (var member in familyMembers) {
    if (member.alert) {
      notifications++;
    }
  }
if (_reste<100){
  setState(() {
notifications++;  });
}
  setState(() {
    number = notifications;
  });

  print(number);
}

  @override
  Widget build(BuildContext context) {
    html.document.title = 'Capgemini Assurance';

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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const contact()), // Navigation vers Acceuil
                      );
                    },
                    style: ButtonStyle(
                      textStyle: WidgetStateProperty.all<TextStyle>(
                        const TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all<Color>(
                        const Color.fromARGB(255, 255, 255, 255),
                      ),
                      foregroundColor: WidgetStateProperty.all<Color>(
                         const Color.fromARGB(255, 73, 167, 226),
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
                const SizedBox(width: 30,),
                 IconButton(
  onPressed: () {
    _showAlerts(context, _reste, updateNumber);
  },
  icon: Stack(
    children: [
      Transform.scale(
        scale: 1.5, // Facteur d'échelle pour agrandir l'icône
        child: const Icon(Icons.notifications, color: Color(0xFF12ABDB)), // Icône de la cloche
      ),
      if (number > 0) // Ajout d'une condition 'if' pour afficher le badge uniquement si le nombre de notifications est supérieur à zéro
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Colors.red, // Couleur de l'arrière-plan du badge
              shape: BoxShape.circle,
            ),
            child: Text(
              number.toString(), // Nombre de notifications converti en chaîne
              style: const TextStyle(
                color: Colors.white, // Couleur du texte du badge
                fontSize: 12, // Taille du texte du badge
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
    ],
  ),
)

              ],
            ),
          ),
        ],
      ),
      body: Column(
        
        children: [
         Divider(color: Color(0xFF5BADE9),),
          Expanded(
            child: Row(
              children: [
                SizedBox(
                  width: 250,
                  child: MenuDrawer(
                    userName: _userName,
                    userEmail: _userEmail,
                    onItemTapped: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    selectedIndex: selectedIndex,
                  ),
                ),
                VerticalDivider(
                  color: Colors.grey.shade100,
                  width: 0.5,
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
  final String userName;
  final String userEmail;
  final Function(int) onItemTapped;
  final int selectedIndex;
static const double defaultPadding = 5.0;

  const MenuDrawer({super.key, required this.userEmail,  required this.userName,required this.onItemTapped, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
            backgroundColor: Colors.white,

      body: Container(
        padding: const EdgeInsets.all(defaultPadding * 1.2),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Container(
                height: height,
                padding: const EdgeInsets.symmetric(
                 
                    vertical: 30),
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: 100,
                      child: DrawerHeader(
                        padding:
                            const EdgeInsets.only(left: 10 * 1.5),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const CircleAvatar(
                                  backgroundImage: AssetImage("assets/user (1).png"),
                                  radius: 20,
                                ),
                                const SizedBox(width: defaultPadding),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      userName,
                                      style: const TextStyle(
                                              color: Color.fromARGB(255, 73, 167, 226),
                                              fontSize: 16)
                                    ),
                                    Text(
                                      userEmail,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                          
                            ),
                          ],
                        ),
                      ),
                    ),
          const SizedBox(),
          AccueLisTile(
            title: "Accueil",
            icon: const Icon(Icons.home),
            press: () {
              onItemTapped(0);
            },
            isSelected: selectedIndex == 0,
          ),
          AccueLisTile(
            title: "Membre de famille",
            icon: const Icon(Icons.verified_user_sharp),
            press: () {
              onItemTapped(1);
            },
            isSelected: selectedIndex == 1,
          ),
          AccueLisTile(
            title: "Bulletins de soins",
            icon: const Icon(Icons.newspaper),
            press: () {
              onItemTapped(2);
            },
            isSelected: selectedIndex == 2,
          ),
           AccueLisTile(
            title: "Mes remboursements",
            icon: const Icon(Icons.newspaper),
            press: () {
              onItemTapped(3);
            },
            isSelected: selectedIndex == 3,
          ),
          AccueLisTile(
            title: "Actes médicaux",
            icon: const Icon(Icons.local_hospital),
            press: () {
              onItemTapped(4);
            },
            isSelected: selectedIndex == 4,
          ),
          const Spacer(),
          AccueLisTile(
            title: "Mon compte",
            icon: const Icon(Icons.account_box),
            press: () {
              onItemTapped(5);
            },
            isSelected: selectedIndex == 5,
          ),
           AccueLisTile(
            title: "Déconnexion",
            icon: const Icon(Icons.logout),
            press: () {
            _deconnexion(context);
            },
            isSelected: selectedIndex == 6,
          ),

        ],
      ),
      ),
      ),],
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
    super.key,
    required this.title,
    required this.icon,
    required this.press,
    required this.isSelected,
  });

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
              height: 45,
              decoration: isSelected ? const BoxDecoration(
                color: Color.fromARGB(255, 73, 167, 226),
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ) : null,
            ),
          ),
          SizedBox(
            height: 40,
            child: ListTile(
              visualDensity: const VisualDensity(vertical: -4),
              dense: true,
              onTap: press,
              leading: icon,
              title: Text(
                title,
                style: const TextStyle(
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
class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(padding: const EdgeInsets.fromLTRB(80.0, 50.0, 250.0, 0),),
      ),
    );
}
}