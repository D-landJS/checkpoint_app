import 'dart:convert';
import 'dart:io';

import 'package:checkpoint_segursat/model/control_set_model.dart';

import 'package:checkpoint_segursat/services/api_service.dart';
import 'package:checkpoint_segursat/services/progress_hud.dart';
import 'package:checkpoint_segursat/ui/widgets/custom_app_bar.dart';
import 'package:checkpoint_segursat/ui/widgets/custom_background.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryPage extends StatefulWidget {
  const GalleryPage({Key? key}) : super(key: key);

  @override
  State<GalleryPage> createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  bool _isLoading = false;
  int indexcam = 0;
  // ignore: prefer_typing_uninitialized_variables
  var args;
  // ignore: prefer_typing_uninitialized_variables
  var controlSet;
  // List pictures = [];
  List<Pictures> pictures = <Pictures>[];
  List questions = [];
  List options = [];
  bool isComplete = false;

  final Map<String, List<dynamic>> _config = {
    'image': [
      'assets/images/ga1.png',
      'assets/images/placa.jpg',
    ],
    'photo': [
      null,
      null,
    ],
    'zoom': [
      true,
      true,
    ]
  };

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
          // pictures = controlSet.pictures.map((model) => model).toList();
          pictures = controlSet.pictures;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
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
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
          floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xFFF8951D),
            tooltip: 'Capturar imagen',
            onPressed: () {
              pickImage(indexcam);
              getControlById();
            },
            child: const Icon(
              Icons.camera_alt,
              size: 35,
            ),
          ),
          body: ProgressHUD(
              inAsynCall: _isLoading, opacity: 0.3, child: _controlUI(context)),
          bottomNavigationBar: BottomAppBar(
            //shape: CircularNotchedRectangle(),
            notchMargin: 10,
            elevation: 10,
            color: const Color(0x2028329B),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                    icon: const Icon(
                      Icons.open_with,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      setState(() {
                        _config['zoom']![indexcam] =
                            !_config['zoom']![indexcam];
                      });
                    }),
                IconButton(
                    icon: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 30,
                    ),
                    onPressed: () {
                      // getControlById();
                      // final SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // final List<String> jsonList =
                      //     questions.map((item) => jsonEncode(item)).toList();
                      // prefs.setStringList('list', jsonList);
                      //print(prefs);
                      // Navigator.pushNamed(context, '/controlOption',
                      //     arguments: questions);
                      // Navigator.pushNamed(context, '/controlOptions',
                      //     arguments: questions);

                      if (isComplete) {
                        _succesfullFullPhotos();
                      } else {
                        _incompletePhotos();
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _controlUI(BuildContext context) {
    return Swiper(
      itemCount: pictures.length,
      layout: SwiperLayout.DEFAULT,
      itemHeight: 250.0,
      pagination: const SwiperPagination(
          builder: DotSwiperPaginationBuilder(
              color: Colors.grey, activeColor: Color(0xFFF8951D))),
      onIndexChanged: (val) {
        setState(() {
          indexcam = val;
        });
      },
      control: const SwiperControl(
        color: Color(0xFFF8951D),
      ),
      itemBuilder: (context, index) {
        return _photoContent(index);
      },
    );
  }

  Future pickImage(int i) async {
    var image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;
    setState(() {
      switch (i) {
        case 0:
          _config['photo']![0] = File(image.path);

          args['gallery']['img1'] = image;
          _validateFullPhotos();
          break;
        case 1:
          _config['photo']![1] = File(image.path);
          args['gallery']['img2'] = image;
          _validateFullPhotos();
          break;
      }
    });
  }

  void _validateFullPhotos() {
    if (args['gallery']['img1'] != null && args['gallery']['img2'] != null) {
      args['gallery']['state'] = true;

      setState(() {
        isComplete = true;
      });
    } else {
      setState(() {
        isComplete = false;
      });
    }
  }

  void _incompletePhotos() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Usted debe tomar todas las imágenes requeridas',
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

  void _succesfullFullPhotos() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Usted a completado la captura de fotos',
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text('Seleciones una opción'),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: const Color(0xC3E41111),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 12),
                            child: Text('Cancelar',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                  fontSize: 16,
                                )),
                          )),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/controlOptions',
                                arguments: args);
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
                  )
                ],
              ),
            ));
  }

  Widget _photoContent(int i) {
    return Stack(
      children: [
        Align(
            alignment: Alignment.center,
            child: SizedBox(
              // decoration: const BoxDecoration(
              //     image: DecorationImage(
              //         image: AssetImage('assets/images/cool.png'),
              //         fit: BoxFit.cover)),
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              child: FadeInImage(
                  fit: _config['zoom']![i] ? BoxFit.contain : BoxFit.cover,
                  placeholder: const AssetImage('assets/images/loading.gif'),
                  image: _config['photo']![i] == null
                      ? AssetImage(_config['image']![i]) as ImageProvider
                      : FileImage(_config['photo']![i])),
            )),
        Align(
            alignment: Alignment.topLeft,
            child: Container(
              color: const Color(0x2028329B),
              child: ListTile(
                title: Text(pictures[i].name,
                    style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold)),
                subtitle: Text(
                  pictures[i].description,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ))
      ],
    );
  }
}
