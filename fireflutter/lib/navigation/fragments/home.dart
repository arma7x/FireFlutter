import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fireflutter/state/provider_state.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title, this.loadingCb}) : super(key: key);

  final String title;
  final Function loadingCb;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  double _pxRatio;

  @override
  Widget build(BuildContext context) {

    _pxRatio = MediaQuery.of(context).devicePixelRatio;
    final counter = Provider.of<Counter>(context);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
              style: TextStyle(
                fontSize: 8.5 * _pxRatio,
                fontWeight: FontWeight.normal,
              )
            ),
            Text(
              '${counter.count}',
              style: TextStyle(
                fontSize: 18.5 * _pxRatio,
                fontWeight: FontWeight.normal,
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Provider.of<Counter>(context, listen: false).increment();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
