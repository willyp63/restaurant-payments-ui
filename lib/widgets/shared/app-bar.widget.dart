import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MMSAppBar extends AppBar {
  MMSAppBar({Widget title})
      : super(
          elevation: 0,
          centerTitle: true,
          title: title != null
              ? title
              : Container(
                  width: 100,
                  child: Image.asset('images/mimos_logo_white.png'),
                ),
        );
}
