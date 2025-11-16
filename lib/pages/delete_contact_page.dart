import 'package:flutter/material.dart';
import '../models/contact.dart';

class DeleteContactPage extends StatelessWidget {
  final Contact contact;
  const DeleteContactPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Supprimer Contact")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Supprimer ${contact.name} ?', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("Supprimer"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Annuler"),
            ),
          ],
        ),
      ),
    );
  }
}
