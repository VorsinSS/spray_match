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
  bool _isDragging = false;

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

  void _handlePanStart(DragStartDetails details, ColorPickerProvider provider) {
    _handlePosition(details.localPosition, provider);
    setState(() {
      _isDragging = true;
    });
  }

  void _handlePanUpdate(
    DragUpdateDetails details,
    ColorPickerProvider provider,
  ) {
    _handlePosition(details.localPosition, provider);
  }

  void _handlePanEnd(DragEndDetails details, ColorPickerProvider provider) {
    setState(() {
      _isDragging = false;
    });
    provider.finalizeColorSelection();
  }

  void _handlePosition(Offset localPosition, ColorPickerProvider provider) {
    if (_containerSize.width == 0 || _containerSize.height == 0) {
      _updateContainerSize();
      return;
    }

    // Проверяем что координаты валидные
    if (localPosition.dx.isNaN || localPosition.dy.isNaN) return;

    // Ограничиваем координаты размерами контейнера
    final clampedX = localPosition.dx.clamp(0, _containerSize.width);
    final clampedY = localPosition.dy.clamp(0, _containerSize.height);

    // Нормализуем координаты
    final normalizedX = clampedX / _containerSize.width;
    final normalizedY = clampedY / _containerSize.height;

    provider.updateTapPosition(Offset(normalizedX, normalizedY));
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
            width: MediaQuery.of(context).size.width - 32,
            height: 300,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              children: [
                // Изображение с GestureDetector для перемещения
                GestureDetector(
                  onPanStart: (details) => _handlePanStart(details, provider),
                  onPanUpdate: (details) => _handlePanUpdate(details, provider),
                  onPanEnd: (details) => _handlePanEnd(details, provider),
                  onPanCancel: () {
                    setState(() {
                      _isDragging = false;
                    });
                  },
                  // Оставляем onTapDown для быстрых нажатий
                  onTapDown: (details) {
                    _handlePosition(details.localPosition, provider);
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
                  _buildCrosshair(provider, _isDragging),
              ],
            ),
          ),

        // Индикатор перемещения
        if (_isDragging)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              'Перемещайте палец для выбора цвета',
              style: TextStyle(
                color: Colors.blue[700],
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCrosshair(ColorPickerProvider provider, bool isDragging) {
    // Преобразуем нормализованные координаты в абсолютные
    final displayX = provider.tapPosition!.dx * _containerSize.width;
    final displayY = provider.tapPosition!.dy * _containerSize.height;

    // Проверяем что координаты валидные
    if (displayX.isNaN || displayY.isNaN) return Container();

    return CrosshairWidget(
      position: Offset(displayX, displayY),
      color: isDragging ? Colors.blue : Colors.red,
      isDragging: isDragging,
    );
  }
}
