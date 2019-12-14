import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:funtube_v1/app.dart';
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyApp(),
      theme: new ThemeData(
        pageTransitionsTheme: PageTransitionsTheme(builders: {TargetPlatform.android: CupertinoPageTransitionsBuilder(),}),
      ),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      image: Image.asset('assets/icon/icon.png'),
      seconds: 5,
      backgroundColor: Colors.white,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 50.0,
      loaderColor: Colors.black,
       navigateAfterSeconds: Main()
    );
  }
}
