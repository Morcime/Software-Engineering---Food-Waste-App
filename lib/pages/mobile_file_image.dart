import 'dart:io';
import 'package:flutter/material.dart';

Widget mobileImageWidget(String path) {
  return Image.file(File(path), fit: BoxFit.cover);
}
