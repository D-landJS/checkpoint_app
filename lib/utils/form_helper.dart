import 'package:flutter/material.dart';

class FormHelper {
  static Widget inputFieldWidget(
      {required BuildContext context,
      Object? initialValue,
      obscureText = false,
      required String hintText,
      required Function onValidate,
      Widget? prefixIcon,
      Widget? suffixIcon}) {
    return TextFormField(
        initialValue: initialValue != null ? initialValue.toString() : "",
        decoration:
            fieldDecoration(context, hintText, "", suffixIcon: suffixIcon),
        obscureText: obscureText,
        validator: onValidate());
  }

  static InputDecoration fieldDecoration(
      BuildContext context, String hintText, String helperText,
      {Widget? prefixIcon, Widget? suffixIcon}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      hintText: hintText,
      suffixIcon: suffixIcon,
    );
  }

  static void showMessage(BuildContext context, String title, String message,
      String buttonText, Function onPressed) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: [
              TextButton(
                  onPressed: () async {
                    return onPressed();
                  },
                  child: Text(buttonText))
            ],
          );
        });
  }
}
