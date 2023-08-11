import 'package:flutter/material.dart';

class MainPageModel {
  int pageIndex = 0;
  List<Widget> pages = [];
  final pageController = PageController(initialPage: 0);

  MainPageModel();
}
