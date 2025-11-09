import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/color_picker_provider.dart';

class ColorResultWidget extends StatelessWidget {
  const ColorResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ColorPickerProvider>(context);

    return Column(
      children: [
        if (provider.selectedColor != null) ...[
          const Text('Выбранный цвет:', style: TextStyle(fontSize: 16)),
          Container(
            width: 100,
            height: 50,
            color: provider.selectedColor,
            margin: const EdgeInsets.symmetric(vertical: 10),
          ),
          const SizedBox(height: 20),
          const Text(
            'Ближайший в палитре:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          if (provider.matchedColor != null) ...[
            Container(
              width: 100,
              height: 50,
              color: provider.matchedColor!.color,
              margin: const EdgeInsets.symmetric(vertical: 10),
            ),
            Text(provider.matchedColor!.name),
            Text(
              provider.matchedColor!.code,
              style: TextStyle(color: Colors.grey[600]),
            ),
            Text(
              '#${provider.matchedColor!.value.toRadixString(16).substring(2).toUpperCase()}',
            ),
          ],
        ],
      ],
    );
  }
}
