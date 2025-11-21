// pages/edit_contact_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/contact.dart';

class EditContactPage extends StatefulWidget {
  final Contact contact;
  const EditContactPage({super.key, required this.contact});

  @override
  State<EditContactPage> createState() => _EditContactPageState();
}

class _EditContactPageState extends State<EditContactPage> {
  late TextEditingController nameController;
  late TextEditingController surnameController;
  late TextEditingController phoneController;
  String? birthdate;
  File? imageFile;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.contact.name);
    surnameController = TextEditingController(text: widget.contact.surname ?? '');
    phoneController = TextEditingController(text: widget.contact.phone);
    birthdate = widget.contact.birthdate;
    if (widget.contact.photo != null) imageFile = File(widget.contact.photo!);
  }

  Future<void> pickDate() async {
    DateTime initial = DateTime(2000);
    if (birthdate != null) {
      final parts = birthdate!.split('/');
      if (parts.length == 3) {
        final d = int.tryParse(parts[0]);
        final m = int.tryParse(parts[1]);
        final y = int.tryParse(parts[2]);
        if (d != null && m != null && y != null) initial = DateTime(y, m, d);
      }
    }

    final date = await showDatePicker(context: context, initialDate: initial, firstDate: DateTime(1900), lastDate: DateTime.now());
    if (date != null) {
      setState(() {
        birthdate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) setState(() => imageFile = File(picked.path));
  }

  void _save() {
    final name = nameController.text.trim();
    final phone = phoneController.text.trim();

    if (name.isEmpty || phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.error, color: Colors.white),
              SizedBox(width: 12),
              Text("Nom et téléphone sont obligatoires !", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 4),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        ),
      );
      return;
    }

    final updated = Contact(
      id: widget.contact.id,
      userId: widget.contact.userId,
      name: name,
      surname: surnameController.text.trim().isEmpty ? null : surnameController.text.trim(),
      phone: phone,
      birthdate: birthdate,
      photo: imageFile?.path ?? widget.contact.photo,
    );

    Navigator.pop(context, updated);
  }

  @override
  void dispose() {
    nameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Modifier Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: imageFile != null
                      ? FileImage(imageFile!)
                      : (widget.contact.photo != null ? FileImage(File(widget.contact.photo!)) : null),
                  child: imageFile == null && widget.contact.photo == null ? const Icon(Icons.camera_alt, size: 32) : null,
                ),
              ),
              const SizedBox(height: 20),

              TextField(controller: nameController, decoration: const InputDecoration(labelText: "Nom ", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: surnameController, decoration: const InputDecoration(labelText: "Prénom", border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: phoneController, keyboardType: TextInputType.phone, decoration: const InputDecoration(labelText: "Téléphone ", border: OutlineInputBorder())),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      birthdate == null ? "Date de naissance " : "Date : $birthdate",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                  ElevatedButton(onPressed: pickDate, child: const Text("Choisir")),
                ],
              ),

              const SizedBox(height: 40),

              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56), elevation: 3),
                child: const Text("Enregistrer les modifications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}