import 'package:checkpoint_segursat/ui/pages/terms_conditions_page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      Navigator.push(
          context,
          PageTransition(
            child: const TermsConditionsPages(),
            type: PageTransitionType.fade,
            curve: Curves.fastOutSlowIn,
            duration: const Duration(seconds: 1),
          ));
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _visible = !_visible;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/bg4.jpg"), fit: BoxFit.cover),
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Align(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Expanded(child: Container()),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: MediaQuery.of(context).size.width,
                      child: AnimatedOpacity(
                          opacity: _visible ? 1.0 : 0.0,
                          duration: const Duration(seconds: 2),
                          child: Image.asset('assets/images/logo.png')),
                    ),
                    Expanded(child: Container()),
                    Column(
                      children: <Widget>[
                        AnimatedOpacity(
                          opacity: _visible ? 1.0 : 0.0,
                          duration: const Duration(seconds: 2),
                        ),
                        AnimatedOpacity(
                            opacity: _visible ? 1.0 : 0.0,
                            duration: const Duration(seconds: 2),
                            child: Text(
                              'Control de Paradas',
                              style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.white),
                            )),
                        AnimatedOpacity(
                            opacity: _visible ? 1.0 : 0.0,
                            duration: const Duration(seconds: 2),
                            child: Text('©Segursat S.A.C.',
                                style: GoogleFonts.montserrat(
                                    fontSize: 20, color: Colors.white))),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.05,
                        )
                      ],
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
