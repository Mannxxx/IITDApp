import 'package:IITDAPP/modules/attendance/data/attendanceModel.dart';
import 'package:IITDAPP/modules/settings/data/SettingsHandler.dart';
import 'package:IITDAPP/utility/apiHelper.dart';
import 'package:IITDAPP/utility/apiResponse.dart';
import 'package:flutter/material.dart';

class AttendanceProvider with ChangeNotifier {
  ApiResponse<List<AttendanceModel>> data = ApiResponse.loading('Loading');
  final ApiBaseHelper abh = ApiBaseHelper();
  String entryNumber;
  bool loading = false;
  double minimumAttendance;

  void setEntryNumber(String a) {
    if (a.compareTo(entryNumber ?? '') != 0) {
      entryNumber = a;
      fetchData(false);
    }
  }

  Future<void> fetchData([reload = true]) async {
    minimumAttendance =
        (await SettingsHandler.getSettingValue('MinimumAttendance')) / 100;
    print(minimumAttendance);
    data = ApiResponse.loading('Loading');
    if (reload) {
      notifyListeners();
    }
    loading = true;
    try {
      var enToFetch = entryNumber;
      await abh
          .get('http://www.mocky.io/v2/5ebc43f43100004a005b0a9b')
          .then((jsonData) {
        var attendances = <AttendanceModel>[];
        for (var courseJSON in jsonData) {
          var course = AttendanceModel.fromJSON(courseJSON);
          attendances.add(course);
        }
        data = ApiResponse.completed(attendances);
        if (enToFetch == entryNumber) {
          notifyListeners();
        } else {
          print('reloaded');
        }
        loading = false;
      });
    } catch (e) {
      loading = false;
      data = ApiResponse.error(e.toString());
      notifyListeners();
      print(e.toString());
    }
  }
}
