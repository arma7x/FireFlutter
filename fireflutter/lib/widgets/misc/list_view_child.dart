import 'package:flutter/material.dart';

class ListViewChild extends StatelessWidget {

  final String title;
  final String subtitle;
  final EdgeInsetsGeometry margin;

  ListViewChild({Key key, this.title, this.subtitle, this.margin});

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      margin: margin!= null ? margin : EdgeInsets.fromLTRB(50.0, 5.0, 50.0, 0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.normal
            )
          ),
          SizedBox(height: 5),
          Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.normal, color: Colors.grey)
          ),
        ]
      ),
    );
  }
}
