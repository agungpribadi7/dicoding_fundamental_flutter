import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:submission2/main.dart';
import 'package:submission2/ui/buttom_main.dart';
import 'package:submission2/model/restaurant_decode.dart';
import 'package:submission2/provider/search_provider.dart';

var _textController = TextEditingController();
final FocusNode _submitFocus = FocusNode();

class SearchRestaurant extends StatefulWidget {
  static const routeName = '/search';
  @override
  _SearchRestaurantState createState() => _SearchRestaurantState();
}

class _SearchRestaurantState extends State<SearchRestaurant> {
  @override
  void initState() {
    super.initState();
    _textController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Restaurant'),
      ),
      body: Scrollbar(
        child: Consumer<SearchProvider>(
          builder: (context, state, widget) {
            if (state.state == ResultState.Loading) {
              return Column(children: [
                CustomSearchBox(provider: state),
                CircularProgressIndicator(),
              ]);
            } else if (state.state == ResultState.HasData) {
              List<Restaurant> listRestaurant = state.result.restaurants;
              if (listRestaurant.length == state.result.founded) {
                return WillPopScope(
                  child: Container(
                    width: double.infinity,
                    height: 2000,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CustomSearchBox(provider: state),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Showing ${listRestaurant.length} result',
                                style: TextStyle(
                                    fontWeight: FontWeight.w500, fontSize: 22),
                              ),
                              Text("with '${_textController.text}' keyword"),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        ButtonMain(restaurants: listRestaurant),
                      ],
                    ),
                  ),
                  onWillPop: () async {
                    state.reset();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => MyHomePage()),
                        (Route<dynamic> route) => false);

                    return false;
                  },
                );
              } else {
                return Column(children: [
                  CustomSearchBox(provider: state),
                  CircularProgressIndicator(),
                ]);
              }
            } else {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CustomSearchBox(provider: state),
                    Image.network(
                        'https://i.ibb.co/FkpWQ4w/nodataflutterprojek.png'),
                    Text('No Data Found',
                        style: Theme.of(context).textTheme.headline4),
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class CustomSearchBox extends StatelessWidget {
  final SearchProvider provider;
  CustomSearchBox({@required this.provider});

  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(
          child: TextField(
            focusNode: _submitFocus,
            controller: _textController,
            textInputAction: TextInputAction.done,
            onSubmitted: (value) {
              provider.fetchSearchResult(_textController.text);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Insert search keywords',
            ),
          ),
        ),
      ],
    );
  }
}
