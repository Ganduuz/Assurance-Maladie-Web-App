import 'package:flutter/material.dart';

class ResetPasswordPage extends StatefulWidget {
  final String token;

  const ResetPasswordPage({Key? key, required this.token}) : super(key: key);

  @override
  _ResetPasswordPageState createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _passwordValid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Réinitialiser le mot de passe'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Saisissez votre nouveau mot de passe ici'),
            SizedBox(height: 20),
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
            SizedBox(height: 20),
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_passwordController.text.isNotEmpty &&
                    _passwordController.text == _confirmPasswordController.text) {
                  // Appelez la fonction pour réinitialiser le mot de passe avec le nouveau mot de passe (_passwordController.text) et le jeton (widget.token)
                  // Par exemple, resetPassword(widget.token, _passwordController.text);
                  // Vous devrez implémenter la logique de réinitialisation de mot de passe ici
                  // Une fois la réinitialisation terminée, vous pouvez rediriger l'utilisateur vers une autre page
                  Navigator.pop(context); // Redirigez l'utilisateur vers une autre page après la réinitialisation
                } else {
                  setState(() {
                    _passwordValid = false;
                  });
                }
              },
              child: Text('Réinitialiser'),
            ),
          ],
        ),
      ),
    );
  }
}
