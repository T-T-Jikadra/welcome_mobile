import 'package:flutter/material.dart';
import 'package:welcome_mob/common/eqWidget/eqSplash.dart';

void main() {
  runApp(const MyApp());
  //TT
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WELCOME MOBILE',
        home: SplashScreen(),
        theme: ThemeData(primarySwatch: Colors.blueGrey),
        debugShowCheckedModeBanner: false);
  }
}
