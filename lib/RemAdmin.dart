import 'package:flutter/material.dart';

class remboursement {
  String Num;
  String ID;
  String Qui_est_malade;
  String Frais;
  String remboursements;
  String DateRemboursement;
  String decision;

  remboursement({
    required this.Num,
    required this.ID,
    required this.Qui_est_malade,
    required this.Frais,
    required this.remboursements,
    required this.DateRemboursement,
    required this.decision,
  });
}

class remb extends StatefulWidget {
  @override
  _rembState createState() => _rembState();
}

class _rembState extends State<remb> {
  List<remboursement> rembourse = [];
  int _currentPage = 0;
  int _remboursePerPage = 6;
  String _searchText = ''; // État local pour stocker le texte de recherche
  String? selectedMalade;
  List<remboursement> get _filteredrembourse {
    return rembourse.where((remb) => remb.Num.toLowerCase().contains(_searchText.toLowerCase()) ||
           remb.Qui_est_malade.toLowerCase().contains(_searchText.toLowerCase()) ||
           remb.ID.toLowerCase().contains(_searchText.toLowerCase()) ||
           remb.DateRemboursement.toLowerCase().contains(_searchText.toLowerCase())).toList();
  }

  List<remboursement> get _currentrembourse {
    final startIndex = _currentPage * _remboursePerPage;
    final endIndex = (_currentPage + 1) * _remboursePerPage;
    return _filteredrembourse.sublist(
        startIndex, endIndex.clamp(0, _filteredrembourse.length));
  }

  // Méthode pour mettre à jour le texte de recherche
  void _updateSearchText(String value) {
    setState(() {
      _searchText = value;
    });
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
    backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      'Mes remboursements ',
                        style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                  ),
                ),
 Container(
      width: 200,
      height: 35,
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Recherche',
          contentPadding: EdgeInsets.fromLTRB(5, 0, 7, 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue.shade300, width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          suffixIcon: Tooltip(
            message: 'Rechercher',
            child: IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
              },
            ),
          ),
        ),
        onChanged: 
         _updateSearchText,
        
      ),
    ),
                
              ],
            ),
            SizedBox(height: 40),
            Container(
              margin: EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: Offset(0, 2), // Changez l'offset selon votre préférence
                ),
               ],
              ),
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(
                    decoration: BoxDecoration(
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
                      tableHeader("Malade"),
                      tableHeader("Frais"),
                      tableHeader("Remboursement"),
                      tableHeader("Date de remboursement"),
                      tableHeader("Décision"),
                      tableHeader("Imprimer"),
                    ],
                  ),
                  ..._currentrembourse.map((bs) {
                    return TableRow(
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(
                            color: const Color.fromARGB(255, 193, 191, 191),
                            width: 0.3,
                          ),
                        ),
                      ),
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.Num),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.ID),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.Qui_est_malade),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.Frais),
                              ),
                            ],
                          ),
                        ),
                         Container(
                          margin: EdgeInsets.symmetric(vertical: 15),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.remboursements),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.DateRemboursement),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            children: [
                              SizedBox(width: 10,),
                              Expanded(
                                child: Text(bs.decision),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 0, 30, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: IconButton(
                                  icon: Icon(Icons.print,color: Colors.red,),
                                  onPressed: () {
                                    
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
            ),
            Container(
             margin: EdgeInsets.all(5),
             padding: EdgeInsets.all(5),
               decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                BoxShadow(
                color: Color.fromARGB(255, 215, 215, 215).withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
        offset: Offset(0, 2), // Changez l'offset selon votre préférence
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
                  Text("Page ${_currentPage + 1} de ${(_remboursePerPage > 0) ? (rembourse.length / _remboursePerPage).ceil() : 1}"),
                  IconButton(
                    onPressed: _currentPage < (rembourse.length / _remboursePerPage).ceil() - 1 ? () => setState(() => _currentPage++) : null,
                    icon: Icon(Icons.chevron_right,color: Colors.blue.shade300,size: 18,),
                  ),
                  SizedBox(width: 20),
                  DropdownButton<int>(
                    value: _remboursePerPage,
                    underline: SizedBox(),
                    onChanged: (value) {
                      setState(() {
                        _remboursePerPage = value!;
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
    ),
    );
  }

  Widget tableHeader(String text) {
    return Container(
      
      height: 60,
      color: Color.fromARGB(200, 236, 235, 235),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
);}

}