import 'dart:convert';
import 'package:checkpoint_segursat/model/control_sets_model.dart';
import 'package:checkpoint_segursat/services/api_service.dart';
import 'package:checkpoint_segursat/services/progress_hud.dart';
import 'package:checkpoint_segursat/ui/widgets/custom_app_bar.dart';
import 'package:checkpoint_segursat/ui/widgets/custom_background.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlSetPage extends StatefulWidget {
  const ControlSetPage({Key? key}) : super(key: key);

  @override
  State<ControlSetPage> createState() => _ControlSetPageState();
}

class _ControlSetPageState extends State<ControlSetPage> {
  int? selectedRadioTile;
  ControlSets? selectedControl;
  bool _isLoading = false;
  String? controlName;

  List<ControlSets> controlSets = <ControlSets>[];

  @override
  void initState() {
    super.initState();
    selectedRadioTile = 0;
    getControls();
  }

  void getControls() async {
    setState(() {
      _isLoading = true;
    });

    ApiServices.getControlSets().then((res) {
      setState(() {
        Iterable list = json.decode(res.body);
        controlSets = list.map((model) => ControlSets.fromJson(model)).toList();
        _isLoading = false;
      });
    });
  }

  setSelectedRadioTile(int val) {
    setState(() {
      selectedRadioTile = val;
    });
  }

  setSelectedControl(ControlSets controlSets) {
    setState(() {
      selectedControl = controlSets;
      controlName = selectedControl!.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: customBackground,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: const CustomAppBar(),
              body: SafeArea(
                child: ProgressHUD(
                    inAsynCall: _isLoading,
                    opacity: 0.3,
                    child: _controlUI(context)),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerFloat,
              floatingActionButton: ElevatedButton(
                  onPressed: () {
                    if (controlName != null) {
                      Navigator.pushNamed(context, '/location',
                          arguments: <String, Map<String, dynamic>>{
                            'statement': {
                              'state': false,
                              'lat': null,
                              'long': null
                            },
                            'geozone': {'state': false, 'name': null},
                            // 'scanner': {'unidad': null, 'conductor': null},
                            'type': {'typeOperation': controlName},
                            'gallery': {
                              'state': false,
                              'img1': null,
                              'img2': null,
                            },
                            'controlQuestions': {
                              'question1': null,
                              'question2': null
                            },
                            'controlAnswers': {'answer1': null, 'answer2': null}
                          });
                    } else {
                      _invalidCheck();
                    }
                  },
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
                  ))),
        ));
  }

  Widget _controlUI(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 5.0),
          child: Text(
            'Seleccionar el control set adecuado',
            style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Container(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width * 0.12,
            ),
            child: Column(
              children: createRadioControlSets(),

              // FutureBuilder<List<ControlSets>?>(
              //     future: controlFuture,
              //     builder: (context, snapshot) {
              //       if (snapshot.connectionState ==
              //           ConnectionState.waiting) {
              //         return const CircularProgressIndicator();
              //       } else if (snapshot.hasData) {
              //         final controls = snapshot.data!;
              //         return buildControlSets(controls);
              //       } else if (snapshot.hasError) {
              //         return Text("snapshot.error");
              //       } else {
              //         return Text('No user data');
              //       }
              //     })

              // Radio(
              //     fillColor: MaterialStateColor.resolveWith(
              //         (states) => const Color(0xFFF8951D)),
              //     value: i,
              //     groupValue: _value,
              //     onChanged: (value) {
              //       setState(() {
              //         _value = value as int;
              //       });
              //     }),
              // Text(
              //   list[i]['id'].toString(),
              //   style: GoogleFonts.poppins(
              //       color: Colors.white, fontSize: 20),
              // )

              // Container(
              //   padding: EdgeInsets.only(
              //       left: MediaQuery.of(context).size.width * 0.23,
              //       top: MediaQuery.of(context).size.width * 0.1),
              //   child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //     Radio(
              //         fillColor: MaterialStateColor.resolveWith(
              //             (states) => const Color(0xFFF8951D)),
              //         value: 1,
              //         groupValue: _value,
              //         onChanged: (val) {
              //           setState(() {
              //             _value = val as int;
              //           });
              //         }),
              //     Text(
              //       'Control SET 1',
              //       style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
              //     )
              //   ]),
              // ),
              // Container(
              //   padding:
              //       EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.23),
              //   child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //     Radio(
              //         fillColor: MaterialStateColor.resolveWith(
              //             (states) => const Color(0xFFF8951D)),
              //         value: 2,
              //         groupValue: _value,
              //         onChanged: (val) {
              //           setState(() {
              //             _value = val as int;
              //           });
              //         }),
              //     Text(
              //       'Control SET 2',
              //       style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
              //     )
              //   ]),
              // ),
              // Container(
              //   padding:
              //       EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.23),
              //   child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
              //     Radio(
              //         fillColor: MaterialStateColor.resolveWith(
              //             (states) => const Color(0xFFF8951D)),
              //         value: 3,
              //         groupValue: _value,
              //         onChanged: (val) async {
              //           SharedPreferences prefs =
              //               await SharedPreferences.getInstance();
              //           String? basicAuth = prefs.getString('BasicAuth');
              //           print(basicAuth);
              //           getControl();
              //           values.length;
              //           setState(() {
              //             _value = val as int;
              //           });
              //         }),
              //     Text(
              //       'Control SET 3',
              //       style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
              //     )
              //   ]),
              // ),
            ),
          ),
        ),
      ],
    );
  }

  //   getTextWidgets( Map<String, dynamic> values)
  // {
  //   return [for(var item in values )  TableRow(children: [
  //             Text(item['id']),
  //             Text(item['name']),
  //         ])];
  // }

  // Widget buildControlSets(List<ControlSets> controlSets) => ListView.builder(
  //     itemCount: controlSets.length,
  //     itemBuilder: (context, index) {
  //       final control = controlSets[index];

  //       return Container(
  //         padding:
  //             EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.23),
  //         child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
  //           Radio(
  //               fillColor: MaterialStateColor.resolveWith(
  //                   (states) => const Color(0xFFF8951D)),
  //               value: control.id,
  //               groupValue: _value,
  //               onChanged: (val) {
  //                 setState(() {
  //                   _value = val as int;
  //                 });
  //               }),
  //           Text(
  //             control.name,
  //             style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
  //           )
  //         ]),
  //       );
  //     });

  List<Widget> createRadioControlSets() {
    List<Widget> widgets = [];
    for (ControlSets controlSet in controlSets) {
      widgets.add(
        RadioListTile(
            activeColor: const Color(0xFFF8951D),
            value: controlSet,
            groupValue: selectedControl,
            onChanged: (val) async {
              // ignore: avoid_print
              print('Current name ${controlSet.name} and id ${controlSet.id} ');
              setSelectedControl(val as ControlSets);
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setInt('id', controlSet.id);

              // prefs.setString("controlSet", controlSet.toString());
            },
            selected: selectedControl == controlSet,
            title: Text(
              controlSet.name,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 20),
            )),
      );
    }

    return widgets;
  }
  //  ButtonBar(
  //                   alignment: MainAxisAlignment.center,
  //                   buttonPadding: EdgeInsets.only(
  //                       left: MediaQuery.of(context).size.width * 0.23,
  //                       top: MediaQuery.of(context).size.width * 0.1),
  //                   children: [
  //                     Radio(
  //                         fillColor: MaterialStateColor.resolveWith(
  //                             (states) => const Color(0xFFF8951D)),
  //                         value: 1,
  //                         groupValue: _value,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             _value = value as int;
  //                           });
  //                         }),
  //                     Text(
  //                       'ho',
  //                       style: GoogleFonts.poppins(
  //                           color: Colors.white, fontSize: 20),
  //                     ),
  //                     Radio(
  //                         fillColor: MaterialStateColor.resolveWith(
  //                             (states) => const Color(0xFFF8951D)),
  //                         value: 1,
  //                         groupValue: _value,
  //                         onChanged: (value) {
  //                           setState(() {
  //                             _value = value as int;
  //                           });
  //                         }),
  //                     Text(
  //                       'ho',
  //                       style: GoogleFonts.poppins(
  //                           color: Colors.white, fontSize: 20),
  //                     )
  //                   ],
  //                 ),

  _invalidCheck() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => WillPopScope(
              onWillPop: () async => true,
              child: AlertDialog(
                // title: ClipRRect(
                //     borderRadius: const BorderRadius.only(
                //         topLeft: Radius.circular(2),
                //         topRight: Radius.circular(2)),
                //     child: Image.asset('assets/images/lost.jpg')),
                content: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(),
                        child: Text(
                          'Seleccione una opción',
                          style: GoogleFonts.openSans(fontSize: 22),
                          textAlign: TextAlign.center,
                        )),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          primary: const Color(0xFFF8951D),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 12),
                          child: Text('Aceptar',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                fontSize: 16,
                              )),
                        )),
                  ],
                ),
              ),
            ));
  }
}
