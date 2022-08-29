import 'package:checkpoint_segursat/ui/pages/login/login_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TermsConditionsPages extends StatefulWidget {
  const TermsConditionsPages({Key? key}) : super(key: key);

  @override
  State<TermsConditionsPages> createState() => _TermsConditionsPagesState();
}

class _TermsConditionsPagesState extends State<TermsConditionsPages> {
  ScrollController scrollController = ScrollController();
  bool showbtn = false;
  // ignore: prefer_typing_uninitialized_variables
  var height;

  _listener() {
    final maxScroll = scrollController.position.maxScrollExtent;
    final minScroll = scrollController.position.minScrollExtent;
    if (scrollController.offset >= maxScroll) {
      setState(() {
        showbtn = true;
      });
    }

    if (scrollController.offset <= minScroll) {
      setState(() {
        showbtn = false;
      });
    }
  }

  @override
  void initState() {
    scrollController.addListener(_listener);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/bg4.jpg"), fit: BoxFit.cover),
      ),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                // height: 150,
              ),
              backgroundColor: const Color(0x2028329B),
              centerTitle: true,
              automaticallyImplyLeading: false,
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ElevatedButton(
                onPressed: () => {
                      showbtn
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            )
                          : null
                    },
                style: ElevatedButton.styleFrom(
                  shape: const StadiumBorder(),
                  primary: showbtn
                      ? const Color(0xFFF8951D)
                      : const Color(0xFFEBC79C),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text('CONFIRMAR',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 16,
                      )),
                )),
            body: Align(
              alignment: Alignment.center,
              child: Container(
                padding: const EdgeInsets.all(15),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.only(bottom: 35, top: 45),
                      child: Center(
                        child: Text('Términos y condiciones',
                            style: GoogleFonts.poppins(
                                fontSize: 26, color: const Color(0xFFF4F4F8))),
                      ),
                    ),
                    SizedBox(
                      height: height < 600
                          ? MediaQuery.of(context).size.height * 0.30
                          : MediaQuery.of(context).size.height * 0.48,
                      child: SingleChildScrollView(
                        controller: scrollController,
                        scrollDirection: Axis.vertical,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              'Segursat S.A.C. informa que sus datos personales han sido proporcionados por su empleador o la empresa que lo contrató, quien manifestó conocer y cumplir con la Ley N° 29733, Ley de Protección de Datos Personales, su Reglamento, aprobado por Decreto Supremo N° 003-2013-JUS, y todas las demás normas referidas a protección de datos personales. En ese sentido, declaró contar con su respectivo consentimiento.',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 10)),
                            Text(
                              'Por medio de la presente, acepto y declaro que:',
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2)),
                            Text(
                              '1) Conozco que la información recabada mediante el aplicativo será de uso exclusivo de Segursat S.A.C. y, por tanto, no debe ser compartida con ningún tercero.',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2)),
                            Text(
                              '2) Usaré el aplicativo únicamente para los servicios contratados mediante Segursat S.A.C.',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2)),
                            Text(
                              '3) El uso del aplicativo es estrictamente personal.                             ',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            const Padding(
                                padding: EdgeInsets.symmetric(vertical: 5)),
                            Text(
                              'Tengo pleno entendimiento de lo que aquí acepto y declaro; por lo tanto, doy mi conformidad.',
                              style: GoogleFonts.roboto(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
