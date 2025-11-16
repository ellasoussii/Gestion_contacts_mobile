import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/user.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void _register() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // DEBUG : afficher les valeurs
    print("DEBUG => name: $name, email: $email, password: $password, confirm: $confirmPassword");

    if (name.isEmpty || email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
      _showError("Veuillez remplir tous les champs.");
      return;
    }

    if (password != confirmPassword) {
      _showError("Les mots de passe ne correspondent pas.");
      return;
    }

    final existing = await DatabaseHelper.instance.getUserByEmail(email);
    if (existing != null) {
      _showError("Cet email existe déjà.");
      return;
    }

    final user = User(name: name, email: email, password: password);
    await DatabaseHelper.instance.addUser(user);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Inscription réussie'),
        content: Text('Bienvenue, $name !'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop(); // Retour au login
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showError(String msg) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Erreur"),
        content: Text(msg),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom complet")),
            const SizedBox(height: 12),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 12),
            TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: "Mot de passe")),
            const SizedBox(height: 12),
            TextField(controller: confirmPasswordController, obscureText: true, decoration: const InputDecoration(labelText: "Confirmer le mot de passe")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _register, child: const Text("Créer un compte")),
          ],
        ),
      ),
    );
  }
}
