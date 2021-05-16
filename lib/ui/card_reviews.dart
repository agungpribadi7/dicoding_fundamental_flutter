import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission2/model/detail_resturant_decode.dart';
import 'package:submission2/provider/review_provider.dart';

class ReviewCards extends StatefulWidget {
  final DecodedRestaurant detail;
  ReviewCards({@required this.detail});

  @override
  _ReviewCardsState createState() => _ReviewCardsState();
}

class _ReviewCardsState extends State<ReviewCards> {
  @override
  void initState() {
    super.initState();
    final reviewProvider = Provider.of<ReviewProvider>(context, listen: false);
    reviewProvider.fetchReviewResult(widget.detail.id);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ReviewProvider>(builder: (context, state, widget) {
      if (state.state == ResultState.Loading) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state.state == ResultState.HasData) {
        List<CustomerReview> listReview = state.result.customerReviews;
        return Column(
          children: [
            for (var review in listReview)
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 6,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.grey[200],
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  review.name,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  review.date,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(review.review)
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      } else {
        return Column(
          children: [
            Image.network('https://i.ibb.co/FkpWQ4w/nodataflutterprojek.png'),
            Text('No Data Found', style: Theme.of(context).textTheme.headline4),
          ],
        );
      }
    });
  }
}
