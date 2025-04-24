
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthInputField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final TextEditingController controller;
  final bool isPassword;

  const AuthInputField({
    super.key,
    required this.hint,
    required this.icon,
    required this.controller,
    this.isPassword = false
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
          prefixIcon: Icon(icon),
          hintText: hint
      ),
    );
  }

}