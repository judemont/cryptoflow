import 'package:cryptoflow/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:adwaita/adwaita.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.light);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // return ValueListenableBuilder<ThemeMode>(
    // valueListenable: themeNotifier,
    //       builder: (_, ThemeMode currentMode, __) {
    return MaterialApp(
       theme: AdwaitaThemeData.light(),
      darkTheme: AdwaitaThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: Home(),
      // themeMode: currentMode
    );
  }
}
