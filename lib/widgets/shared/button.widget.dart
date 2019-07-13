import 'package:flutter/material.dart';

import '../../theme/colors.dart';

enum MMSButtonType {
  Primary,
  Secondary,
  Tertiary,
  Link,
}

class MMSButton extends StatelessWidget {
  final MMSButtonType type;
  final String text;
  final void Function() onPressed;

  final padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
  final noPadding = const EdgeInsets.all(0);
  final shape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(0));

  MMSButton({this.type = MMSButtonType.Primary, this.text, this.onPressed});

  @override
  Widget build(context) {
    final primaryTextStyle = Theme.of(context).textTheme.button.merge(TextStyle(color: Theme.of(context).primaryColor));
    final whiteTextStyle = Theme.of(context).textTheme.button.merge(TextStyle(color: MMSColors.white));
    final linkTextStyle = Theme.of(context).textTheme.subhead.merge(TextStyle(color: Theme.of(context).primaryColor));

    switch (type) {
      case MMSButtonType.Primary:
        return FlatButton(
          color: Theme.of(context).primaryColor,
          child: Text(text, style: whiteTextStyle),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
        );
      case MMSButtonType.Secondary:
        return OutlineButton(
          borderSide: BorderSide(
            color: Theme.of(context).primaryColor,
            style: BorderStyle.solid,
            width: 1,
          ),
          child: Text(text, style: primaryTextStyle),
          onPressed: onPressed,
          padding: padding,
          shape: shape,
        );
      case MMSButtonType.Tertiary:
        return FlatButton(
          child: Text(text, style: primaryTextStyle),
          onPressed: onPressed,
          padding: padding,
        );
      case MMSButtonType.Link:
        return InkWell(
          child: Text(text, style: linkTextStyle),
          onTap: onPressed,
        );
    }

    return null;
	}

}
