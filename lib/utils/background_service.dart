import 'dart:isolate';
import 'dart:ui';
import 'package:submission2/utils/notification_helper.dart';
import 'package:submission2/model/api_service.dart';
import 'package:submission2/model/restaurant_decode.dart';
import 'package:submission2/main.dart';
import 'dart:math';

final ReceivePort port = ReceivePort();

class BackgroundService {
  static BackgroundService _instance;
  static String _isolateName = 'isolate';
  static SendPort _uiSendPort;

  BackgroundService._internal() {
    _instance = this;
  }

  factory BackgroundService() => _instance ?? BackgroundService._internal();

  void initializeIsolate() {
    IsolateNameServer.registerPortWithName(
      port.sendPort,
      _isolateName,
    );
  }

  static Future<void> callback() async {
    print('Alarm fired!');

    final NotificationHelper _notificationHelper = NotificationHelper();
    final RestaurantApi allRestaurants = await ApiService().getAllRestaurants();
    var rng = new Random();
    int randomIdx = rng.nextInt(allRestaurants.count - 1);

    await _notificationHelper.scheduleNotificationPeriodically(
        flutterLocalNotificationsPlugin,
        allRestaurants.restaurants[randomIdx].name,
        allRestaurants.restaurants[randomIdx].description,
        allRestaurants.restaurants[randomIdx].id,
        allRestaurants.restaurants[randomIdx].pictureId);

    _uiSendPort ??= IsolateNameServer.lookupPortByName(_isolateName);
    _uiSendPort?.send(null);
  }

  Future<void> someTask() async {
    print('Updated data from the background isolate');
  }
}
