import 'package:flutter/material.dart';

class Badge {
  final String id;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}
