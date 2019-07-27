import 'package:flutter/material.dart';

import 'package:mimos/constants/image-paths.constants.dart';
import 'package:mimos/constants/index.dart';
import 'package:mimos/widgets/shared/index.dart';

import './fullscreen-image-template.widget.dart';

class MMSFormTemplate extends StatelessWidget {
  final List<Widget> children;
  final bool isLoading;

  MMSFormTemplate({this.children, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    return MMSFullscreenImageTemplate(
      child: isLoading ? MMSSpinner() : _buildForm(context),
    );
  }

  _buildForm(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width / 16,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            color: MMSColors.babyPowder,
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 16,
              vertical: 50,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                [
                  Container(
                    padding: EdgeInsets.only(bottom: 24),
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Image.asset(MMSImagePaths.logo),
                  ),
                ],
                children,
              ].expand((x) => x).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
