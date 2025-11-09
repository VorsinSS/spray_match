import 'package:flutter/material.dart';

class CrosshairWidget extends StatelessWidget {
  final Offset position;
  final Color color;

  const CrosshairWidget({
    super.key,
    required this.position,
    this.color = Colors.red,
  });

  @override
  Widget build(BuildContext context) {
    // Проверяем что координаты валидные
    if (position.dx.isNaN || position.dy.isNaN) {
      return Container();
    }

    return Positioned(
      left: position.dx - 15,
      top: position.dy - 15,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: CustomPaint(painter: _CrosshairPainter(color: color)),
      ),
    );
  }
}

class _CrosshairPainter extends CustomPainter {
  final Color color;

  _CrosshairPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = 1.5
          ..style = PaintingStyle.stroke;

    // Внешний круг
    canvas.drawCircle(center, 12, paint);

    // Горизонтальная линия
    canvas.drawLine(Offset(0, center.dy), Offset(size.width, center.dy), paint);

    // Вертикальная линия
    canvas.drawLine(
      Offset(center.dx, 0),
      Offset(center.dx, size.height),
      paint,
    );

    // Центральная точка
    canvas.drawCircle(center, 2, paint..style = PaintingStyle.fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
