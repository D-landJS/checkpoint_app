import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Image.asset(
        'assets/images/logo.png',
        width: MediaQuery.of(context).size.width * 0.70,
        fit: BoxFit.cover,
        // height: 150,
      ),
      backgroundColor: const Color(0x2028329B),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
