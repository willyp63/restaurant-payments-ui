import 'package:flutter/material.dart';

import '../../constants/index.dart';

enum MMSButtonType {
  Primary,
  Secondary,
}

class MMSButton extends StatelessWidget {
  final MMSButtonType type;
  final String text;
  final void Function() onPressed;

  final EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  MMSButton({this.type = MMSButtonType.Primary, this.text, this.onPressed});

  @override
  Widget build(context) {
    final textWidget = new Text(text, style: Fonts.lg);

    if (type == MMSButtonType.Primary) {
      return RaisedButton(
        color: Theme.of(context).primaryColor,
        textColor: Colors.white,
        padding: padding,
        child: textWidget,
        onPressed: onPressed,
      );
    }

    // MMSButtonType.Secondary
    return FlatButton(
      textColor: Theme.of(context).primaryColor,
      padding: padding,
      child: textWidget,
      onPressed: onPressed,
    );
	}

}
