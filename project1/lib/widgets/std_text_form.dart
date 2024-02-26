import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class StdTextForm extends StatelessWidget {
  final String hint;
  final String? value;
  final TextEditingController controller;

  const StdTextForm(
      {required this.hint, this.value, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(label: Text(hint)),
      controller: controller,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
    );
  }
}
