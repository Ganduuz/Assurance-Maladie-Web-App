import 'package:flutter/material.dart';

class newmember extends StatelessWidget {
  const newmember({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Container(
              height: 140,
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
                      "Nom Employé",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.blue.shade200,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        SizedBox(width: 250, child: Text("Nom et prénom")),
                        SizedBox(width: 250, child: Text("Date de naissance")),
                        SizedBox(width: 250, child: Text("Relation")),
                         SizedBox(width: 20), 
                        IconButton(
                          onPressed: () {
                            
                          },
                          icon:Image.asset("assets/approve.png"),
                        ),
                        SizedBox(width: 5),
                        IconButton(
                          onPressed: () {
                            
                          },
                          icon: Image.asset("assets/decline.png"),
                        ),
                      ],
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
}