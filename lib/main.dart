import 'package:cryptoflow/screens/home.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:adwaita/adwaita.dart';
import 'dart:ui';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.trackpad,
        },
      ),
      child: MaterialApp(
        theme: AdwaitaThemeData.light(),
        darkTheme: AdwaitaThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Home(),
      ),
    );
  }
}
