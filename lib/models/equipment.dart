class Equipment {
  final String id;
  final String name;

  Equipment({required this.id, required this.name});

  factory Equipment.fromMap(Map<String, dynamic> map) {
    return Equipment(id: map['id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
