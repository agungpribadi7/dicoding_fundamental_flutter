import 'package:flutter/material.dart';
import 'package:submission2/model/api_service.dart';
import 'package:submission2/ui/custom_list_menu.dart';
import 'package:submission2/model/detail_resturant_decode.dart';
import 'package:submission2/model/restaurant_decode.dart';
import 'package:submission2/ui/show_shimmer.dart';

class ButtonMain extends StatefulWidget {
  final List<Restaurant> restaurants;
  ButtonMain({@required this.restaurants});

  @override
  _ButtonMainState createState() => _ButtonMainState();
}

class _ButtonMainState extends State<ButtonMain> {
  List<Future<DetailRestaurantApi>> detail = [];
  List<DetailRestaurantApi> resultRestaurantDetail = [];
  var isFinished = false;

  @override
  void initState() {
    super.initState();
    initDetail();
  }

  void initDetail() {
    for (var restaurant in widget.restaurants) {
      Future<DetailRestaurantApi> getDetail =
          ApiService().getDetailRestaurant(restaurant.id);
      detail.add(getDetail);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.restaurants.length != resultRestaurantDetail.length &&
        resultRestaurantDetail.isNotEmpty) {
      detail = [];
      resultRestaurantDetail = [];
      isFinished = false;
      initDetail();
    }
    if (widget.restaurants.isEmpty) {
      return Column(
        children: [
          Image.network('https://i.ibb.co/FkpWQ4w/nodataflutterprojek.png'),
          Text('No Data Found', style: Theme.of(context).textTheme.headline4),
        ],
      );
    }

    return Expanded(
      child: (!isFinished)
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 2000,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return FutureBuilder<DetailRestaurantApi>(
                          future: detail[index],
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              resultRestaurantDetail.add(snapshot.data);
                              Future.delayed(Duration.zero, () async {
                                if (index == widget.restaurants.length - 1) {
                                  setState(() {
                                    isFinished = true;
                                  });
                                }
                              });
                            }
                            return CustomShimmer();
                          },
                        );
                      },
                      itemCount: widget.restaurants.length,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CustomListTile(
                  restaurantDetail: resultRestaurantDetail[index].restaurant,
                );
              },
              itemCount: resultRestaurantDetail.length,
            ),
    );
  }
}
