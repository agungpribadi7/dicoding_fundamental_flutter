import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';
import 'package:submission2/model/api_service.dart';

var expectedReturn = {
  "error": false,
  "message": "success",
  "restaurant": {
    "id": "s1knt6za9kkfw1e867",
    "name": "Kafe Kita",
    "description":
        "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc,",
    "city": "Gorontalo",
    "address": "Jln. Pustakawan no 9",
    "pictureId": "25",
    "categories": [
      {"name": "Sop"},
      {"name": "Modern"}
    ],
    "menus": {
      "foods": [
        {"name": "Kari kacang dan telur"},
        {"name": "Ikan teri dan roti"},
        {"name": "roket penne"},
        {"name": "Salad lengkeng"},
        {"name": "Tumis leek"},
        {"name": "Salad yuzu"},
        {"name": "Sosis squash dan mint"}
      ],
      "drinks": [
        {"name": "Jus tomat"},
        {"name": "Minuman soda"},
        {"name": "Jus apel"},
        {"name": "Jus mangga"},
        {"name": "Es krim"},
        {"name": "Kopi espresso"},
        {"name": "Jus alpukat"},
        {"name": "Coklat panas"},
        {"name": "Es kopi"},
        {"name": "Teh manis"},
        {"name": "Sirup"},
        {"name": "Jus jeruk"}
      ]
    },
    "rating": 4,
    "customerReviews": [
      {
        "name": "Ahmad",
        "review": "Tidak ada duanya!",
        "date": "13 November 2019"
      },
      {
        "name": "Arif",
        "review": "Tidak rekomendasi untuk pelajar!",
        "date": "13 November 2019"
      },
      {
        "name": "Gilang",
        "review": "Tempatnya bagus namun menurut saya masih sedikit mahal.",
        "date": "14 Agustus 2018"
      },
      {
        "name": "Tes",
        "review": "Jir reviewnya diapus wkkw",
        "date": "16 Mei 2021"
      },
      {"name": "Tes", "review": "add", "date": "16 Mei 2021"},
      {"name": "tes", "review": "asd", "date": "16 Mei 2021"},
      {"name": "tes", "review": "banyak tes", "date": "16 Mei 2021"},
      {"name": "fdhdhdh", "review": "hdhdhdh", "date": "16 Mei 2021"},
      {"name": "p", "review": "hebat", "date": "16 Mei 2021"},
      {"name": "aww", "review": "www", "date": "16 Mei 2021"},
      {
        "name": "anonitun",
        "review": "makanannya virtual",
        "date": "16 Mei 2021"
      },
      {"name": "ad", "review": "add", "date": "16 Mei 2021"},
      {"name": "123", "review": "123", "date": "16 Mei 2021"},
      {"name": "123", "review": "123", "date": "16 Mei 2021"},
      {"name": "john", "review": "john", "date": "16 Mei 2021"},
      {"name": "john2", "review": "john", "date": "16 Mei 2021"},
      {"name": "john3", "review": "john", "date": "16 Mei 2021"},
      {"name": "john4", "review": "john", "date": "16 Mei 2021"},
      {"name": "john5", "review": "john", "date": "16 Mei 2021"},
      {"name": "john6", "review": "john", "date": "16 Mei 2021"},
      {"name": "john7", "review": "john", "date": "16 Mei 2021"},
      {"name": "john8", "review": "john", "date": "16 Mei 2021"},
      {"name": "john9", "review": "john", "date": "16 Mei 2021"},
      {"name": "a", "review": "a", "date": "16 Mei 2021"},
      {"name": "asd", "review": "jancuuuuk", "date": "16 Mei 2021"},
      {"name": "asd", "review": "jancuuuuk", "date": "16 Mei 2021"}
    ]
  }
};

void main() {
  test('Get Detail Restaurant', () async {
    final myApi = ApiService();
    myApi.client = MockClient((request) async {
      return Response(json.encode(expectedReturn), 200);
    });

    final item = await myApi.getDetailRestaurant("s1knt6za9kkfw1e867");
    expect(item.restaurant.name, "Kafe Kita");
    expect(item.restaurant.id, "s1knt6za9kkfw1e867");
  });
}
