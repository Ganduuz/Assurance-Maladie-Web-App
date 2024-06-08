import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'moncompte.dart';
import 'actesMed.dart';
import 'BulletinsSoins.dart';
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
  String image='';
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
    _getUserData();
    _getUserImage();
    _loadFamilyMembers(); 
    number=0;
    _calculateNotifications();

  }


  Future<void> _getUserImage() async {
  try {
    var userId = LocalStorageService.getData('user_id');
    final response = await http.post(
      Uri.parse('http://127.0.0.1:5000/api/user/get-image'),
      body: jsonEncode({'user_id': userId}),
      headers: {'Content-Type': 'application/json'},
    );
    if (response.statusCode == 200) {
      // Les données binaires de l'image sont directement dans la réponse, donc pas besoin de décoder le JSON
final data = jsonDecode(response.body);      
      setState(() {
        // Convertir les données binaires en widget Image
        image = data['_imageUrl'];
      });
    } else {
      print('Erreur lors de la récupération de l\'image: ${response.statusCode}');
    }
  } catch (error) {
    print('Erreur de connexion: $error');
  }
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
      right: 20,
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
    List<Widget> _widgetOptions = [
    Home(),     
    FamilyMemberPage(),
    bs(),
    remb(),
    ActesMed(),
    const MonCompte(),
  ];
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
                ),
                Container(width: 10),

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
                    imagee: image,
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
  final String imagee;
  final Function(int) onItemTapped;
  final int selectedIndex;
static const double defaultPadding = 5.0;

  const MenuDrawer({super.key, required this.userEmail,required this.imagee,  required this.userName,required this.onItemTapped, required this.selectedIndex});

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
                                CircleAvatar(
                                  backgroundImage: NetworkImage(imagee),
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
                      imagePath: "assets/home.png",
                      press: () {
                        onItemTapped(0);
                      },
                      isSelected: selectedIndex == 0,
                    ),
                    AccueLisTile(
                      title: "Membre de famille",
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
                      title: "Mes remboursements ",
                      imagePath: "assets/remb.png",
                      press: () {
                        onItemTapped(3);
                      },
                      isSelected: selectedIndex == 3,
                    ),
                   
                    AccueLisTile(
                      title: "Annuaires santé",
                      imagePath: "assets/health-insurance.png",
                      press: () {
                        onItemTapped(4);
                      },
                      isSelected: selectedIndex == 4,
                    ),
                    Spacer(),
                    AccueLisTile(
                      title: "Mon compte",
                      imagePath: "assets/monCompte.png",
                      press: () {
                        onItemTapped(5);
                      },
                      isSelected: selectedIndex == 5,
                    ),
                    AccueLisTile(
                      title: "Déconnexion",
                     imagePath: "assets/exit.png",
                      press: () {
                        _deconnexion(context); // Afficher la boîte de dialogue
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



class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _userprenom='';

  @override
  void initState() {
    super.initState();
    _getUsername();
  }

  Future<void> _getUsername() async {
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
          _userprenom=data['userprenom']?? '';
         
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


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Row(
          
          children: <Widget>[
            Expanded(
              child: Container(
                height: screenHeight * 0.8,
                width: screenWidth * 0.5,
                padding: const EdgeInsets.all(50.0),
                child: Column(
                  
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                                        SizedBox(height: 50),

                    Text(
                      'Bonjour $_userprenom !',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 40),
                    Text(
                      'Notre assurance maladie va au-delà de la simple couverture : elle incarne la tranquillité d\'esprit, la sécurité financière et la garantie d\'un avenir en bonne santé pour vous et vos proches.',
                      style: TextStyle(
                        color: Colors.grey[700], // Couleur moderne
                      ),
                    ),
                    SizedBox(height: 100),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blue.shade300),
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(208, 230, 244, 0.804),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Accessibilité accrue",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 5),
                        Expanded(
                          child: Container(
                            height: 40,
                            width: 150,
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.blue.shade300),
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(208, 230, 244, 0.804),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                "Suivi en temps réel",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              child: Image.asset(
                "assets/assurance_home.jpg",
                height: screenHeight * 0.8,
                width: screenWidth * 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}