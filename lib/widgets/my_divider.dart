import 'package:flutter/material.dart';

class MyDivider extends Divider implements PreferredSizeWidget{
  final Color color;
  final double height;
  final double thickness;
  const MyDivider({
    super.key,
    required this.color,
    required this.height,
    required this.thickness,
  }) : super(
    color: color,
    height: height,
    thickness: thickness
  );

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(height);
}
