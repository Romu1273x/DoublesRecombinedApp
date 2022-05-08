import 'package:flutter/material.dart';

class GenderPersonIcon extends StatelessWidget {
  GenderPersonIcon({
    Key? key,
    required this.gender, 
    required this.size,
  }) : super(key: key);
  final int gender;
  final double? size;

  @override
  Widget build(BuildContext context) {
    // 性別によってアイコンを変更
    Icon personIcon = Icon(Icons.person, color: Colors.blue, size: size);
    if (gender == 2) {
      personIcon = Icon(Icons.person, color: Colors.pink, size: size);
    }
    return personIcon;
  } 
}
