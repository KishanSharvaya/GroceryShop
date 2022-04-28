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

Widget showCustomToast({ String Title} ) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(25.0),
      color: Colors.black,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check, color: Colors.white),
        SizedBox(
          width: 12.0,
        ),
        Text(Title, style: TextStyle(color: Colors.white),),
      ],
    ),
  );
}

