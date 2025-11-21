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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Voulez-vous vraiment supprimer :\n\n${contact.name} ${contact.surname ?? ""} ?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 25),

              // BOUTON SUPPRIMER
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: const Size(double.infinity, 45),
                ),
                child: const Text("Supprimer"),
              ),

              const SizedBox(height: 10),

              // ANNULER
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Annuler"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
