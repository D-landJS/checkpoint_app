import 'package:checkpoint_segursat/model/login_model.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as User;

    const person = Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.only(top: 55),
        child: CircleAvatar(
          radius: 72.0,
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('assets/images/avatar.png'),
        ),
      ),
    );

    final welcomePage = Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'Bienvenido ${args.description}',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: const Color(0xFFF4F4F8)),
      ),
    );

    final text = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        'Bienvenido a la aplicación de control de paradas de Segursat S.A.C. en esta aplicación podrá completar la informacion solicitada por nuestro cliente en cada parada autorizada. Por favor sirvase completar la información requerida por nuestro cliente : ${args.accountDescription}',
        style: GoogleFonts.poppins(
            fontWeight: FontWeight.normal,
            fontSize: 14,
            color: const Color(0xFFF4F4F8)),
        textAlign: TextAlign.justify,
      ),
    );

    final nextButton = Align(
        child: Container(
            padding: const EdgeInsets.all(5),
            child: ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/controlSet');
              },
              style: ElevatedButton.styleFrom(
                  elevation: 8,
                  shape: const CircleBorder(),
                  primary: const Color(0xFFF8951D),
                  minimumSize: const Size.square(60)),
              child: const ImageIcon(
                AssetImage('assets/images/ic_forward.png'),
                size: 40,
                color: Colors.white,
              ),
            )));

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/bg4.jpg"), fit: BoxFit.cover),
      ),
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  person,
                  Column(
                    children: [welcomePage, text],
                  ),
                  nextButton
                ]),
          )),
    );
  }
}
