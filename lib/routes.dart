import 'dart:convert';
// import 'package:reseller_apk/pages/home_page.dart';
// import 'package:reseller_apk/pages/hotel%20agent/agents/add_agents.dart';
// import 'package:reseller_apk/pages/hotel%20agent/agents/agent_detail.dart';
// import 'package:reseller_apk/pages/hotel%20agent/agents/edit_agents.dart';
// import 'package:reseller_apk/pages/hotel%20agent/agents/hotel_agents.dart';
// import 'package:reseller_apk/pages/hotel%20agent/property/add_property.dart';
// import 'package:reseller_apk/pages/hotel%20agent/property/agent_property.dart';
// import 'package:reseller_apk/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:inspirathon/pages/checkOut_page.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/pages/locationDetail_page.dart';
import 'package:inspirathon/pages/reset_page.dart';
import 'package:inspirathon/pages/login_page.dart';
import 'package:inspirathon/pages/signUp_page.dart';

/// Rutas
Map<String, WidgetBuilder> routes = {
  "/": (context) => const LoginPage(),
  ResetPage.id: (context) => const ResetPage(),
  SignUpPage.id: (context) => const SignUpPage(),
  HomePage.id: (context) => const HomePage(),
  CheckOutPage.page_id: (context) => CheckOutPage(
        name: '',
        id: '',
        id2: [],
      ),
  LocationDetail.id: (context) => const LocationDetail(
        location_id: '',
      ),
};
