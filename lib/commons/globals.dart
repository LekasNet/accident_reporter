import 'package:flutter/material.dart';
import 'dart:math';

class Item {
  final IconData icon;
  final String title;
  final String description;

  Item({required this.icon, required this.title, required this.description});
}

List<Item> items = [
  // Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  // Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  // Item(icon: Icons.school, title: 'School', description: 'Description of School'),
  // Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  // Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  // Item(icon: Icons.school, title: 'School', description: 'Description of School'),
  // Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  // Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  // Item(icon: Icons.school, title: 'School', description: 'Description of School'),
  // Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  // Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  // Item(icon: Icons.school, title: 'School', description: 'Description of School'),
];

final List<IconData> icons = [
  Icons.directions_car,
  Icons.directions_bike,
  Icons.directions_boat,
  Icons.directions_bus,
  Icons.local_taxi,
];

IconData getRandomIcon() {
  final random = Random();
  return icons[random.nextInt(icons.length)];
}