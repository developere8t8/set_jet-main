import 'package:flutter/material.dart';
import 'package:set_jet/theme/common.dart';

class AppButton extends StatelessWidget {
  const AppButton(
      {Key? key, this.onpressed, this.text, this.color, this.textColor})
      : super(key: key);
  final Function? onpressed;
  final String? text;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onpressed as void Function()?,
      color: color,
      textColor: textColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text!,
      ),
    );
  }
}
