import 'package:flutter/material.dart';

import 'package:mimos/constants/colors.constants.dart';

import './text.dart';

final appTheme = ThemeData(
  // Define the default brightness and colors.
  brightness: Brightness.light,
  primaryColor: MMSColors.violet,
  accentColor: MMSColors.teal,
  backgroundColor: MMSColors.babyPowder,
  
  // Define the default font family.
  fontFamily: 'Montserrat',
  
  // Define the default TextTheme.
  textTheme: appTextTheme,
);
