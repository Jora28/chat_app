import 'package:chat_app/widgets/style_color.dart';
import 'package:flutter/material.dart';
class CustumButton extends StatelessWidget {
  final String text;
  final Function onTap;
  CustumButton({this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: newColor4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
          child: Text(text),
          onPressed: onTap),
    );
  }
}
