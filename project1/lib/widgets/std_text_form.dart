import 'package:flutter/material.dart';

class StdTextForm extends StatelessWidget {
  final String? hint;
  final String? value;
  final TextEditingController controller;

  const StdTextForm(
      {this.hint, this.value, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(hintText: hint),
      controller: controller,
    );
  }
}
