import 'package:flutter/material.dart';
import '../models/user.dart';
import '../models/contact.dart';
import '../database/db_helper.dart';
import 'add_contact_page.dart';
import 'edit_contact_page.dart';
import 'delete_contact_page.dart';
import 'login_page.dart';

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

  void _loadContacts() async {
    final data = await DatabaseHelper.instance.getContactsByUser(widget.user.id!);
    setState(() => contacts = data);
  }

  void _addContact(Contact contact) async {
    await DatabaseHelper.instance.addContact(contact);
    _loadContacts();
  }

  void _editContact(Contact contact) async {
    await DatabaseHelper.instance.updateContact(contact);
    _loadContacts();
  }

  void _deleteContact(int id) async {
    await DatabaseHelper.instance.deleteContact(id);
    _loadContacts();
  }

  void _logout() {
    // Retour à la page de login
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
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
            tooltip: 'Déconnexion',
          )
        ],
      ),
      body: contacts.isEmpty
          ? const Center(child: Text("Aucun contact. Ajoutez-en !"))
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (_, i) {
                final c = contacts[i];
                return ListTile(
                  title: Text(c.name),
                  subtitle: Text(c.phone),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.orange),
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => EditContactPage(contact: c)),
                          );
                          if (updated != null) _editContact(updated);
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () async {
                          final confirm = await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DeleteContactPage(contact: c)),
                          );
                          if (confirm == true) _deleteContact(c.id!);
                        },
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
            MaterialPageRoute(builder: (_) => AddContactPage(userId: widget.user.id!)),
          );
          if (newContact != null) _addContact(newContact);
        },
      ),
    );
  }
}
