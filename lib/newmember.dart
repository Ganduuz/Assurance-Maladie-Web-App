import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class FamilyMember {
  String id;
  String nom;
  String prenom;
  String dob;
  String type;
  String username ;

  FamilyMember({required this.id,required this.username,required this.nom, required this.prenom, required this.dob, required this.type});
factory FamilyMember.fromJson(Map<String, dynamic> json) {
    return FamilyMember(
      id:json['_id'],
      nom: json['nom'],
      prenom: json['prenom'],
      type: json['relation'],
      dob: json['naissance'],
      username:json ['username']
    );
  }
}
class NewMemberPage extends StatefulWidget {
  @override
  _NewMemberPageState createState() => _NewMemberPageState();
}

class _NewMemberPageState extends State<NewMemberPage> {
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  List<FamilyMember> familyMembers = [];

Future<void> _loadFamilyMembers() async {
  try {
    List<FamilyMember> members = await fetchFamilyMembers(); 
    setState(() {
      familyMembers = members; 
    });
  } catch (error) {
    print('Erreur lors du chargement des membres de la famille: $error');
  }
}


Future<List<FamilyMember>> fetchFamilyMembers() async {

  final response = await http.get(Uri.parse('http://127.0.0.1:5000/api/family-members_non'));
  
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
  _loadFamilyMembers();
}


void _deleteMember(String memberId,BuildContext context) async {
  try {
          final response = await http.delete(
      Uri.parse('http://127.0.0.1:5000/api/family-members/delete/$memberId'), 
      body: jsonEncode({  
      
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('Membre supprimé.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membre supprimé .'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Erreur lors de la mise supression du membre: ${response.statusCode}');
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
  }
}



void _validMember(String memberId,BuildContext context) async {
  try {
          final response = await http.put(
      Uri.parse('http://127.0.0.1:5000/api/family-members/validation/$memberId'), 
      body: jsonEncode({  
      
      }),
      headers: {
        'Content-Type': 'application/json'
      },
    );

    if (response.statusCode == 200) {
      print('Membre validé.');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Membre validé .'),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      print('Erreur lors de la validation du membre: ${response.statusCode}');
    }
  } catch (error) {
    // Gérer les erreurs de connexion
    print('Erreur de connexion: $error');
  }
}






  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.white,
   body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 20),
          


                SizedBox(height: 10),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 8,
                  ),
                  itemCount: familyMembers.length,
                  itemBuilder: (context, index) {
                    return  Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue.shade300),
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromRGBO(208, 230, 244, 0.804),
                    blurRadius: 20.0,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${familyMembers[index].username}",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade200,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 250, child: Text('${familyMembers[index].nom} ${familyMembers[index].prenom}')),
                        SizedBox(width: 250, child: Text('${familyMembers[index].type} ')),
                        SizedBox(width: 250, child: Text('Date de naissance : ${familyMembers[index].dob}')),
                         SizedBox(width: 250), 
                        IconButton(
                          onPressed: () {
                            _validerMembre(context, index,familyMembers[index]);
                          },
                          icon:Image.asset("assets/approve.png"),
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            _supprimerMembre(context, index,familyMembers[index]);
                          },
                          icon: Image.asset("assets/decline.png"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),);
                  },),
              
            ],
        ),
   ),
   ));

}
void _supprimerMembre(BuildContext context, int index,FamilyMember member) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          title: Text("Supprimer ?"),
          content: Container(
            width: 400,
            padding: const EdgeInsets.all(15.0),
            child: const Text(
              'Êtes-vous sûr de vouloir supprimer ce membre ?',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Non",
                style: TextStyle(
                  color: Color(0xFF5BADEE9),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteMember(member.id,context);
                setState(() {
                  familyMembers.removeAt(index); 
                });
                Navigator.of(context).pop(); 
              },
              child: Text(
                "Oui",
                style: TextStyle(
                  color: Color(0xFF5BADE9),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

void _validerMembre(BuildContext context, int index,FamilyMember member) {
    String id = member.id;
    _validMember(id, context);
    setState(() {
       familyMembers.removeAt(index); 
      });
  }



}
