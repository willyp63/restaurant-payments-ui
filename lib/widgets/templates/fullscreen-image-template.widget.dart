import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mimos/constants/image-paths.constants.dart';

class MMSFullscreenImageTemplate extends StatelessWidget {
  final Widget child;
  final String imagePath;

  MMSFullscreenImageTemplate({this.child, this.imagePath = MMSImagePaths.restaurantBackground});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light, // set OS status bar color
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(imagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                color: Color(0x77000000),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: child,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
