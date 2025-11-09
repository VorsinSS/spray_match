import 'package:flutter/material.dart';

class CrosshairWidget extends StatelessWidget {
  final Offset position;
  final Color color;
  final bool isDragging;

  const CrosshairWidget({
    super.key,
    required this.position,
    this.color = Colors.red,
    this.isDragging = false,
  });

  @override
  Widget build(BuildContext context) {
    if (position.dx.isNaN || position.dy.isNaN) {
      return Container();
    }

    return Positioned(
      left: position.dx - 20,
      top: position.dy - 20,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: isDragging ? 3.0 : 2.0),
          // Тень убрана
        ),
        child: Stack(
          children: [
            // Горизонтальная линия
            Center(child: Container(height: 2, width: 40, color: color)),
            // Вертикальная линия
            Center(child: Container(height: 40, width: 2, color: color)),
            // Центральная точка
            Center(
              child: Container(
                width: isDragging ? 8 : 6,
                height: isDragging ? 8 : 6,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  // Тень у центральной точки тоже убрана
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
