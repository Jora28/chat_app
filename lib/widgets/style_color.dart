import 'package:flutter/material.dart';

const scaffoldPadding = EdgeInsets.symmetric(horizontal: 40);

const newColor1 = Color(0xFF56c596);
const newColor3 = Color(0xFF205072);

const chatColors1 = Color(0xFF0A8270);
const chatColors2 = Color(0xFF7cFF6B);

const newColor2 = Color(0xFF329D9C);
const newColor4 = Color(0xFF50D5B7);

const messageColor = Color(0xFFbbbfca);

var gradient = const LinearGradient(
  colors: [
    Color(0xFF50D5B7),
    Color(0xFF067D68),
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

const nameSurnameTextStayleInCards = const TextStyle(
    color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500);

const inputTextStyle = const TextStyle(
    fontSize: 18, color: Colors.black, fontWeight: FontWeight.w300);
