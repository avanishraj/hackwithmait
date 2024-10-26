import 'package:flutter/material.dart';

class PasswordField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool passwordVisible;
  final VoidCallback toggleVisibility;
  final FormFieldValidator<String>? validator;

  PasswordField({
    required this.label,
    required this.controller,
    required this.passwordVisible,
    required this.toggleVisibility,
    this.validator,
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
        TextFormField(
          controller: controller,
          obscureText: !passwordVisible,
          decoration: InputDecoration(
            hintText: '********',
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
            suffixIcon: IconButton(
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: toggleVisibility,
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}