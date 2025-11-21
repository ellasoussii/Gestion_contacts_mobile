// pages/signup_page.dart
import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/user.dart';
import './login_page.dart';        // ← IMPORTANT : on importe la page login

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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Inscription réussie ! Bienvenue $name")),
    );

    // Retour automatique à la page de connexion
    Navigator.pop(context);
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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 40),

            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom complet",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Mot de passe",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock),
              ),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Confirmer le mot de passe",
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _register,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
              ),
              child: const Text("Créer un compte", style: TextStyle(fontSize: 18)),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("J'ai déjà un compte ? "),
                GestureDetector(
  onTap: () => Navigator.pop(context),
  child: Text(
    "Se connecter",
    style: TextStyle(
      color: Theme.of(context).colorScheme.primary,   // ← même couleur que le bouton
      fontWeight: FontWeight.bold,
      decoration: TextDecoration.underline,
    ),
  ),
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}