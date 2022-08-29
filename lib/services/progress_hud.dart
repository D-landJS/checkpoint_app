import 'package:flutter/material.dart';

class ProgressHUD extends StatelessWidget {
  const ProgressHUD(
      {Key? key,
      required this.child,
      required this.inAsynCall,
      this.opacity = 0.3,
      this.color = Colors.grey})
      : super(key: key);

  final Widget child;
  final bool inAsynCall;
  final double opacity;
  final Color color;
  // final Animation<Color> valueColor;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsynCall) {
      final modal = Stack(
        children: [
          Opacity(
            opacity: opacity,
            child: ModalBarrier(
              dismissible: false,
              color: color,
            ),
          ),
          const Center(
            child: CircularProgressIndicator(),
          )
        ],
      );
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
