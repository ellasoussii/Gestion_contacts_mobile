import 'package:flutter/material.dart';
import '../models/contact.dart';

class EditContactPage extends StatefulWidget {
  final Contact contact;
  const EditContactPage({super.key, required this.contact});

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController nameController;
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    phoneController = TextEditingController(text: widget.contact.phone);
  }

  void _save() {
    if (nameController.text.isEmpty || phoneController.text.isEmpty) return;

    final updated = Contact(
      id: widget.contact.id,
      userId: widget.contact.userId,
      name: nameController.text.trim(),
      phone: phoneController.text.trim(),
    );
    Navigator.pop(context, updated);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom")),
            const SizedBox(height: 12),
            TextField(controller: phoneController, decoration: const InputDecoration(labelText: "Téléphone")),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _save, child: const Text("Enregistrer")),
          ],
        ),
      ),
    );
  }
}
