import 'package:flutter/material.dart';
import 'package:submission2/model/detail_resturant_decode.dart';
import 'package:submission2/ui/custom_alert_dialog.dart';
import 'package:submission2/ui/review_list_top.dart';
import 'package:submission2/ui/card_reviews.dart';

class ReviewList extends StatelessWidget {
  static const routeName = '/review';
  final DecodedRestaurant detail;
  ReviewList({@required this.detail});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reviews'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TopReviewList(detail: detail),
            Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Reviews',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                  MyAlert(
                    detail: detail,
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  ReviewCards(
                    detail: detail,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
