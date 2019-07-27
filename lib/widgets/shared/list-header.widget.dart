import 'package:flutter/material.dart';

import 'package:mimos/constants/colors.constants.dart';
import 'package:mimos/widgets/shared/index.dart';

class MMSListHeader extends StatelessWidget {
  final String title;
  final String actionName;
  final void Function() onAction;

  MMSListHeader({this.title, this.actionName, this.onAction});

  @override
  Widget build(context) {
    final bool hasAction = actionName != null;

    return Container(
      color: MMSColors.babyPowder,
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(context).textTheme.headline,
          ),
          hasAction
              ? MMSButton(
                  type: MMSButtonType.Link,
                  text: actionName,
                  onPressed: onAction,
                )
              : Container(),
        ],
      ),
    );
  }
}
