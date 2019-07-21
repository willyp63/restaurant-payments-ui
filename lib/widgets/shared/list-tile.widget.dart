import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';

class MMSListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget trailing;
  final void Function() onTap;

  MMSListTile({this.title, this.subtitle, this.onTap, this.trailing});

  @override
  Widget build(context) {
    return Container(
      color: MMSColors.white,
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
        title: title != null
            ? Container(
              margin: EdgeInsets.only(top: 12, bottom: subtitle == null ? 12 : 0),
              child: Text(title,
                style: Theme.of(context)
                    .textTheme
                    .title
                    .merge(TextStyle(color: MMSColors.teal))),
            )
            : null,
        subtitle: subtitle != null
            ? Container(
              margin: EdgeInsets.only(top: 2, bottom: 12),
              child: Text(subtitle,
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .merge(TextStyle(color: MMSColors.gray))),
            )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
