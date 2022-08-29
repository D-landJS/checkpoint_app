import 'dart:convert';
import 'dart:io';

import 'package:checkpoint_segursat/model/control_set_model.dart';
import 'package:checkpoint_segursat/services/api_service.dart';
import 'package:checkpoint_segursat/services/progress_hud.dart';
import 'package:checkpoint_segursat/ui/widgets/custom_app_bar.dart';
import 'package:checkpoint_segursat/ui/widgets/custom_background.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ControlOptionsPages extends StatefulWidget {
  const ControlOptionsPages({Key? key}) : super(key: key);

  @override
  State<ControlOptionsPages> createState() => _ControlOptionsPagesState();
}

class _ControlOptionsPagesState extends State<ControlOptionsPages> {
  late SwiperController _controller;
  late List<dynamic> _stateList;
  List<Questions> questions = <Questions>[];
  String? selectedOption;

  // ignore: prefer_typing_uninitialized_variables
  var controlSet;

  // ignore: prefer_typing_uninitialized_variables
  var args;
  bool _isLoading = false;

  var isCompleted = false;

  void getControlById() async {
    setState(() {
      _isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? id = prefs.getInt('id');

    ApiServices.getControlSetById(id).then((res) {
      if (res.statusCode == 200) {
        setState(() {
          var jsonMap = json.decode(res.body);
          controlSet = ControlSet.fromJson(jsonMap);
          questions = controlSet.questions;
          _stateList = List.filled(questions.length, '', growable: false);
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _controller = SwiperController();
    getControlById();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments
        as Map<String, Map<String, dynamic>>;

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
                  for (var list in _stateList) {
                    if (list == "") {
                      isCompleted = false;
                    } else {
                      isCompleted = true;
                    }
                  }
                  if (isCompleted) {
                    _postData();
                  } else {
                    _incompleteOptions();
                  }

                  // ignore: avoid_print
                  print(args);
                },
                style: ElevatedButton.styleFrom(
                  elevation: 12,
                  shape: const StadiumBorder(),
                  primary: const Color(0xFFF8951D),
                  onPrimary: const Color(0xFF9C5A09),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  child: Text('Continuar',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        fontSize: 16,
                      )),
                )),
          ),
        ));
  }

  Widget _controlUI(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: Swiper(
        controller: _controller,
        loop: false,
        itemBuilder: (BuildContext context, int mainIndex) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(14)),
                    child: Text(
                      '(${mainIndex + 1} ${questions[mainIndex].question} ',
                      style: GoogleFonts.poppins(
                          color: Colors.white, fontSize: 18),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.25,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (ctx, i) {
                      var op = questions[mainIndex].options.toList()[i];

                      var ques = questions[mainIndex].question;

                      return RadioListTile(
                        activeColor: const Color(0xFFF8951D),
                        value: questions[mainIndex].options[i],
                        groupValue: _stateList[mainIndex],
                        onChanged: (val) {
                          setState(() {
                            _stateList[mainIndex] = val;
                            if (mainIndex == 0) {
                              args['controlAnswers']['answer1'] = val;
                              args['controlQuestions']['question1'] = ques;
                            } else if (mainIndex == 1) {
                              args['controlAnswers']['answer2'] = val;
                              args['controlQuestions']['question2'] = ques;
                            }
                          });
                        },
                        title: Text(
                          op,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 20),
                        ),
                      );
                    },
                    itemCount: questions[mainIndex].options.length),
              )
            ],
          );
        },
        itemCount: questions.length,
        pagination: const SwiperPagination(
            builder: DotSwiperPaginationBuilder(
                color: Colors.grey, activeColor: Color(0xFFF8951D))),
      ),
    );
  }

  _messageStatus200() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
                elevation: 1,
                title: Column(children: [
                  Text('Envio exitoso',
                      style: GoogleFonts.poppins(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Image.asset(
                    'assets/images/shipment.jpg',
                    fit: BoxFit.contain,
                    height: 150,
                  )
                ]),
                content: ElevatedButton(
                    onPressed: () {
                      if (Platform.isAndroid) {
                        SystemNavigator.pop();
                      } else {
                        exit(0);
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
                      child: Text('Salir',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            fontSize: 16,
                          )),
                    )))));
  }

  void _incompleteOptions() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Usted debe seleccionar todas las opciones requeridas',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
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
            ));
  }

  _postData() async {
    Dio dio = Dio();
    FormData formData = FormData.fromMap({
      'latitude': '${args['statement']['lat']}',
      'longitude': '${args['statement']['long']}',
      'image1': await MultipartFile.fromFile(args['gallery']['img1'].path,
          filename: args['gallery']['img1'].path.split('/').last),
      'image2': await MultipartFile.fromFile(args['gallery']['img1'].path,
          filename: args['gallery']['img1'].path.split('/').last),
      'checkpoint': args['geozone']['name'],
      'controlSet': args['type']['typeOperation'],
      'questions': {
        args['controlQuestions']['question1']: args['controlAnswers']
            ['answer1'],
        args['controlQuestions']['question2']: args['controlAnswers']['answer2']
      },
    });

    try {
      _loader(true);
      String url = 'http://desarrollo.segursat.com:8000/checkpoint/add-event/';
      Response res = await dio.post(url, data: formData);

      if (res.statusCode == 200) {
        // ignore: avoid_print
        print('entro');
        _loader(false);
        _messageStatus200();
      }
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Widget? _loader(bool isTrue) {
    if (isTrue) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return null;
  }
}
