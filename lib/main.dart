import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          width: 1000.0,
          height: 1400.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Colors.white,
            border:Border.all(
              color:Color(0xFF5BADE9),
              width:3.0, 
            )
          ),
          
          margin: EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              width: 400.0,
              height: 1400.0,
              decoration: BoxDecoration(
                color: Color(0xFF5BADE9),
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
