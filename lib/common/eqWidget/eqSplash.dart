import 'dart:async';
import 'package:flutter/material.dart';
import 'package:welcome_mob/auth/final_login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(),
          Center(
            child: Image.asset("assets/icon/WM_p.png", height: 188),
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              return AnimatedBuilder(
                animation: _animations[index],
                builder: (context, child) {
                  double offset = (1 - _animations[index].value) * 10;
                  return Transform.translate(
                    offset: Offset(0, -offset),
                    child: Text(
                      '.',
                      style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  );
                },
              );
            }),
          ),
          Text(
            'Welcome Mobile',
            style: TextStyle(
                fontSize: 25,
                fontFamily: 'Roboto',
                color: Colors.black,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 45),
        ],
      ),
    );
  }

  void _initAnimation() {
    _controller = AnimationController(
      duration: const Duration(milliseconds: 750),
      vsync: this,
    );

    _animations = List.generate(3, (index) {
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve:
              Interval(index * 0.3, (index + 1) * 0.3, curve: Curves.easeInOut),
        ),
      );
    });

    _controller.repeat(reverse: true);
  }

  Future<void> _loadData() async {
    await Future.delayed(Duration(milliseconds: 3250));
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.easeInOut;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(position: offsetAnimation, child: child);
      },
    ));
  }
}
