import 'package:dacapo/model/camera_manager.dart';
import 'package:dacapo/model/repository/score_dao.dart';
import 'package:dacapo/util/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import ' view/menu_page.dart';

void main() {
  logger.info('start dacapo!!');
  logger.info('output log level is ${logger.level.name}');

  // Reference
  // https://hiyoko-programming.com/1575/
  WidgetsFlutterBinding.ensureInitialized();
  // 横向きに変更
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
  CameraManager.initialize();
  ScoreDao.dao.initialize();
  runApp(const DaCapoApp());
}

class DaCapoApp extends StatelessWidget {
  const DaCapoApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,

        // setting for dacapo!
        appBarTheme: const AppBarTheme(color: Color.fromARGB(255, 0, 0, 0)),
        textTheme:
            GoogleFonts.sawarabiGothicTextTheme(Theme.of(context).textTheme),
      ),
      home: MenuPage(),
    );
  }
}
