import 'package:flutter/material.dart';
import 'package:flutter_blog/_core/constants/size.dart';

class CustomAuthTextFormField extends StatelessWidget {
  final String text;
  final bool obscureText;
  final String? value;
  final String? errorText;
  final Function(String)? onChanged;

  const CustomAuthTextFormField({
    super.key,
    required this.text,
    this.obscureText = false,
    this.value,
    this.errorText,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        const SizedBox(height: smallGap),
        TextFormField(
          initialValue: value,
          obscureText: obscureText,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: "Enter $text",
            errorText: errorText,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
      ],
    );
  }
}
