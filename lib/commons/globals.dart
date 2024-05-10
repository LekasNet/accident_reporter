import 'package:flutter/material.dart';

class Item {
  final IconData icon;
  final String title;
  final String description;

  Item({required this.icon, required this.title, required this.description});
}

final List<Item> items = [
  Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  Item(icon: Icons.school, title: 'School', description: 'Description of School'),
  Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  Item(icon: Icons.school, title: 'School', description: 'Description of School'),
  Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  Item(icon: Icons.school, title: 'School', description: 'Description of School'),
  Item(icon: Icons.home, title: 'Home', description: 'Description of Home'),
  Item(icon: Icons.business, title: 'Business', description: 'Description of Business'),
  Item(icon: Icons.school, title: 'School', description: 'Description of School'),
];