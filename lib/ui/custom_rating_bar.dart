import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  final double mySize;
  final double bintang;
  CustomRatingBar({@required this.bintang, @required this.mySize});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
        rating: bintang,
        itemBuilder: (context, index) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
        itemCount: 5,
        itemSize: mySize,
        direction: Axis.horizontal);
  }
}
