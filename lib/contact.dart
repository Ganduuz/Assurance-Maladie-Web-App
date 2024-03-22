import 'package:flutter/material.dart';

class contact extends StatelessWidget {
  const contact({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: 1920,
        height: 1080,
        child: Center(
          child: Text(
            'Contactez nous',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: contact(),
  ));
}
