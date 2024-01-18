import 'package:flutter/material.dart';

enum ScreenType { handset, tablet, desktop, watch }

class FormFactor {
  static double desktop = 900;
  static double tablet = 750;
  static double handset = 500;
}

ScreenType getFormFactor(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > FormFactor.desktop) return ScreenType.desktop;
  if (deviceWidth > FormFactor.tablet) return ScreenType.tablet;
  if (deviceWidth > FormFactor.handset) return ScreenType.handset;
  return ScreenType.watch;
}

enum ScreenSize { small, normal, large, extraLarge }
ScreenSize getSize(BuildContext context) {
  double deviceWidth = MediaQuery.of(context).size.shortestSide;
  if (deviceWidth > 900) return ScreenSize.extraLarge;
  if (deviceWidth > 750) return ScreenSize.large;
  if (deviceWidth > 500) return ScreenSize.normal;
  return ScreenSize.small;
}
