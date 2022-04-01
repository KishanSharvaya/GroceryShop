import 'package:flutter/material.dart';
import 'package:grocery_app/ui/dimen_resource.dart';

import 'general_utils.dart';

Widget getCommonDivider({double thickness, double width: double.maxFinite}) {
  if (thickness == null) {
    thickness = COMMON_DIVIDER_THICKNESS;
  }
  return Container(
    height: thickness,
    color: colorGray,
    width: width,
  );
}
