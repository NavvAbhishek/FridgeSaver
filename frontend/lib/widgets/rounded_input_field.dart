import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? initialValue;

  const RoundedInputField({
    Key? key,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    required this.onSaved,
    this.validator,
    this.keyboardType,
    this.initialValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: initialValue,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onSaved: onSaved,
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).primaryColor,
        ),
        hintText: hintText,
      ),
    );
  }
}
