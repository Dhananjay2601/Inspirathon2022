// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  static String id = "cart page";
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[300],
      appBar: AppBar(
        title: Text('Cart Page'),
        leading: Padding(
          padding: const EdgeInsets.only(left: 8),
          // child: appLogo,
        ),
        iconTheme: IconThemeData(color: Colors.black),
        backgroundColor: Colors.blueGrey[900],
      ),
      body: Container(),
    );
  }
}
