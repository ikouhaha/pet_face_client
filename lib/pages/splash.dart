import 'dart:async';

import 'package:flutter/material.dart';



class Splash extends StatefulWidget {
  const Splash({Key? key}) : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  bool _initialized = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.circle),
            const SizedBox(
              height: 20,
            ),
            Text('0',
                style: TextStyle(fontSize: 18, color: Colors.grey[800]))
          ],
        ),
      ),
    );
  }

}
