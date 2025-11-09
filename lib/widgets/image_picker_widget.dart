import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/color_picker_provider.dart';
import 'crosshair_widget.dart';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  final GlobalKey _containerKey = GlobalKey();
  Size _containerSize = Size.zero;

  void _updateContainerSize() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _containerKey.currentContext?.findRenderObject() as RenderBox?;
      if (renderBox != null) {
        setState(() {
          _containerSize = renderBox.size;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColorPickerProvider>(context);

    return Column(
      children: [
        ElevatedButton(
          onPressed: () async {
            await provider.pickImage();
            _updateContainerSize();
          },
          child: const Text('Выбрать изображение'),
        ),
        const SizedBox(height: 20),
        if (provider.imageFile != null)
          Container(
            key: _containerKey,
            width: MediaQuery.of(context).size.width - 32, // учитываем padding
            height: 300,
            color: Colors.grey[100],
            child: Stack(
              children: [
                // Изображение
                GestureDetector(
                  onTapDown: (details) {
                    if (_containerSize.width == 0 ||
                        _containerSize.height == 0) {
                      _updateContainerSize();
                      return;
                    }

                    final localPosition = details.localPosition;

                    // Проверяем что координаты валидные
                    if (localPosition.dx.isNaN || localPosition.dy.isNaN)
                      return;

                    // Ограничиваем координаты размерами контейнера
                    final clampedX = localPosition.dx.clamp(
                      0,
                      _containerSize.width,
                    );
                    final clampedY = localPosition.dy.clamp(
                      0,
                      _containerSize.height,
                    );

                    // Нормализуем координаты
                    final normalizedX = clampedX / _containerSize.width;
                    final normalizedY = clampedY / _containerSize.height;

                    provider.pickColor(
                      Offset(normalizedX, normalizedY),
                      context,
                    );
                  },
                  child: Image.file(
                    provider.imageFile!,
                    fit: BoxFit.contain,
                    width: _containerSize.width,
                    height: 300,
                  ),
                ),

                // Прицел
                if (provider.tapPosition != null &&
                    _containerSize.width > 0 &&
                    _containerSize.height > 0 &&
                    !provider.tapPosition!.dx.isNaN &&
                    !provider.tapPosition!.dy.isNaN)
                  _buildCrosshair(provider),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildCrosshair(ColorPickerProvider provider) {
    // Преобразуем нормализованные координаты в абсолютные
    final displayX = provider.tapPosition!.dx * _containerSize.width;
    final displayY = provider.tapPosition!.dy * _containerSize.height;

    // Проверяем что координаты валидные
    if (displayX.isNaN || displayY.isNaN) return Container();

    return CrosshairWidget(
      position: Offset(displayX, displayY),
      color: Colors.red, // Яркий цвет для видимости
    );
  }
}
