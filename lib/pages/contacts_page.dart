import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/contact.dart';
import '../database/db_helper.dart';
import 'add_contact_page.dart';
import 'edit_contact_page.dart';
import 'delete_contact_page.dart';
import 'login_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactsPage extends StatefulWidget {
  final User user;
  const ContactsPage({super.key, required this.user});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  // Charger les contacts
  Future<void> _loadContacts() async {
    final data = await DatabaseHelper.instance.getContactsByUser(widget.user.id!);
    if (!mounted) return;
    setState(() => contacts = data);
  }

  // Mettre à jour un contact
  Future<void> _editContact(Contact contact) async {
    await DatabaseHelper.instance.updateContact(contact);
    _loadContacts();
  }

  // Supprimer un contact
  Future<void> _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    _loadContacts();
  }

  // Déconnexion
  void _logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // Ouvrir WhatsApp
Future<void> openWhatsApp(String phone) async {
  // Nettoie le numéro
  String cleanPhone = phone.replaceAll(RegExp(r'\D'), ''); // enlève espaces, tirets, etc.

  // Transforme 06... → +336...
  if (cleanPhone.startsWith('0') && cleanPhone.length == 10) {
    cleanPhone = '33${cleanPhone.substring(1)}';
  }

  final String whatsappUrl = "https://wa.me/$cleanPhone";

  try {
    await launchUrl(
      Uri.parse(whatsappUrl),
      mode: LaunchMode.externalApplication, // ouvre WhatsApp si installé
    );
  } catch (e) {
    // Si WhatsApp pas installé → ouvre dans le navigateur
    await launchUrl(
      Uri.parse(whatsappUrl),
      mode: LaunchMode.platformDefault,
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contacts de ${widget.user.name}"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: contacts.isEmpty
          ? const Center(child: Text("Aucun contact. Ajoutez-en !"))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (_, i) {
                final c = contacts[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: 
                        c.photo != null ? FileImage(File(c.photo!)) : null,
                    child: c.photo == null ? const Icon(Icons.person) : null,
                  ),
                  title: Text("${c.name} ${c.surname ?? ""}"),
                  subtitle: Text("${c.phone}\n${c.birthdate ?? ""}"),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Modifier
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditContactPage(contact: c),
                            ),
                          );

                          if (updated != null && updated is Contact) {
                            _editContact(updated);
                          }
                        },
                      ),

                      // Supprimer
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeleteContactPage(contact: c),
                            ),
                          );
                          if (confirm == true) _deleteContact(c.id!);
                        },
                      ),

                      // WhatsApp
                      IconButton(
                        icon: const FaIcon(
                          FontAwesomeIcons.whatsapp,
                          color: Colors.green,
                        ),
                        onPressed: () => openWhatsApp(c.phone),
                      ),
                    ],
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          final newContact = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddContactPage(userId: widget.user.id!),
            ),
          );

          if (newContact != null && newContact is Contact) {
            _loadContacts();
          }
        },
      ),
    );
  }
}
