import 'dart:math';

import 'package:flutter/material.dart';

import '../models/palette_color.dart';

class ColorPalette {
  static final List<PaletteColor> ralColors = [
    PaletteColor(name: 'RAL 1000', code: 'Green beige', value: 0xFFCDBA88),
    PaletteColor(name: 'RAL 1001', code: 'Beige', value: 0xFFD0B084),
    PaletteColor(name: 'RAL 1002', code: 'Sand yellow', value: 0xFFD2AA6D),
    PaletteColor(name: 'RAL 1003', code: 'Signal yellow', value: 0xFFF9A800),
    PaletteColor(name: 'RAL 1004', code: 'Golden yellow', value: 0xFFE49E00),
    PaletteColor(name: 'RAL 1005', code: 'Honey yellow', value: 0xFFCB8E00),
    PaletteColor(name: 'RAL 1006', code: 'Maize yellow', value: 0xFFE29000),
    PaletteColor(name: 'RAL 1007', code: 'Daffodil yellow', value: 0xFFE88C00),
    PaletteColor(name: 'RAL 1011', code: 'Brown beige', value: 0xFFAF804F),
    PaletteColor(name: 'RAL 1012', code: 'Lemon yellow', value: 0xFFDDAF27),
    PaletteColor(name: 'RAL 1013', code: 'Oyster white', value: 0xFFE3D9C6),
    PaletteColor(name: 'RAL 1014', code: 'Ivory', value: 0xFFDDC49A),
    PaletteColor(name: 'RAL 1015', code: 'Light ivory', value: 0xFFE6D2B5),
    PaletteColor(name: 'RAL 1016', code: 'Sulfur yellow', value: 0xFFEED484),
    PaletteColor(name: 'RAL 1017', code: 'Saffron yellow', value: 0xFFF0CA00),
    PaletteColor(name: 'RAL 1018', code: 'Zinc yellow', value: 0xFFF8F32B),
    PaletteColor(name: 'RAL 1019', code: 'Grey beige', value: 0xFF9E9764),
    PaletteColor(name: 'RAL 1020', code: 'Olive yellow', value: 0xFF999950),
    PaletteColor(name: 'RAL 1021', code: 'Rape yellow', value: 0xFFF3DA0B),
    PaletteColor(name: 'RAL 1023', code: 'Traffic yellow', value: 0xFFFAD201),
    PaletteColor(name: 'RAL 1024', code: 'Ochre yellow', value: 0xFFAEA04B),
    PaletteColor(name: 'RAL 1026', code: 'Luminous yellow', value: 0xFFFFFF00),
    PaletteColor(name: 'RAL 1027', code: 'Curry', value: 0xFF9D9101),
    PaletteColor(name: 'RAL 1028', code: 'Melon yellow', value: 0xFFF4A900),
    PaletteColor(name: 'RAL 1032', code: 'Broom yellow', value: 0xFFD6AE01),
    PaletteColor(name: 'RAL 1033', code: 'Dahlia yellow', value: 0xFFF3A505),
    PaletteColor(name: 'RAL 1034', code: 'Pastel yellow', value: 0xFFEFA94A),
    PaletteColor(name: 'RAL 1035', code: 'Pearl beige', value: 0xFF6A5D4D),
    PaletteColor(name: 'RAL 1036', code: 'Pearl gold', value: 0xFF705335),
    PaletteColor(name: 'RAL 1037', code: 'Sun yellow', value: 0xFFF39F18),
    // Добавьте остальные цвета RAL (всего их 213)
  ];

  // Метод для получения всех цветов
  static List<Color> get allColors {
    return ralColors.map((paletteColor) => paletteColor.color).toList();
  }

  // Поиск по названию или коду
  static PaletteColor? findByNameOrCode(String query) {
    return ralColors.firstWhere(
      (color) =>
          color.name.toLowerCase().contains(query.toLowerCase()) ||
          color.code.toLowerCase().contains(query.toLowerCase()),
      orElse: () => ralColors.first,
    );
  }

  // Поиск ближайшего цвета
  static PaletteColor findClosestColor(Color targetColor) {
    PaletteColor closest = ralColors.first;
    double minDistance = double.infinity;

    for (final paletteColor in ralColors) {
      final distance = _colorDistance(targetColor, paletteColor.color);
      if (distance < minDistance) {
        minDistance = distance;
        closest = paletteColor;
      }
    }
    return closest;
  }

  // Расстояние между цветами
  static double _colorDistance(Color c1, Color c2) {
    return sqrt(
      pow(c1.r - c2.r, 2) + pow(c1.g - c2.g, 2) + pow(c1.b - c2.b, 2),
    );
  }
}
