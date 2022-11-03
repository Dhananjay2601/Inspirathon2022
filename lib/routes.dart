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
import 'package:inspirathon/pages/cart_page.dart';
import 'package:inspirathon/pages/home_page.dart';
import 'package:inspirathon/pages/reset_page.dart';
import 'package:inspirathon/pages/login_page.dart';
import 'package:inspirathon/pages/signUp_page.dart';

/// Rutas
Map<String, WidgetBuilder> routes = {
  "/": (context) => const LoginPage(),
  // HomePage.id: (context) => const HomePage(),
  // AddAgent.id: (context) => const AddAgent(),
  // AgentProperty.id: (context) => const AgentProperty(),
  // AddProperty.id: (context) => const AddProperty(),
  // HotelAgents.id: (context) => const HotelAgents(),
  // ExecutiveProperty.id: (context) => const ExecutiveProperty(),
  ResetPage.id: (context) => const ResetPage(),
  SignUpPage.id: (context) => const SignUpPage(),
  HomePage.id: (context) => HomePage(),
  CartPage.id: (context) => const CartPage(),
};
