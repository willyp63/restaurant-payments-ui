import 'package:flutter/material.dart';

import 'package:mimos/theme/colors.dart';

class MMSTextField extends StatefulWidget {
  final String label;
  final String errorText;
  final ValueChanged<String> onChanged;
  final VoidCallback onBlur;
  final bool obscureText;

  MMSTextField({
    this.label,
    this.errorText,
    this.onChanged,
    this.onBlur,
    this.obscureText = false,
  });

  @override
  _MMSTextFieldState createState() => _MMSTextFieldState();
}

class _MMSTextFieldState extends State<MMSTextField> {
  FocusNode focusNode;

  @override
  void initState() {
    super.initState();

    focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        widget.onBlur();
      }
    });
  }

  @override
  void dispose() {
    focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(context) {
    return TextField(
      focusNode: focusNode,
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
        hintText: widget.label,
        errorText: widget.errorText,
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      onChanged: widget.onChanged,
      obscureText: widget.obscureText,
    );
  }
}
