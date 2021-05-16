import 'package:flutter/material.dart';

class TopMain extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      color: Colors.brown,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Restaurant',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            'Recommendation restaurants for you',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}
