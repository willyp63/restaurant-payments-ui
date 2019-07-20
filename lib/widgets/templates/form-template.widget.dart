import 'package:flutter/material.dart';

import 'package:restaurant_payments_ui/theme/colors.dart';
import 'package:restaurant_payments_ui/widgets/shared/index.dart';

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
                    child: Image.asset('images/mimos_logo.png'),
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