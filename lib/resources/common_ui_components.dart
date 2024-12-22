import 'package:flutter/material.dart';

class CommonUIComponents {
  
  static commonAppBar(BuildContext context, String appBarTitle,
      Color appBarBgColor, Color appBarContentColor, List<Widget> actions) {
    return AppBar(
        backgroundColor: appBarBgColor,
        title: Text(
          appBarTitle.toUpperCase(),
          style: TextStyle(
              color: appBarContentColor,
              fontSize: 18,
              fontWeight: FontWeight.w700),
        ), actions: actions);
  }
}
