import 'package:flutter/material.dart';

class DialogButton extends StatelessWidget {

  final String text;
  final IconData icon;
  final Function fn;
  double _pxRatio;

  DialogButton({Key key, this.text, this.icon, this.fn});

  @override
  Widget build(BuildContext context) {

    _pxRatio = MediaQuery.of(context).devicePixelRatio;

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
            Icon(icon, size: 8.2 * _pxRatio, color: Colors.blueAccent),
            SizedBox(width: 10),
            Text(
              text,
              style: TextStyle(color: Colors.black, fontSize: 8.2 * _pxRatio, fontWeight: FontWeight.normal)
            ),
          ]
        )
      ),
    );
  }
}
