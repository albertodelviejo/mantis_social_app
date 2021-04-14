import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../util/color.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              secondryColor,
              darkPrimaryColor,
              primaryColor,
            ],
          )),
          child: Container(
            height: 120,
            width: 200,
            child: Image.asset(
              "asset/mantis_main_logo.png",
              fit: BoxFit.contain,
            ),
          )),
    ));
  }
}
