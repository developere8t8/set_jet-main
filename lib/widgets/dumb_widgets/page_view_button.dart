import 'package:flutter/material.dart';

import '../../theme/light.dart';
import '../../theme/dark.dart';

class PageViewButton extends StatelessWidget {
  const PageViewButton({
    Key? key,
    required this.isLight,
    this.text,
  }) : super(key: key);

  final bool isLight;
  final String? text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xff707070),
        ),
      ),
      margin: const EdgeInsets.only(
        top: 30,
        left: 30,
        right: 30,
      ),
      height: 51,
      width: 316,
      child: MaterialButton(
        onPressed: () {},
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
              child: Text(
            text!,
            textAlign: TextAlign.center,
          )),
        ),
        color: !isLight ? dateButtonDark : dateButtonLight,
      ),
    );
  }
}
