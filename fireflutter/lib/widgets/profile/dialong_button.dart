import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {

  final String text;
  final IconData icon;
  final Function fn;

  DialogButton({Key key, this.text, this.icon, this.fn});

  @override
  Widget build(BuildContext context) {

    return new Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 0,
        highlightElevation: 0,
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 15.0),
        onPressed: fn,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(icon, size: 25, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.normal)
            ),
          ]
        )
      ),
    );
  }
}
