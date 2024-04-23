import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'Connexion.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({super.key, required this.token});

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordValid = true;


Future<void> resetPass(BuildContext context) async {
        final String password = _passwordController.text;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:5000/api/reset-password/:token'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'password': password}),
      );

      if (response.statusCode == 200) {
        
      } else {
        
        
      }
    } catch (error) {
      print('Erreur de connexion: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Réinitialiser le mot de passe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Saisissez votre nouveau mot de passe ici'),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                  errorText: _passwordValid ? null : 'Veuillez entrer un mot de passe valide',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmez le mot de passe',
                  errorText: _passwordValid ? null : 'Les mots de passe ne correspondent pas',
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text.isNotEmpty &&
                    _passwordController.text == _confirmPasswordController.text) {
                  resetPass(context);
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                     builder: (context) =>
                      MyHomePage()),
                    );
                } else {
                  setState(() {
                    _passwordValid = false;
                  });
                }
              },
              child: const Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}
