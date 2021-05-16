import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:submission2/model/api_service.dart';
import 'package:submission2/model/restaurant_decode.dart';
import 'package:submission2/provider/scheduling_provider.dart';
import 'package:submission2/utils/custom_dialog.dart';
import 'package:provider/provider.dart';
import 'dart:io';

class SettingsPage extends StatefulWidget {
  static final routeName = '/settings';
  static const notifPrefs = 'notifResto';

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  var _valuePref = false;
  final Future<RestaurantApi> allRestaurants = ApiService().getAllRestaurants();

  void _saveResult(result, SchedulingProvider provider) async {
    if (Platform.isIOS) {
      customDialog(context);
    } else {
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool(SettingsPage.notifPrefs, result);
      provider.scheduleNews(result);
    }
  }

  void _getResult() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _valuePref = prefs.getBool(SettingsPage.notifPrefs) ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getResult();
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Consumer<SchedulingProvider>(
        builder: (context, provider, _) {
          return CheckboxListTile(
            activeColor: Colors.pink[300],
            dense: true,
            //font change
            title: new Text(
              'Restaurant Notification',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5),
            ),
            value: _valuePref,
            secondary: const Icon(Icons.notifications),
            onChanged: (bool val) {
              _saveResult(!_valuePref, provider);
            },
          );
        },
      ),
    );
  }
}
