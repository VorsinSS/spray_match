import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/color_picker_provider.dart';
import 'widgets/image_picker_widget.dart';
import 'widgets/color_result_widget.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ColorPickerProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Подбор краски')),
        body: const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              ImagePickerWidget(),
              SizedBox(height: 20),
              ColorResultWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
