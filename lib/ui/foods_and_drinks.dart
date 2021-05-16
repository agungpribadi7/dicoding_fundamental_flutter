import 'package:flutter/material.dart';
import 'package:submission2/model/detail_resturant_decode.dart';

class CustomList extends StatelessWidget {
  final List<Category> menu;
  CustomList({@required this.menu});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: InkWell(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.brown,
                ),
                width: 200.0,
                child: Center(
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: Text(
                      menu[index].name,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: menu.length,
      ),
    );
  }
}
