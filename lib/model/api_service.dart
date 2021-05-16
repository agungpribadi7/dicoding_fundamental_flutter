import 'package:submission2/model/detail_resturant_decode.dart';
import 'package:submission2/model/search_decode.dart';
import 'restaurant_decode.dart';
import 'package:http/http.dart' show Client;
import 'dart:convert';

class ApiService {
  final String _baseUrl = 'https://restaurant-api.dicoding.dev/';
  final String _baseUrlTanpaProtokol = 'restaurant-api.dicoding.dev';
  final String _apiKey = '12345';
  Client client = Client();

  Future<RestaurantApi> getAllRestaurants() async {
    final response = await client.get(Uri.parse(_baseUrl + '/list'));
    if (response.statusCode == 200) {
      return RestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to load restaurant');
    }
  }

  Future<DetailRestaurantApi> getDetailRestaurant(String id) async {
    final response = await client.get(Uri.parse(_baseUrl + "/detail/" + id));

    if (response.statusCode == 200) {
      return DetailRestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to get detail');
    }
  }

  Future<SearchRestaurantApi> getSearchResult(String keyword) async {
    final response = await client
        .get(Uri.parse(_baseUrl + "/search?q=" + keyword.toLowerCase()));
    if (response.statusCode == 200) {
      return SearchRestaurantApi.fromJson(json.decode(response.body));
    } else {
      throw Exception('failed to find restaurants');
    }
  }

  Future<String> addNewReview(String id, String name, String review) async {
    Map<String, dynamic> convertedToJson = {
      "id": id,
      "name": name,
      "review": review,
    };
    final response = await client.post(
      Uri.https(_baseUrlTanpaProtokol, 'review'),
      headers: {
        'Content-Type': 'application/json',
        'X-Auth-Token': _apiKey,
      },
      body: jsonEncode(convertedToJson),
    );

    if (response.statusCode == 200) {
      return "Success";
    } else {
      throw Exception('Failed to add a review');
    }
  }
}
