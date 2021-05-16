import 'package:submission2/model/api_service.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:submission2/model/detail_resturant_decode.dart';

enum ResultState { Loading, NoData, HasData, Error }

class ReviewProvider extends ChangeNotifier {
  final ApiService apiService;
  String id;
  DecodedRestaurant _reviewResult;
  ResultState _state;
  String _message = '';
  ReviewProvider({@required this.apiService});

  String get message => _message;
  DecodedRestaurant get result => _reviewResult;
  ResultState get state => _state;

  Future<dynamic> fetchReviewResult(String id) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await ApiService().getDetailRestaurant(id);
      if (result.restaurant.id.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _reviewResult = result.restaurant;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }
}
