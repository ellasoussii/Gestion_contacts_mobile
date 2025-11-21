// models/contact.dart
class Contact {
  int? id;
  int userId;
  String name;
  String? surname;
  String phone;
  String? birthdate;
  String? photo;

  Contact({
    this.id,
    required this.userId,
    required this.name,
    this.surname,
    required this.phone,
    this.birthdate,
    this.photo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'name': name,
      'surname': surname,
      'phone': phone,
      'birthdate': birthdate,
      'photo': photo,
    };
  }

  factory Contact.fromMap(Map<String, dynamic> map) {
    return Contact(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      name: map['name'] as String,
      surname: map['surname'] as String?,
      phone: map['phone'] as String,
      birthdate: map['birthdate'] as String?,
      photo: map['photo'] as String?,
    );
  }
}