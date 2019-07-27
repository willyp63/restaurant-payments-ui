import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mimos/constants/index.dart';
import 'package:mimos/widgets/shared/button.widget.dart';

class MMSPaymentConfirmationScreen extends StatefulWidget {
  @override
  MMSPaymentConfirmationScreenState createState() => MMSPaymentConfirmationScreenState();
}

class MMSPaymentConfirmationScreenState extends State<MMSPaymentConfirmationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MMSColors.white,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.dark, // set OS status bar color
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Positioned(
                  right: 0.0,
                  bottom: MediaQuery.of(context).size.height * -0.7,
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.55,
                    child: Transform(
                      transform: Matrix4.identity()..rotateX(pi),
                      child: Image.asset(MMSImagePaths.silverwareGraphic),
                    ),
                  ),
                ),
                Positioned(
                  top: 0.0,
                  left: 0.0,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          'Payment Complete!',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.body2,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 8),
                        width: MediaQuery.of(context).size.width / 2,
                        child: Text(
                          'How about dessert?',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.display2,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 24, bottom: MediaQuery.of(context).size.height * 0.2),
                        child: MMSButton(
                          text: 'Find Another Table',
                          onPressed: _goToHomeScreen,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )),
    );
  }

  _goToHomeScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil(AppRoutes.home, (_) => false);
  }
}
