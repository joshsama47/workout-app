import 'equipment.dart';

class Exercise {
  final String id;
  final String name;
  final String description;
  final String animation;
  final List<Equipment> equipment;

  Exercise({
    required this.id,
    required this.name,
    required this.description,
    required this.animation,
    this.equipment = const [],
  });
}
