import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:submission2/ui/custom_rating_bar.dart';
import 'package:submission2/model/detail_resturant_decode.dart';

class TopReviewList extends StatelessWidget {
  final DecodedRestaurant detail;
  final baseImageUrl = 'https://restaurant-api.dicoding.dev/images/small/';
  TopReviewList({@required this.detail});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          flex: 2,
          child: Center(
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.grey[300]),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        detail.rating.toString() + ' /',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w500),
                      ),
                      Text(
                        '\u2085',
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 28),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  CustomRatingBar(bintang: detail.rating, mySize: 15.0),
                  SizedBox(
                    height: 5,
                  ),
                  Text(detail.customerReviews.length.toString() + ' Reviews')
                ],
              ),
            ),
          ),
        ),
        Flexible(
          flex: 5,
          child: Container(
            height: 120,
            width: 5000,
            decoration: BoxDecoration(
              border: Border.symmetric(
                horizontal: BorderSide(color: Colors.grey[300], width: 2),
              ),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(baseImageUrl + detail.pictureId),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.4)),
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    color: Colors.black,
                    padding: EdgeInsets.all(3),
                    child: Text(
                      detail.name,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
