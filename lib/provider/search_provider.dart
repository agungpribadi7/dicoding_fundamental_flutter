import 'package:submission2/model/api_service.dart';

import 'package:flutter/material.dart';
import 'package:submission2/model/search_decode.dart';

enum ResultState { Loading, NoData, HasData, Error }

class SearchProvider extends ChangeNotifier {
  final ApiService apiService;
  SearchRestaurantApi _restaurantResult;
  ResultState _state;
  String _message = '';

  SearchProvider({@required this.apiService});

  String get message => _message;
  SearchRestaurantApi get result => _restaurantResult;
  ResultState get state => _state;

  Future<dynamic> fetchSearchResult(String keyword) async {
    try {
      _state = ResultState.Loading;
      notifyListeners();
      final result = await ApiService().getSearchResult(keyword);
      if (result.restaurants.isEmpty) {
        _state = ResultState.NoData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.HasData;
        notifyListeners();
        return _restaurantResult = result;
      }
    } catch (e) {
      _state = ResultState.Error;
      notifyListeners();
      return _message = 'Error --> $e';
    }
  }

  void reset() {
    fetchSearchResult('keyword_reset');
    _state = ResultState.NoData;
    // This call tells the widgets that are listening to this model to rebuild.
    notifyListeners();
  }
}
