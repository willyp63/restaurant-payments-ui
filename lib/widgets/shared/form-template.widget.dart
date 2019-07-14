import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../theme/colors.dart';
import './spinner.widget.dart';

class MMSFormTemplate extends StatelessWidget {
  final List<Widget> children;
  final bool isLoading;

  MMSFormTemplate({this.children, this.isLoading = false});

  @override
  Widget build(BuildContext context) {
    final content = !isLoading
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        width: MediaQuery.of(context).size.width * 0.25,
                        child: Image.asset('images/mimos_logo.png'),
                      ),
                    ],
                    children,
                  ].expand((x) => x).toList(),
                ),
              )
            ],
          )
        : MMSSpinner();

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Stack(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('images/restaurant.jpg'),
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
                color: Color(0x88000000),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 16,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[content],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
