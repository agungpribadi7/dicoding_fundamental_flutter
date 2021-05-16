import 'dart:convert';
import 'restaurant_decode.dart';

SearchRestaurantApi searchRestaurantApiFromJson(String str) =>
    SearchRestaurantApi.fromJson(json.decode(str));

class SearchRestaurantApi {
  SearchRestaurantApi({
    this.error,
    this.founded,
    this.restaurants,
  });

  bool error;
  int founded;
  List<Restaurant> restaurants;

  factory SearchRestaurantApi.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantApi(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );
}
