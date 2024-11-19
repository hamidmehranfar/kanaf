import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeController{
  static double height(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }
}