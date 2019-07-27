import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:mimos/constants/image-paths.constants.dart';

class MMSAppBar extends AppBar {
  MMSAppBar({Widget title})
      : super(
          elevation: 0,
          centerTitle: true,
          title: title != null
              ? title
              : Container(
                  width: 100,
                  child: Image.asset(MMSImagePaths.logoWhite),
                ),
        );
}
