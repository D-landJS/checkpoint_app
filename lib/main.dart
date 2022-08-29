// @dart=2.9

import 'package:checkpoint_segursat/ui/pages/geolocation_page.dart';
import 'package:checkpoint_segursat/ui/pages/control/control_options_page.dart';
import 'package:checkpoint_segursat/ui/pages/control/controlset_page.dart';
import 'package:checkpoint_segursat/ui/pages/control/gallery_page.dart';
import 'package:checkpoint_segursat/ui/pages/login/login_page.dart';
import 'package:checkpoint_segursat/ui/pages/splash_screen.dart';
import 'package:checkpoint_segursat/ui/pages/home/welcome_page.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Checkpoint Segursat App',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => const WelcomePage(),
        '/login': (BuildContext context) => const LoginPage(),
        '/location': (BuildContext context) => const LocationPage(),
        '/controlSet': (BuildContext context) => const ControlSetPage(),
        '/gallery': (BuildContext context) => const GalleryPage(),
        '/controlOptions': (BuildContext context) => const ControlOptionsPages()
      },
    );
  }
}
