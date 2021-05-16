import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:submission2/utils/database_helper.dart';
import 'package:submission2/model/restaurant_decode.dart';

enum ResultState { Loading, NoData, HasData, Error }

class DbProvider extends ChangeNotifier {
  List<Restaurant> _restaurants = [];
  DatabaseHelper _dbHelper;
  ResultState _state;
  ResultState get state => _state;

  List<Restaurant> get restaurants => _restaurants;

  DbProvider() {
    _dbHelper = DatabaseHelper();
    _getAllRestaurants();
  }

  void _getAllRestaurants() async {
    _state = ResultState.Loading;
    _restaurants = await _dbHelper.getRestaurants();
    notifyListeners();
    _state = ResultState.HasData;
  }

  Future<void> addRestaurant(Restaurant restaurant) async {
    await _dbHelper.insertRestaurant(restaurant);
    _getAllRestaurants();
  }

  Future<Restaurant> getRestaurantById(String id) async {
    var isFavorite = await _dbHelper.getDataById(id);
    if (isFavorite.id.isEmpty) {
      return null;
    } else {
      return isFavorite;
    }
  }

  Future<bool> isFavorite(String id) async {
    final result = _dbHelper.getDataById(id).toString();
    if (result == "null" || result.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  void deleteRestaurant(String id) async {
    _state = ResultState.Loading;
    await _dbHelper.deleteRestaurant(id);
    _getAllRestaurants();
    _state = ResultState.HasData;
  }
}
