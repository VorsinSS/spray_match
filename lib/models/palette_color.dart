import 'package:flutter/material.dart';

class PaletteColor {
  final String name;
  final String code;
  final int value;

  PaletteColor({required this.name, required this.code, required this.value});

  // Конвертация в Color
  Color get color => Color(value);

  // Для отладки
  @override
  String toString() => '$name ($code)';
}
