import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {

  final String text;
  final IconData icon;
  final Function fn;

  ActionButton({Key key, this.text, this.icon, this.fn});

  @override
  Widget build(BuildContext context) {

    return new Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        onPressed: fn,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 14.0, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: Colors.grey, fontSize: 14.0, fontWeight: FontWeight.normal)
            ),
          ]
        )
      ),
    );
  }
}
