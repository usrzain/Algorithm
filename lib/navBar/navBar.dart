import 'package:flutter/material.dart';

class navBar {
  final int id;
  final dynamic
      iconOrImagePath; // Use dynamic type to allow both Icon and String
  final String name;

  navBar({
    required this.id,
    required this.iconOrImagePath,
    required this.name,
  });
}

List<navBar> navBtn = [
  navBar(id: 0, iconOrImagePath: Icons.home, name: 'Home'),
  navBar(id: 1, iconOrImagePath: Icons.route_outlined, name: 'Route'),
  navBar(id: 2, iconOrImagePath: Icons.bookmark, name: 'Saved'),
  navBar(id: 3, iconOrImagePath: Icons.notifications, name: 'Notify'),
  navBar(id: 4, iconOrImagePath: Icons.person, name: 'Me'),
];
