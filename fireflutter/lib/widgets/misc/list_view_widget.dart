import 'package:flutter/material.dart';

class ListViewWidget extends StatelessWidget {

  final Widget widget;
  final EdgeInsetsGeometry margin;

  ListViewWidget({Key key, this.widget, this.margin});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: margin!= null ? margin : EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 0.0),
      child: widget,
    );
  }
}
