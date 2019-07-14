import 'package:flutter/material.dart';

import '../../theme/colors.dart';

class MMSSpinner extends StatefulWidget {
  @override
  _MMSSpinnerState createState() => _MMSSpinnerState();
}

class _MMSSpinnerState extends State<MMSSpinner> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _MMSSpinningContainer(controller: _controller);
  }
}

class _MMSSpinningContainer extends AnimatedWidget {
  final double dotRadius = 8;
  final List<Color> colors = const [
    MMSColors.violet,
    MMSColors.lightViolet,
    MMSColors.yellow,
  ];

  const _MMSSpinningContainer({Key key, AnimationController controller})
      : super(key: key, listenable: controller);

  Animation<double> get _progress => listenable;

  @override
  Widget build(context) {
    final animationValue = 1 - _progress.value;
    final radii = [
      animationValue,
      animationValue + 0.33,
      animationValue + 0.66,
    ].map((value) {
      if (value >= 1) { value -= 1; }

      double multiplier = (value - 0.5).abs();
      if (multiplier <= 0.2) { multiplier = 0.2; }
      multiplier *= 2;

      return dotRadius + dotRadius * multiplier;
    }).toList();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        buildCircle(radii[0], colors[0]),
        buildCircle(radii[1], colors[1]),
        buildCircle(radii[2], colors[2]),
      ],
    );
  }

  Widget buildCircle(num radius, Color color) {
    return Container(
      width: dotRadius * 4,
      height: dotRadius * 4,
      margin: EdgeInsets.only(right: dotRadius / 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: radius * 2,
            height: radius * 2,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(radius),
            ),
          ),
        ],
      )
    );
  }
}
