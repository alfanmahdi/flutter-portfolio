import 'package:flutter/material.dart';
import 'package:sec_app/gradient_container.dart';

void main() {
  runApp(
    const MaterialApp(
      home: Scaffold(body: GradientContainer(Colors.red, Colors.blue)),
    ),
  );
}
