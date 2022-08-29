import 'dart:convert';

import 'package:checkpoint_segursat/model/login_model.dart';
import 'package:checkpoint_segursat/services/api_service.dart';
import 'package:checkpoint_segursat/services/progress_hud.dart';
import 'package:checkpoint_segursat/utils/form_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool passwordVisible = true;
  bool _isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  sign(String email, password) async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      ApiServices.validateCredentials(email, password).then((res) {
        setState(() {
          _isLoading = false;
        });
        if (res.statusCode == 200) {
          var data = User.fromJson(json.decode(res.body));
          formKey.currentState!.reset();
          Navigator.pushNamed(context, '/home', arguments: data);
        } else if (res.statusCode == 403) {
          FormHelper.showMessage(
              context, "Login", "Invalid Username/Password", "OK", () {
            Navigator.of(context).pop();
          });
        } else if (res.statusCode >= 500 && res.statusCode < 512) {
          FormHelper.showMessage(context, "Login",
              "Error, comunicarse con sistemas Segursat S.A.C.", "OK", () {
            Navigator.of(context).pop();
          });
        } else {
          FormHelper.showMessage(context, "Login", "Error de conexión", "OK",
              () {
            Navigator.of(context).pop();
          });
        }
      });
    }
  }

  final emailValidator = MultiValidator([
    RequiredValidator(errorText: "Email is required"),
    EmailValidator(errorText: "Not A Valid Email"),
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'Password is required'),
    MinLengthValidator(4, errorText: 'Password must be at least 4 digits long'),
  ]);

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
            body: SafeArea(
                child: ProgressHUD(
                    inAsynCall: _isLoading,
                    opacity: 0.3,
                    child: _loginUI(context))),
          ),
        ));
  }

  Widget _loginUI(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.all(25.0),
              child: Image.asset(
                'assets/images/logo_sat.png',
                width: MediaQuery.of(context).size.width * 0.90,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Text('Bienvenido de Vuelta',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                    color: const Color(0xFFF4F4F8))),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Que bueno verte otra vez 😃',
              style: GoogleFonts.poppins(
                  fontSize: 18, color: const Color(0xFFF4F4F8)),
            ),
            const SizedBox(height: 40),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  // child: FormHelper.inputFieldWidget(context: context, initialValue: "", onValidate: emailValidator)
                  child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "You@example.com",
                      ),
                      validator: emailValidator),
                )),
            const SizedBox(height: 20),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: TextFormField(
                    controller: passwordController,
                    obscureText: passwordVisible,
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12)),
                        hintText: "Password",
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFFF8951D),
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        )),
                    validator: passwordValidator,
                  ),
                )),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: GestureDetector(
                onTap: () {
                  sign(emailController.text, passwordController.text);
                },
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: const Color(0xFFF8951D),
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: Text('Iniciar Sesión',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: const Color(0xFFF8F6F4),
                          )),
                    ),
                  ),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
