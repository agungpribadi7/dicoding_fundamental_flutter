import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:submission2/model/api_service.dart';
import 'package:submission2/model/restaurant_decode.dart';
import 'package:submission2/provider/db_provider.dart';
import 'package:submission2/provider/review_provider.dart';
import 'package:submission2/provider/scheduling_provider.dart';
import 'package:submission2/ui/buttom_main.dart';
import 'package:submission2/custom_theme.dart';
import 'package:submission2/ui/detail_restaurant.dart';
import 'package:submission2/provider/search_provider.dart';
import 'package:submission2/ui/favorite_display.dart';
import 'package:submission2/ui/review_list.dart';
import 'package:submission2/ui/search_restaurant.dart';
import 'package:submission2/ui/settings_display.dart';
import 'package:submission2/ui/top_main.dart';
import 'package:provider/provider.dart';
import 'package:submission2/provider/connectivity_provider.dart';
import 'package:connectivity/connectivity.dart';
import 'package:submission2/no_internet.dart';
import 'package:submission2/utils/background_service.dart';
import 'dart:io';
import 'package:submission2/utils/navigation.dart';
import 'package:submission2/utils/notification_helper.dart';
import 'package:android_alarm_manager/android_alarm_manager.dart';

bool _cekInternet = false;
GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  try {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      _cekInternet = true;
    }
  } on SocketException catch (_) {
    _cekInternet = false;
  }
  WidgetsFlutterBinding.ensureInitialized();
  final NotificationHelper _notificationHelper = NotificationHelper();
  final BackgroundService _service = BackgroundService();
  _service.initializeIsolate();
  if (Platform.isAndroid) {
    await AndroidAlarmManager.initialize();
  }
  await _notificationHelper.initNotification(flutterLocalNotificationsPlugin);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    if (_cekInternet) {
      return MultiProvider(
        providers: [
          ChangeNotifierProvider<SearchProvider>(
            create: (_) => SearchProvider(
              apiService: ApiService(),
            ),
          ),
          ChangeNotifierProvider<ReviewProvider>(
            create: (_) => ReviewProvider(
              apiService: ApiService(),
            ),
          ),
          ChangeNotifierProvider(
            create: (_) {
              ConnectivityChangeNotifier changeNotifier =
                  ConnectivityChangeNotifier();
              changeNotifier.initialLoad();
              return changeNotifier;
            },
          ),
          ChangeNotifierProvider(
            create: (_) => SchedulingProvider(),
          ),
          ChangeNotifierProvider(
            create: (_) => DbProvider(),
          ),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          navigatorKey: navigatorKey,
          theme: CustomTheme.lightTheme,
          darkTheme: CustomTheme.darkTheme,
          initialRoute: MyHomePage.routeName,
          routes: {
            DetailRestaurant.routeName: (context) => DetailRestaurant(
                  id: ModalRoute.of(context).settings.arguments,
                ),
            MyHomePage.routeName: (context) => MyHomePage(),
            SearchRestaurant.routeName: (context) => SearchRestaurant(),
            ReviewList.routeName: (context) => ReviewList(
                  detail: ModalRoute.of(context).settings.arguments,
                ),
            SettingsPage.routeName: (context) => SettingsPage(),
            FavoriteDisplay.routeName: (context) => FavoriteDisplay(),
          },
        ),
      );
    } else {
      return MaterialApp(
        title: 'Flutter Demo',
        home: NoInternet(),
      );
    }
  }
}

class MyHomePage extends StatefulWidget {
  static const routeName = '/home';

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<RestaurantApi> allRestaurants = ApiService().getAllRestaurants();
  final NotificationHelper _notificationHelper = NotificationHelper();
  @override
  void initState() {
    super.initState();

    _notificationHelper.configureSelectNotificationSubject(
        context, DetailRestaurant.routeName);
  }

  @override
  void dispose() {
    super.dispose();
    selectNotificationSubject.close();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Submission 1'),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    Navigator.pushNamed(context, SearchRestaurant.routeName);
                  },
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.settings),
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context) {
                    return Constants.choices.map(
                      (String choice) {
                        return PopupMenuItem<String>(
                          value: choice,
                          child: Text(choice),
                        );
                      },
                    ).toList();
                  },
                ),
              ],
            ),
          )
        ],
      ),
      body: Consumer<ConnectivityChangeNotifier>(
        builder: (BuildContext context,
            ConnectivityChangeNotifier connectivityChangeNotifier,
            Widget child) {
          if (connectivityChangeNotifier.connectivity ==
                  ConnectivityResult.wifi ||
              connectivityChangeNotifier.connectivity ==
                  ConnectivityResult.mobile) {
            return FutureBuilder(
              future: allRestaurants,
              builder: (context, snapshot) {
                var state = snapshot.connectionState;

                if (state != ConnectionState.done) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state != ConnectionState.waiting) {
                  if (snapshot.hasData) {
                    var restaurantApi = snapshot.data;

                    return Column(
                      children: [
                        TopMain(),
                        ButtonMain(restaurants: restaurantApi.restaurants),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text("${snapshot.error}"),
                    );
                  } else {
                    return Text('');
                  }
                } else {
                  return Text('');
                }
              },
            );
          } else {
            return NoInternet();
          }
        },
      ),
    );
  }
}

class Constants {
  static const String FirstItem = 'Settings';
  static const String SecondItem = 'Favorites';

  static const List<String> choices = <String>[
    FirstItem,
    SecondItem,
  ];
}

void choiceAction(String choice) {
  if (choice == Constants.FirstItem) {
    Navigator.pushNamed(_scaffoldKey.currentContext, SettingsPage.routeName);
  } else if (choice == Constants.SecondItem) {
    Navigator.pushNamed(_scaffoldKey.currentContext, FavoriteDisplay.routeName);
  }
}
