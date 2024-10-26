import 'package:flutter/material.dart';

class CustomDropdownFormField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final List<String> items;

  CustomDropdownFormField({
    required this.label,
    required this.controller,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            floatingLabelBehavior: FloatingLabelBehavior.always,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey, width: 1.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.grey.shade500, width: 1.5),
            ),
            contentPadding:
                EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          ),
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? newValue) {
            controller.text = newValue!;
          },
        ),
      ],
    );
  }
}