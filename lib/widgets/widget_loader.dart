import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  String texto;

  Loader({this.texto});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircularProgressIndicator(
            strokeWidth: 5.0,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            this.texto,
            style: TextStyle(
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
