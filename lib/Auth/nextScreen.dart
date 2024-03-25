// ignore_for_file: file_names, library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class NextScreen extends StatefulWidget {
  const NextScreen({Key? key}) : super(key: key);

  @override
  _NextScreenState createState() => _NextScreenState();
}

class _NextScreenState extends State<NextScreen> {
  int _value = 3;
  final _pageviewController = PageController();

  void _decrementValue() {
    setState(() {
      _value =
          _value > 0 ? _value - 1 : _value; // Ensure value doesn't go below 0
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: PageView(controller: _pageviewController),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(),
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {}, child: const Text('Skip')),
            Center(
              child: SmoothPageIndicator(
                controller: _pageviewController,
                count: 3,
                onDotClicked: (index) => _pageviewController.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut),
              ),
            ),
            TextButton(
                onPressed: () => _pageviewController.nextPage(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut),
                child: const Text('Next'))
          ],
        ),
      ),
    );
  }

  Widget introScreen(BuildContext context) {
    return Container();
  }
}
