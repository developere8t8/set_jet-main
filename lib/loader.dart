import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loader extends StatefulWidget {
  const Loader({Key? key}) : super(key: key);

  @override
  State<Loader> createState() => _LoaderState();
}

class _LoaderState extends State<Loader> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: SpinKitFadingCircle(
          size: 120,
          itemBuilder: (context, index) {
            final colors = [Colors.pink[300], Colors.lightBlue];
            final color = colors[index % colors.length];
            return DecoratedBox(
                decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ));
          },
        ),
      ),
    ));
  }
}
