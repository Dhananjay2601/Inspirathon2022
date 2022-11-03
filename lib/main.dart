// ignore_for_file: prefer_const_constructors, depend_on_referenced_packages, avoid_print
import 'package:flutter/material.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/pages/login_page.dart';
import 'package:inspirathon/routes.dart' as router;
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  print(token);
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;
  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(primaryColor: Colors.orange),
        debugShowCheckedModeBanner: false,
        // home: LoginPage(),
        initialRoute: token != null ? HomePage.id : '/',
        routes: router.routes);
  }
}
