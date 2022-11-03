// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, sort_child_properties_last, unnecessary_new, use_key_in_widget_constructors, unused_import
// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:inspirathon/pages/cart_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static String id = "Home_page";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SharedPreferences sharedPreferences;
  String searchString = "";
  TextEditingController editingController = TextEditingController();
  Widget listView() {
    return Container(
      // ignore: prefer_const_literals_to_create_immutables
      child: Column(children: [
        Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 10),
          child: TextField(
            cursorColor: Colors.black,
            onChanged: (value) {
              setState(() {
                searchString = value.toLowerCase();
              });
            },
            controller: editingController,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.orange[300],
              hintText: "Search Locations",
              prefixIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
              ),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                  borderRadius: BorderRadius.circular(40)),
            ),
          ),
        ),
        Container(
          height: 500,
          child: ListView.builder(
              itemCount: 5,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    tileColor: Colors.orange,
                    title: Text('name'),
                    subtitle: Text('Locality'),
                    trailing: Text('Rating'),
                  ),
                );
              }),
        )
      ]),
    );
  }

  // Image appLogo = new Image(
  //   image: ExactAssetImage("assets/goa-app-bar.png"),
  //   height: 50.0,
  //   width: 50.0,
  //   alignment: FractionalOffset.center,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey[500],
        appBar: AppBar(
          title: Text('Home Page'),
          leading: Padding(
            padding: const EdgeInsets.only(left: 8),
            // child: appLogo,
          ),
          iconTheme: IconThemeData(color: Colors.black),
          backgroundColor: Colors.blueGrey[900],
        ),
        endDrawer: Drawer(
          backgroundColor: Colors.blueGrey[500],
          width: 200,
          // drawer logout button
          child: Center(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    children: [
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, CartPage.id);
                          },
                          child: Text(
                            'Cart',
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blueGrey[900],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Text(
                              'Log Out',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          onPressed: () async {
                            // logOut user and clear user data from local storage
                            showDialog(
                                context: context,
                                builder: (ctxt) {
                                  return ConstrainedBox(
                                    constraints:
                                        BoxConstraints(maxHeight: 100.0),
                                    child: AlertDialog(
                                      backgroundColor: Colors.orange[100],
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10))),
                                      contentPadding: EdgeInsets.all(0),
                                      title: Center(
                                        child: Text(
                                          "Logout!",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30),
                                        ),
                                      ),
                                      content: Padding(
                                        padding: const EdgeInsets.all(30.0),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            Text(
                                              "Do you really want to logout?",
                                              textAlign: TextAlign.center,
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(height: 40),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                SizedBox(
                                                  width: 115,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                            backgroundColor:
                                                                Colors.orange[
                                                                    600]),
                                                    child: Text(
                                                      "Cancel",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                SizedBox(
                                                  width: 115,
                                                  height: 50,
                                                  child: ElevatedButton(
                                                    style: ElevatedButton
                                                        .styleFrom(
                                                      backgroundColor:
                                                          Colors.orange[600],
                                                    ),
                                                    child: Text(
                                                      "Logout",
                                                      style: TextStyle(
                                                          fontSize: 20,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    onPressed: () async {
                                                      SharedPreferences prefs =
                                                          await SharedPreferences
                                                              .getInstance();
                                                      prefs.remove('token');
                                                      // Navigator.popAndPushNamed(
                                                      //     context, '/');
                                                      Navigator.of(context)
                                                          .pushNamedAndRemoveUntil(
                                                              '/',
                                                              (Route<dynamic>
                                                                      route) =>
                                                                  false);
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                });
                          }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        body: listView());
  }
}
