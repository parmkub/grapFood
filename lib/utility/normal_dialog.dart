import 'package:flutter/material.dart';
import 'package:grapfood/utility/my_style.dart';
import '../main.dart';

Future<void> normalDialog(BuildContext context, String message) async {
  showDialog(
      context: context,
      builder: (context) => SimpleDialog(
            title: Text(message),
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.question_answer_rounded,
                    size: 50,
                    color: MyStyle().primaryColor,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  // ignore: deprecated_member_use
                  FlatButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(
                      'OK',
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                ],
              )
            ],
          ));
}
