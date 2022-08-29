import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

class Random extends StatefulWidget {
  const Random({Key? key}) : super(key: key);

  @override
  State<Random> createState() => _RandomState();
}

class _RandomState extends State<Random> {
  String? _unit;
  String? _driver;

  bool _driverV = true;
  bool _unitV = true;
  bool _messageV = false;
  String _message = "";
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/bg4.jpg"), fit: BoxFit.cover),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Image.asset(
              'assets/images/logo.png',
              width: MediaQuery.of(context).size.width * 0.70,
              fit: BoxFit.cover,
              // height: 150,
            ),
            backgroundColor: const Color(0x2028329B),
            centerTitle: true,
            automaticallyImplyLeading: false,
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _driver == null
                            ? Visibility(
                                visible: _driverV,
                                child: _card(
                                    title: 'DNI del Conductor',
                                    subtitle:
                                        'Tendrás que colocar tu DNI para proseguir',
                                    manualMode: 'driver',
                                    btnText: 'Introducir Código'),
                              )
                            : FutureBuilder(
                                future: _getUnit(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      http.Response response =
                                          snapshot.data as http.Response;
                                      if (response.statusCode == 200) {
                                        var res = json.decode(response.body);
                                        return Visibility(
                                            visible: _unitV,
                                            child: Card(
                                                child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons
                                                          .supervised_user_circle,
                                                      color: Colors.blue,
                                                    ),
                                                    title: Text(
                                                      'Información del conductor',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 18,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  Text(
                                                    '${res['firstname']}',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 22),
                                                  ),
                                                  Text(
                                                    '${res['lastname']}',
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 22),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            top: 30),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text('DNI: ',
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    color: Colors
                                                                        .black45)),
                                                        Text(
                                                          '${res['dni']}',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 20,
                                                            right: 20,
                                                            top: 5,
                                                            bottom: 25),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          'License Number: ',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  color: Colors
                                                                      .black45),
                                                        ),
                                                        Text(
                                                          '${res['license_number']}',
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize: 18),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )));
                                      } else {
                                        _driver = null;
                                        return Visibility(
                                          visible: _driverV,
                                          child: _card(
                                              title: 'DNI del Conductor',
                                              subtitle:
                                                  'Tendrás que colocar tu DNI para proseguir',
                                              manualMode: 'driver',
                                              btnText: 'Introducir Código'),
                                        );
                                      }
                                    }
                                    if (snapshot.hasError) {
                                      return const CircularProgressIndicator();
                                    }
                                  }
                                  return const CircularProgressIndicator();
                                },
                              ),
                        _unit == null
                            ? Visibility(
                                visible: _driverV,
                                child: _card(
                                    title: 'Placa de la unidad',
                                    subtitle:
                                        'Tendrás que colocar la placa de la unidad para proseguir',
                                    manualMode: 'unit',
                                    btnText: 'Introducir Placa'))
                            : FutureBuilder(
                                initialData: false,
                                future: _getUnit(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.done) {
                                    if (snapshot.hasData) {
                                      http.Response response =
                                          snapshot.data as http.Response;
                                      if (response.statusCode == 200) {
                                        var res = json.decode(response.body);
                                        return Visibility(
                                            visible: _unitV,
                                            child: Card(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    leading: const Icon(
                                                      Icons.directions_car,
                                                      color: Colors.blue,
                                                    ),
                                                    title: Text(
                                                      'Información de la unidad',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 18,
                                                          fontStyle:
                                                              FontStyle.italic,
                                                          color: Colors
                                                              .blueAccent),
                                                    ),
                                                  ),
                                                  const Divider(),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 20),
                                                    child: Text(
                                                      'Placa:  ${res['license_plate']}',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 20),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      bottom: 25,
                                                    ),
                                                    child: Text(
                                                      'Operador logistico:  ${res['logistic_operator']}',
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 20),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ));
                                      } else {
                                        _unit = null;
                                        return Visibility(
                                            visible: _driverV,
                                            child: _card(
                                                title: 'Placa de la unidad',
                                                subtitle:
                                                    'Tendrás que colocar la placa de la unidad para proseguir',
                                                manualMode: 'unit',
                                                btnText: 'Introducir Placa'));
                                      }
                                    }
                                    if (snapshot.hasError) {
                                      return const CircularProgressIndicator();
                                    }
                                  }
                                  return const CircularProgressIndicator();
                                },
                              ),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: AnimatedOpacity(
                    opacity: _messageV ? 1.0 : 0.0,
                    duration: Duration(milliseconds: 500),
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).size.height * 0.04),
                        child: Text(
                          _message,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                          ),
                          textAlign: TextAlign.center,
                        )),
                  ),
                )
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          floatingActionButton: _driver != null && _unit != null
              ? ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    elevation: 12,
                    shape: const StadiumBorder(),
                    primary: const Color(0xFFF8951D),
                    onPrimary: const Color(0xFF9C5A09),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 12),
                    child: Text('Continuar',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 16,
                        )),
                  ))
              : null,
        ));
  }

  Widget _card(
      {required String title,
      required String subtitle,
      String? manualMode,
      String? btnText}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, bottom: 10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 24,
                ),
              ),
              subtitle: Text(subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.height * 0.05),
              child: ButtonBar(
                alignment: MainAxisAlignment.end,
                children: [_btn(manualMode: manualMode, btnText: btnText)],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _btn({String? manualMode, String? btnText}) {
    return ElevatedButton.icon(
        onPressed: () {
          _inputText(manualMode!);
        },
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          elevation: 12,
          shape: const StadiumBorder(),
          primary: const Color(0xFFF8951D),
          onPrimary: const Color(0xFF9C5A09),
        ),
        icon: const Icon(
          Icons.text_fields,
          color: Colors.white,
          size: 28,
        ),
        label: Text(
          btnText!,
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 18),
        ));
  }

  _inputText(String manualMode) {
    String unit = "";
    String driver = "";

    switch (manualMode) {
      case 'driver':
        {
          setState(() {
            _driverV = false;
            _unitV = false;
            _messageV = false;
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Ingresar el DNI del conductor',
                            style: GoogleFonts.poppins(fontSize: 20)),
                        TextField(
                          onChanged: ((value) => setState(
                                () {
                                  driver = value;
                                },
                              )),
                          autofocus: true,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        ElevatedButton(
                            onPressed: () {
                              _driver = driver;
                              setState(() {
                                _driverV = true;
                                _unitV = true;
                                _message =
                                    "Introduzca el número de DNI correctamente";
                              });
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                if (_driver == null) {
                                  setState(() {
                                    _messageV = true;
                                  });
                                }
                              });
                              Future.delayed(const Duration(milliseconds: 5000),
                                  () {
                                if (_driver == null) {
                                  setState(() {
                                    _messageV = false;
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 12,
                              shape: const StadiumBorder(),
                              primary: const Color(0xFFF8951D),
                              onPrimary: const Color(0xFF9C5A09),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 12),
                              child: Text('Validar',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            )),
                      ],
                    ),
                  ));
          break;
        }
      case 'unit':
        {
          setState(() {
            _driverV = false;
            _unitV = false;
            _messageV = false;
          });
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => AlertDialog(
                    content: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Ingresar la placa de la unidad',
                            style: GoogleFonts.poppins(fontSize: 20)),
                        TextField(
                          onChanged: ((value) => setState(
                                () {
                                  driver = value;
                                },
                              )),
                          autofocus: true,
                        ),
                        const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10)),
                        ElevatedButton(
                            onPressed: () {
                              _unit = unit;
                              setState(() {
                                _driverV = true;
                                _unitV = true;
                                _message = "Introduzca la placa correctamente";
                              });
                              Future.delayed(const Duration(milliseconds: 1000),
                                  () {
                                if (_unit == null) {
                                  setState(() {
                                    _messageV = true;
                                  });
                                }
                              });
                              Future.delayed(const Duration(milliseconds: 5000),
                                  () {
                                if (_unit == null) {
                                  setState(() {
                                    _messageV = false;
                                  });
                                }
                              });
                              Navigator.of(context).pop();
                            },
                            style: ElevatedButton.styleFrom(
                              elevation: 12,
                              shape: const StadiumBorder(),
                              primary: const Color(0xFFF8951D),
                              onPrimary: const Color(0xFF9C5A09),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 12),
                              child: Text('Validar',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                    fontSize: 16,
                                  )),
                            )),
                      ],
                    ),
                  ));
          break;
        }
    }
  }

  Future<http.Response?> _getUnit() async {
    try {
      return await http.get(Uri.parse(
          'http://checkpoint.segursat.com:8080/control/web/api/get-unit/$_unit'));
    } catch (e) {
      print(e);
      return null;
    }
  }
}
