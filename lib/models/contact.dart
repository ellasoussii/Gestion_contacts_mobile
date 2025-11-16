class Contact {
  int? id;
  int userId;
  String name;
  String phone;

  Contact({this.id, required this.userId, required this.name, required this.phone});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'phone': phone,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      phone: map['phone'],
    );
  }
}

