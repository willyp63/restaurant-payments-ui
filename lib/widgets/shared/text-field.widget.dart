import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class MMSTextField extends StatelessWidget {
  final String label;
  final ValueChanged<String> onChanged;
  final bool obscureText;

  MMSTextField({this.label, this.onChanged, this.obscureText = false});

  @override
  Widget build(context) {
    return TextField(
      decoration: InputDecoration(
        fillColor: MMSColors.white,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: MMSColors.gray,
            style: BorderStyle.solid,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(0),
        ),
        hintText: label,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onChanged: onChanged,
      obscureText: obscureText,
    );
  }
}
