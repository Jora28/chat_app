import 'package:chat_app/widgets/style_color.dart';
import 'package:flutter/material.dart';

class CustomInput extends StatelessWidget {
  final String hintText;
  final IconData prefix;
  final Color color;

  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType type;

  CustomInput({
    this.color,
    this.hintText,
    this.prefix,
    this.onSaved,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.type,
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: type,
      validator: validator,
      onSaved: onSaved,
      cursorColor: Colors.black,
      textAlignVertical: TextAlignVertical.center,
      controller: controller,
      obscureText: obscureText,
      style:inputTextStyle,
      decoration: InputDecoration(
       contentPadding: EdgeInsets.only(left:17,top: 10,bottom: 10,right: 10),
        prefixIcon: Icon(
          prefix,
          color: Colors.black,
          size: 20,
        ),
        isDense: true,
        filled: true,
        fillColor: color,
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none),
        focusColor: Colors.black,
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.black),
        labelStyle: inputTextStyle,
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0))),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            borderSide: BorderSide(color: Colors.grey.withOpacity(0))),
      ),
    );
  }
}
