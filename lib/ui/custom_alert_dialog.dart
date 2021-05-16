import 'package:flutter/material.dart';
import 'package:submission2/model/api_service.dart';
import 'package:submission2/model/detail_resturant_decode.dart';
import 'package:provider/provider.dart';
import 'package:submission2/provider/review_provider.dart';

final _text = TextEditingController();
final _textReview = TextEditingController();
bool _validate = true;
bool _validateReview = true;

class MyAlert extends StatefulWidget {
  final DecodedRestaurant detail;
  MyAlert({@required this.detail});
  _MyAlertState createState() => _MyAlertState();
}

class _MyAlertState extends State<MyAlert> {
  @override
  Widget build(BuildContext context) {
    Future<void> _showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Give a Review'),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Text('Name'),
                  TextField(
                    controller: _text,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'John',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text('Review'),
                  TextField(
                    controller: _textReview,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Barangnya bagus',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Send'),
                onPressed: () {
                  setState(() {
                    _text.text.isEmpty ? _validate = false : _validate = true;
                    _textReview.text.isEmpty
                        ? _validateReview = false
                        : _validateReview = true;
                  });
                  if (_validateReview && _validate) {
                    ApiService().addNewReview(
                        widget.detail.id, _text.text, _textReview.text);

                    final reviewProvider =
                        Provider.of<ReviewProvider>(context, listen: false);
                    reviewProvider.fetchReviewResult(widget.detail.id);
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Please fill all fields',
                          style: TextStyle(
                              color: Colors.yellow[600],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }
                },
              ),
            ],
          );
        },
      );
    }

    return ElevatedButton(
      child: Text('Add a Review'),
      onPressed: () {
        return _showMyDialog();
      },
    );
  }
}
