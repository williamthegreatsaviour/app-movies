import 'package:flutter/material.dart';

enum BottomItem {
  home,
  search,
  comingsoon,
  livetv,
  profile,
}

class BottomBarItem {
  final String title;
  final IconData icon;
  final IconData activeIcon;
  final String type;

  BottomBarItem({
    required this.title,
    required this.icon,
    required this.activeIcon,
    required this.type,
  });
}
