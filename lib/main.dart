import 'package:flutter/material.dart';
import 'package:bulb/bulb.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bulb Game',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Bulb Game', textScaleFactor: 1.2),
        ),
        body: BulbPage(),
      ),
    );
  }
}
