import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;
import '../data/color_palette.dart';
import '../models/palette_color.dart';

class ColorPickerProvider extends ChangeNotifier {
  File? _imageFile;
  Color? _selectedColor;
  PaletteColor? _matchedColor;
  Offset? _tapPosition;
  int? _imageWidth;
  int? _imageHeight;

  File? get imageFile => _imageFile;
  Color? get selectedColor => _selectedColor;
  PaletteColor? get matchedColor => _matchedColor;
  Offset? get tapPosition => _tapPosition;

  Size get imageSize {
    if (_imageWidth != null && _imageHeight != null) {
      return Size(_imageWidth!.toDouble(), _imageHeight!.toDouble());
    }
    return Size.zero;
  }

  // Загрузка изображения
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);
      _selectedColor = null;
      _matchedColor = null;
      _tapPosition = null;
      _imageWidth = null;
      _imageHeight = null;

      // Получаем размеры изображения
      final imageBytes = await _imageFile!.readAsBytes();
      final image = img.decodeImage(imageBytes)!;
      _imageWidth = image.width;
      _imageHeight = image.height;

      notifyListeners();
    }
  }

  // Обновление позиции при перемещении пальца
  Future<void> updateTapPosition(Offset normalizedPosition) async {
    if (_imageFile == null || _imageWidth == null || _imageHeight == null)
      return;

    // Проверяем что координаты валидные
    if (normalizedPosition.dx.isNaN || normalizedPosition.dy.isNaN) return;
    if (normalizedPosition.dx < 0 || normalizedPosition.dx > 1) return;
    if (normalizedPosition.dy < 0 || normalizedPosition.dy > 1) return;

    // Обновляем позицию сразу для плавного перемещения
    _tapPosition = normalizedPosition;

    // Обновляем цвет
    final imageBytes = await _imageFile!.readAsBytes();
    final image = img.decodeImage(imageBytes)!;

    // Преобразуем нормализованные координаты в пиксельные
    final pixelX = (normalizedPosition.dx * _imageWidth!).toInt();
    final pixelY = (normalizedPosition.dy * _imageHeight!).toInt();

    // Ограничиваем координаты
    final clampedX = pixelX.clamp(0, _imageWidth! - 1);
    final clampedY = pixelY.clamp(0, _imageHeight! - 1);

    final pixel = image.getPixel(clampedX, clampedY);

    _selectedColor = Color.fromARGB(
      pixel.a.toInt(),
      pixel.r.toInt(),
      pixel.g.toInt(),
      pixel.b.toInt(),
    );

    _matchedColor = ColorPalette.findClosestColor(_selectedColor!);

    notifyListeners();
  }

  // Финальное подтверждение выбора цвета
  void finalizeColorSelection() {
    notifyListeners();
  }

  void clearSelection() {
    _selectedColor = null;
    _matchedColor = null;
    _tapPosition = null;
    notifyListeners();
  }
}
