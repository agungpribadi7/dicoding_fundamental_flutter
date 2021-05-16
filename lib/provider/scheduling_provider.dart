import 'package:android_alarm_manager/android_alarm_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:submission2/utils/background_service.dart';
import 'package:submission2/utils/date_time_helper.dart';

class SchedulingProvider extends ChangeNotifier {
  bool _isScheduld = false;
  bool get isSchedule => _isScheduld;

  Future<bool> scheduleNews(bool value) async {
    _isScheduld = value;
    if (_isScheduld) {
      print('Scheduling News Activated');
      notifyListeners();
      return await AndroidAlarmManager.periodic(
        Duration(hours: 24),
        1,
        BackgroundService.callback,
        startAt: DateTimeHelper.format(),
        exact: true,
        wakeup: true,
      );
    } else {
      print('Scheduling News Canceled');
      notifyListeners();
      return await AndroidAlarmManager.cancel(1);
    }
  }
}
