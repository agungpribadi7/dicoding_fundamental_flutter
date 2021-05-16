import 'package:flutter/material.dart';
import 'package:submission2/ui/detail_restaurant.dart';
import 'package:submission2/model/detail_resturant_decode.dart';

class CustomListTile extends StatelessWidget {
  final DecodedRestaurant restaurantDetail;
  final baseImageUrl = 'https://restaurant-api.dicoding.dev/images/small/';

  CustomListTile({@required this.restaurantDetail});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, DetailRestaurant.routeName,
            arguments: restaurantDetail.id);
      },
      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 15),
      leading: Hero(
        tag: restaurantDetail.pictureId,
        child: Image.network(
          baseImageUrl + restaurantDetail.pictureId,
          fit: BoxFit.fill,
          width: 100,
        ),
      ),
      title: Text(restaurantDetail.name),
      subtitle: Text(
        restaurantDetail.description,
        maxLines: 3,
      ),
    );
  }
}
