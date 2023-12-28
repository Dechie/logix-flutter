import 'package:flutter/material.dart';
import 'package:logixx/screens/splah_screen.dart';
import 'package:logixx/services/sqlite/db_helper.dart';
import 'package:logixx/utils/constants.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //DatabaseHelper dbHelper =
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'my app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: GlobalConstants.mainBlue),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
