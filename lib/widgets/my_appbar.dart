import 'package:chat_app/screens/search_page.dart';
import 'package:chat_app/widgets/inpurs.dart';
import 'package:chat_app/widgets/style_color.dart';
import 'package:flutter/material.dart';

class AppBarSliver extends StatelessWidget {
  const AppBarSliver();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 40),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30)),
          color: newColor4),
      child: Row(
        children: [
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 40),
              child: CustomInput(
                  color: Colors.white,
                  prefix: Icons.search,
                  hintText: "Search users",
                  obscureText: false),
            ),
          ),
          Container(
              margin: EdgeInsets.only(right: 20, top: 40),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Colors.black,
                    padding: EdgeInsets.symmetric(vertical:15,horizontal: 15),
                    primary: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30))),
                  onPressed: () {
                    Navigator.of(context)
                        .pushReplacementNamed(SearchPage.routeName);
                  },
                  child: Text('Search')))
        ],
      ),
    );
  }
}
