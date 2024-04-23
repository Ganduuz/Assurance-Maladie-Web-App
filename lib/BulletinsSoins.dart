import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'dart:html' as html;
import 'BSAdmin.dart';

class Bulletins_Soins {
  String Num;
  String ID;
  String Qui_est_malade;
  String nom_medecin;
  String spec_medecin;
  String DateConsultation;
  String piece_jointe;

  Bulletins_Soins({
    required this.Num,
    required this.ID,
   required this.Qui_est_malade,
    required this.nom_medecin,
    required this.spec_medecin,
    required this.DateConsultation,
    required this.piece_jointe,
  });
}

class bs extends StatefulWidget {
  const bs({super.key});

  @override
  _bsState createState() => _bsState();
}

class _bsState extends State<bs> {
  List<Bulletins_Soins> buso = [];
  int _currentPage = 0;
  int _busoPerPage = 6;
  String _searchText = ''; // État local pour stocker le texte de recherche
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now(); // Ajout de _selectedDay pour stocker la date sélectionnée
  String? selectedMalade;
  List<Bulletins_Soins> get _filteredbuso {
    return buso.where((bs) => bs.Num.toLowerCase().contains(_searchText.toLowerCase()) ||
           bs.Qui_est_malade.toLowerCase().contains(_searchText.toLowerCase()) ||
           bs.ID.toLowerCase().contains(_searchText.toLowerCase()) ||
           bs.DateConsultation.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  List<Bulletins_Soins> get _currentbuso {
    final startIndex = _currentPage * _busoPerPage;
    final endIndex = (_currentPage + 1) * _busoPerPage;
    return _filteredbuso.sublist(
        startIndex, endIndex.clamp(0, _filteredbuso.length));
  }

  // Méthode pour mettre à jour le texte de recherche
  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }
   void _addBulletinToBothTables(String id, String malade, String medecin, String specialite, String date, String pieceJointe) {
    setState(() {
      buso.add(Bulletins_Soins(
        Num: (buso.length + 1).toString(),
        ID: id,
        Qui_est_malade: malade,
        nom_medecin: medecin,
        spec_medecin: specialite,
        DateConsultation: date,
        piece_jointe: pieceJointe,
      ));

      // Vous devrez implémenter la logique pour ajouter également à BSAdminDatabase ici
    });
  }

  @override
  Widget build(BuildContext context) {
    html.document.title = 'Capgemini Assurance';

    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(100),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      'Mes bulletins de soins ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(10),
                  width: 200,
                  height: 35,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Recherche',
                      contentPadding: const EdgeInsets.fromLTRB(5, 0, 7, 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.blue.shade300, width: 2.0),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.search),
                        onPressed: () {
                          print("Effectuer la recherche avec le texte: $_searchText");
                        },
                      ),
                    ),
                    onChanged: _updateSearchText, // Mettre à jour le texte de recherche lors de la saisie
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _showAddBulletinDialog(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Row(
                  children: [
                  Icon(Icons.add,color: Colors.white,),
                  SizedBox(width: 5),
                  Text(
                    'Nouveau bulletin de soins',
                     style: TextStyle(color: Colors.white, fontFamily: 'Istok web'),
                  ),
                 ],
                ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Container(
              margin: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: const Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
        offset: const Offset(0, 2), // Changez l'offset selon votre préférence
      ),
    ],
              ),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color:Colors.grey,
                          width: 0.5,
                        ),
                      ),
                    ),
                    children: [
                      tableHeader("N° Bulletin"),
                      tableHeader("ID Bulletin"),
                      tableHeader("Qui est malade"),
                      tableHeader("Nom médecin"),
                      tableHeader("Spécialité médecin"),
                      tableHeader("Date de consultation"),
                      tableHeader("Pièce jointe"),
                      tableHeader(""),
                    ],
                  ),
                  ..._currentbuso.map((bs) {
                    return TableRow(
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: Color.fromARGB(255, 193, 191, 191),
                            width: 0.3,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.Num),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.ID),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.Qui_est_malade),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.nom_medecin),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.spec_medecin),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.DateConsultation),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              const SizedBox(width: 10,),
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    if (bs.piece_jointe.isNotEmpty) {
                                      if (bs.piece_jointe.startsWith('http')) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: Center(
                                                child: Image.network(bs.piece_jointe),
                                              ),
                                            ),
                                          ),
                                        );
                                      } else {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => Scaffold(
                                              body: Center(
                                                child: Image.network((bs.piece_jointe)),
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: bs.piece_jointe.isNotEmpty ? const Text('Ouvrir', style: TextStyle(decoration: TextDecoration.underline ,decorationColor: Colors.blue, color: Colors.blue)) : const Text('Aucune pièce jointe'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: const Icon(Icons.delete,color: Colors.red,),
                                  onPressed: () {
                                    _archiverBulletinsSoins(bs);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
            ),
            Container(
             margin: const EdgeInsets.all(5),
             padding: const EdgeInsets.all(5),
               decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: const Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
        offset: const Offset(0, 2), // Changez l'offset selon votre préférence
      ),
    ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    onPressed: _currentPage > 0 ? () => setState(() => _currentPage--) : null,
                    icon: Icon(Icons.chevron_left,color: Colors.blue.shade300,size: 18,),
                  ),
                  Text("Page ${_currentPage + 1} de ${(_busoPerPage > 0) ? (buso.length / _busoPerPage).ceil() : 1}"),
                  IconButton(
                    onPressed: _currentPage < (buso.length / _busoPerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
                    icon: Icon(Icons.chevron_right,color: Colors.blue.shade300,size: 18,),
                  ),
                  const SizedBox(width: 20),
                  DropdownButton<int>(
                    value: _busoPerPage,
                    underline: const SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        _busoPerPage = value!;
                      });
                    },
                    items: [6, 10, 20, 50].map((value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(' $value '),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget tableHeader(String text) {
    return Container(
      
      height: 60,
      color: const Color.fromARGB(200, 236, 235, 235),
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showAddBulletinDialog(BuildContext context) {
    String quiEstMalade='';
    String ID = '';
    String nomMedecin='';
    String specMedecin='';
    String pieceJointe = '';
    int nextBulletinNumber = buso.length + 1;
    String nextBulletinNumberString = nextBulletinNumber.toString();
    List listee =['Enfant1','Enfant2','Conjoint'];
    _selectedDay = DateTime.now();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            width: 750,
            height: 650,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(5),
              color: Colors.white,
            ),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Nouveau Bulletin",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                const SizedBox(height: 30,),
                TextField(
                  onChanged: (value) => ID= value,
                  style: const TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'ID bulletin',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                Container(
                  padding: const EdgeInsets.only(left: 16,right: 16),
                  decoration: BoxDecoration(border: Border.all(color: Colors.grey,width: 1),
                  borderRadius: BorderRadius.circular(5),),
                
                child : DropdownButton(
                hint: const Text("Qui est malade ?"),
                icon: const Icon(Icons.arrow_drop_down),
                underline: const SizedBox(),
                dropdownColor: Colors.white,
                isExpanded: true,
                style: const TextStyle(color: Color.fromRGBO(209, 216, 223, 1),fontSize: 18),
                items: listee.map((name) {
                return DropdownMenuItem(value: name, child: Text(name));
              }).toList(),
              onChanged: (selectedValue) {
             setState(() {
               quiEstMalade = selectedValue as String;
             });
              },
             ),),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => nomMedecin= value,
                  style: const TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Nom du médecin',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                
                const SizedBox(height: 20),
                TextField(
                  onChanged: (value) => specMedecin= value,
                  style: const TextStyle(fontSize: 18.0, fontFamily: 'Arial'),
                  decoration: InputDecoration(
                    labelText: 'Spécialité du médecin',
                    labelStyle: const TextStyle(
                      color: Color.fromRGBO(209, 216, 223, 1),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
               children: [ IconButton(
                  onPressed: (){
                    buildCalendarWidget(context);
                  },
                  icon: const Icon(
                    Icons.calendar_month,
                    color: Colors.blue,
                  ),
                ),
                const Text('Date de consultation',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),),],),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
                    uploadInput.click();
                    uploadInput.onChange.listen((e) {
                      final files = uploadInput.files;
                      if (files!.length == 1) {
                        final file = files[0];
                        final reader = html.FileReader();
                        reader.readAsDataUrl(file);
                        reader.onLoadEnd.listen((event) {
                          setState(() {
                            // Convertir les données de l'image en une chaîne base64
                            pieceJointe = reader.result as String;
                          });
                        });
                      }
                    });
                  } ,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: Color.fromARGB(255, 3, 171, 243)),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  child: const Text(
                    'Importer votre bulletin de soins',
                    style: TextStyle(color: Color.fromARGB(255, 28, 28, 28), fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 141, 142, 142),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text(
                        'Annuler',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          buso.add(Bulletins_Soins(
                            Num: nextBulletinNumberString,
                            ID: ID,
                            Qui_est_malade: quiEstMalade,
                            nom_medecin: nomMedecin,
                            spec_medecin: specMedecin,
                            DateConsultation: DateFormat('dd/MM/yyyy').format(_selectedDay), // Utilisation de la date sélectionnée
                            piece_jointe: pieceJointe,
                          ));
                        });
                        Navigator.of(context).pop(); // Fermer la boîte de dialogue
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                      child: const Text(
                        'Ajouter',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

   
  void _archiverBulletinsSoins(Bulletins_Soins bulletinsSoins) {
    int index = buso.indexOf(bulletinsSoins); // Trouver l'indice de l'objet dans la liste
  if (index != -1) { // Vérifier si l'objet a été trouvé
  AwesomeDialog(
    width: 500,
    
    context: context,
    dialogType: DialogType.question,
    animType: AnimType.topSlide,
    title: 'Supprimer ?',
    desc: 'Êtes-vous sûr de vouloir supprimer ce membre ?',
    btnCancelOnPress: () {},
    btnOkOnPress: () {
      setState(() {
        buso.removeAt(index); // Supprimer le membre
      });
      
    },
    btnCancelText: "Non",
    btnCancelColor: const Color(0xff5badee9),
    btnOkText: "Oui",
    btnOkColor: const Color(0xFF5BADE9),
    
  ).show();
  }}

  void buildCalendarWidget(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              child: SizedBox(
                height: 380,
                width: 380,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      TableCalendar(
                        focusedDay: _focusedDay,
                        firstDay: DateTime.utc(1950),
                        lastDay: DateTime.utc(2100),
                        rowHeight: 35,
                        daysOfWeekStyle: const DaysOfWeekStyle(
                          weekdayStyle: TextStyle(fontWeight: FontWeight.w400),
                          weekendStyle:TextStyle(fontWeight: FontWeight.w400),
                        ),
                        onDaySelected: (DateTime selectDay,DateTime focusDay) {
                          setState(() {
                            _selectedDay=selectDay;
                            _focusedDay=focusDay;
                            
                          });
                        },
                        headerStyle: const HeaderStyle(formatButtonVisible: false, titleCentered: true),
                        calendarStyle:CalendarStyle(
                          isTodayHighlighted: true,
                          selectedDecoration: BoxDecoration(
                            color: Colors.blue.shade200,
                            shape: BoxShape.circle,
                          ),
                          todayDecoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          selectedTextStyle: const TextStyle(color: Colors.white),
                        ) ,
                        selectedDayPredicate: (DateTime date) {
                          return isSameDay(_selectedDay, date);
                        },
                      ),
                      const SizedBox(height: 10,),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(child: TextButton(
                            onPressed: () {
                              Navigator.pop(context, _selectedDay);
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: Colors.blue.shade300),
                            ),
                          ),),
                          const SizedBox(),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Annuler",
                              style: TextStyle(color: Colors.blue.shade300),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
  },
);
}
}