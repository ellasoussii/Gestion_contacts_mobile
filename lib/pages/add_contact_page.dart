// pages/add_contact_page.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/contact.dart';
import '../database/db_helper.dart';

class AddContactPage extends StatefulWidget {
  final int userId;
  const AddContactPage({super.key, required this.userId});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final phoneController = TextEditingController();

  String? birthdate;
  File? imageFile;

  Future<void> pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() {
        birthdate = "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
      });
    }
  }

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => imageFile = File(picked.path));
    }
  }

  void _save() async {
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

    final contact = Contact(
      userId: widget.userId,
      name: name,
      surname: surnameController.text.trim().isEmpty ? null : surnameController.text.trim(),
      phone: phone,
      birthdate: birthdate,
      photo: imageFile?.path,
    );

    final int newId = await DatabaseHelper.instance.addContact(contact);
    if (!mounted) return;

    Navigator.pop(context, contact.copyWith(id: newId));
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
      appBar: AppBar(title: const Text("Ajouter Contact")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 55,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: imageFile != null ? FileImage(imageFile!) : null,
                  child: imageFile == null ? const Icon(Icons.camera_alt, size: 35) : null,
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
                child: const Text("Ajouter le contact", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

extension on Contact {
  Contact copyWith({int? id}) {
    return Contact(
      id: id ?? this.id,
      userId: userId,
      name: name,
      surname: surname,
      phone: phone,
      birthdate: birthdate,
      photo: photo,
    );
  }
}