import 'package:flutter/material.dart' hide Badge;
import '../models/badge.dart';

final List<Badge> badges = [
  const Badge(
    id: 'first_workout',
    name: 'First Workout',
    description: 'Completed your first workout.',
    icon: Icons.star,
    color: Colors.amber,
  ),
  const Badge(
    id: 'five_workouts',
    name: 'Workout Novice',
    description: 'Completed 5 workouts.',
    icon: Icons.military_tech,
    color: Colors.grey,
  ),
  const Badge(
    id: 'ten_workouts',
    name: 'Workout Pro',
    description: 'Completed 10 workouts.',
    icon: Icons.shield,
    color: Colors.blue,
  ),
  const Badge(
    id: 'twenty_workouts',
    name: 'Workout Veteran',
    description: 'Completed 20 workouts.',
    icon: Icons.emoji_events,
    color: Colors.purple,
  ),
];
