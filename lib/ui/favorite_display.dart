import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission2/provider/db_provider.dart';
import 'package:submission2/ui/buttom_main.dart';

class FavoriteDisplay extends StatefulWidget {
  static final routeName = "/favorites";

  @override
  _FavoriteDisplayState createState() => _FavoriteDisplayState();
}

class _FavoriteDisplayState extends State<FavoriteDisplay> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Consumer<DbProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.HasData) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ButtonMain(restaurants: provider.restaurants),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
