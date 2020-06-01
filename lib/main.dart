import 'package:IITDAPP/modules/dashboard/dashboard.dart';
import 'package:IITDAPP/routes/router.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  try {
    await GlobalConfiguration().loadFromAsset('secrets');
    SyncfusionLicense.registerLicense(
        GlobalConfiguration().getString('calendar_api_key'));
  }catch(e){
    print('secrets.json file is required');
  }

  runApp(
      MaterialApp(
        title: 'IITD APP',
        theme: ThemeData(
            primarySwatch: Colors.indigo
        ),
        home: Dashboard(),
        onGenerateRoute: Router.generateRoute,
//        routes:  {
//          Routes.dashboard: (context) => Dashboard(),
//          Routes.attendance: (context) => Attendance(),
//          Routes.explore: (context) => Explore(),
//        },
      )
  );
}
