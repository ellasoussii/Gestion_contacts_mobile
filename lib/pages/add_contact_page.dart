import 'package:flutter/material.dart';
import '../models/contact.dart';

class AddContactPage extends StatefulWidget {
  final int userId;
  const AddContactPage({super.key, required this.userId});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();

  void _save() {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) return;

    final contact = Contact(
      userId: widget.userId,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );
    Navigator.pop(context, contact);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ajouter Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Téléphone")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text("Ajouter")),
          ],
        ),
      ),
    );
  }
}
