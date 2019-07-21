import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';

class MMSListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final void Function() onTap;

  MMSListTile({this.title, this.subtitle, this.onTap});

  @override
  Widget build(context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 30),
      title: title != null ? Text(title, style: Theme.of(context).textTheme.title.merge(TextStyle(color: MMSColors.teal))) : null,
      subtitle: subtitle != null ? Text(subtitle, style: Theme.of(context).textTheme.subhead.merge(TextStyle(color: MMSColors.gray))) : null,
      onTap: onTap,
    );
	}
}
