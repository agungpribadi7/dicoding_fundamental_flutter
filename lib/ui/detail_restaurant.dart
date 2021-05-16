import 'package:flutter/material.dart';
import 'package:submission2/model/api_service.dart';
import 'package:submission2/model/restaurant_decode.dart';
import 'package:submission2/provider/db_provider.dart';
import 'package:submission2/ui/foods_and_drinks.dart';
import 'package:submission2/model/detail_resturant_decode.dart';
import 'package:submission2/no_internet.dart';
import 'package:submission2/provider/connectivity_provider.dart';
import 'package:submission2/ui/review_list.dart';
import 'package:provider/provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:favorite_button/favorite_button.dart';

// ignore: must_be_immutable
class DetailRestaurant extends StatefulWidget {
  final String id;
  static final routeName = '/detail';
  DetailRestaurant({this.id});

  @override
  _DetailRestaurantState createState() => _DetailRestaurantState();
}

class _DetailRestaurantState extends State<DetailRestaurant> {
  final baseImageUrl = 'https://restaurant-api.dicoding.dev/images/small/';
  ScrollController myScrollController = new ScrollController();
  final double expandedHeight = 200.0;
  Future<DecodedRestaurant> detail;

  @override
  void initState() {
    super.initState();
    myScrollController = new ScrollController();
    myScrollController.addListener(() => setState(() {}));
    detail = getDetail();
  }

  Future<DecodedRestaurant> getDetail() async {
    var result = await ApiService()
        .getDetailRestaurant(widget.id)
        .then((value) => value.restaurant);
    return result;
  }

  bool isFavorite() {
    final result = Provider.of<DbProvider>(context, listen: false).restaurants;
    for (var restaurant in result) {
      if (restaurant.id == widget.id) {
        return true;
      }
    }
    return false;
  }

  @override
  void dispose() {
    myScrollController.dispose();
    super.dispose();
  }

  double get top {
    double res = expandedHeight - 20;
    if (myScrollController.hasClients) {
      double offset = myScrollController.offset;
      res -= offset;
    }
    return res;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer2(builder: (BuildContext context,
          ConnectivityChangeNotifier connectivityChangeNotifier,
          DbProvider dbProvider,
          Widget child) {
        if (connectivityChangeNotifier.connectivity ==
                ConnectivityResult.wifi ||
            connectivityChangeNotifier.connectivity ==
                ConnectivityResult.mobile) {
          return LayoutBuilder(
            builder: (ctx, constrains) {
              return FutureBuilder(
                future: detail,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return SingleChildScrollView(
                      child: Stack(
                        children: [
                          Container(
                            height: 1500,
                            width: 700,
                            child: NestedScrollView(
                              controller: myScrollController,
                              headerSliverBuilder:
                                  (context, innerBoxIsScrolled) {
                                return [
                                  SliverAppBar(
                                    expandedHeight: expandedHeight,
                                    flexibleSpace: FlexibleSpaceBar(
                                      background: FittedBox(
                                        child: Hero(
                                          tag: snapshot.data.pictureId,
                                          child: Image.network(baseImageUrl +
                                              snapshot.data.pictureId),
                                        ),
                                        fit: BoxFit.fitWidth,
                                      ),
                                    ),
                                  ),
                                ];
                              },
                              body: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 150,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 35,
                                    ),
                                    Text(
                                      'Description',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(snapshot.data.description),
                                    SizedBox(
                                      height: 50,
                                    ),
                                    Text(
                                      'Foods',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CustomList(menu: snapshot.data.menus.foods),
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Text(
                                      'Drinks',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    CustomList(
                                        menu: snapshot.data.menus.drinks),
                                    SizedBox(
                                      height: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: top,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              clipBehavior: Clip.hardEdge,
                              fit: StackFit.loose,
                              children: [
                                Align(
                                  child: Card(
                                    margin: EdgeInsets.all(30),
                                    elevation: 3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          child: Padding(
                                            padding: EdgeInsets.all(20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data.name +
                                                      ' - ' +
                                                      snapshot.data.city +
                                                      '  ',
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  snapshot.data.address,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                  ),
                                                  textAlign: TextAlign.start,
                                                ),
                                                SizedBox(height: 5),
                                                Row(
                                                  children: [
                                                    InkWell(
                                                      splashColor: Colors.green,
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            ReviewList
                                                                .routeName,
                                                            arguments:
                                                                snapshot.data);
                                                      },
                                                      child: Chip(
                                                        backgroundColor:
                                                            Colors.grey[200],
                                                        label: Row(
                                                          children: [
                                                            Icon(
                                                              Icons.star_rate,
                                                              color: Colors
                                                                  .yellow[700],
                                                            ),
                                                            Text(snapshot
                                                                .data.rating
                                                                .toString()),
                                                            Text(' (' +
                                                                snapshot
                                                                    .data
                                                                    .customerReviews
                                                                    .length
                                                                    .toString() +
                                                                ')'),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    for (var category
                                                        in snapshot
                                                            .data.categories)
                                                      if (snapshot
                                                              .data.categories
                                                              .indexOf(
                                                                  category) <
                                                          4)
                                                        InkWell(
                                                          child: Chip(
                                                            backgroundColor:
                                                                Colors
                                                                    .lightBlue,
                                                            label: Text(
                                                              category.name,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          ),
                                                        ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.all(15),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        FavoriteButton(
                                          isFavorite: isFavorite(),
                                          // iconDisabledColor: Colors.white,
                                          valueChanged: (_isFavorite) {
                                            if (_isFavorite == true) {
                                              dbProvider.addRestaurant(
                                                Restaurant(
                                                    id: snapshot.data.id,
                                                    city: snapshot.data.city,
                                                    description: snapshot
                                                        .data.description,
                                                    name: snapshot.data.name,
                                                    pictureId:
                                                        snapshot.data.pictureId,
                                                    rating:
                                                        snapshot.data.rating),
                                              );
                                            } else {
                                              dbProvider.deleteRestaurant(
                                                  snapshot.data.id);
                                            }
                                          },
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  else
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                },
              );
            },
          );
        } else {
          return NoInternet();
        }
      }),
    );
  }
}
