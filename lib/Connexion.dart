import 'package:flutter/material.dart';

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: TextTheme(
          bodyText2: TextStyle(
            fontFamily: 'Julius Sans One',
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Container(
            width: 1000.0,
            height: 1400.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              border: Border.all(
                color: Color(0xFF5BADE9),
                width: 3.0,
              ),
            ),
            margin: EdgeInsets.all(20.0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    width: 400.0,
                    height: 1400.0,
                    decoration: BoxDecoration(
                      color: Color(0xFF5BADE9),
                      borderRadius: BorderRadius.circular(17.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'BIENVENUE!',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 95.0,
                  left: 610.0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Color(0xFF2695FB),
                          width: 2.0,
                        ),
                      ),
                    ),
                    child: Text(
                      'Connexion',
                      style: TextStyle(
                        fontFamily: 'Julius Sans One',
                        color: Color(0xFF2695FB),
                        fontSize: 30,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
